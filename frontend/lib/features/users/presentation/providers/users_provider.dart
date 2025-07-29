import 'package:fct_frontend/core/di/injection_container.dart';
import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/features/users/domain/usecases/usecases.dart';
import 'package:fct_frontend/features/users/presentation/widgets/user_filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Estado de la lista de usuarios
class UsersState {
  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.filters = const UserFiltersData(),
    this.totalUsers = 0,
  });

  final List<UserEntity> users;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final UserFiltersData filters;
  final int totalUsers;

  UsersState copyWith({
    List<UserEntity>? users,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    UserFiltersData? filters,
    int? totalUsers,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      filters: filters ?? this.filters,
      totalUsers: totalUsers ?? this.totalUsers,
    );
  }

  bool get hasActiveFilters => filters.hasActiveFilters;
}

// Notifier para gestionar el estado de usuarios
class UsersNotifier extends StateNotifier<UsersState> {
  UsersNotifier() : super(const UsersState()) {
    _getUsersUseCase = getIt<GetUsersUseCase>();
  }

  late final GetUsersUseCase _getUsersUseCase;

  /// Carga la primera página de usuarios
  Future<void> loadUsers({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
    );

    try {
      final users = await _getUsersUseCase(
        page: refresh ? 1 : state.currentPage,
        limit: 10,
        search: state.filters.search,
        role: state.filters.role,
        isActive: state.filters.isActive,
      );

      // Aplicar ordenamiento local si es necesario
      final sortedUsers = _sortUsers(users);

      state = state.copyWith(
        users: refresh ? sortedUsers : [...state.users, ...sortedUsers],
        isLoading: false,
        hasMore: users.length == 10,
        currentPage: refresh ? 2 : state.currentPage + 1,
        totalUsers: refresh ? users.length : state.totalUsers + users.length,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Ordena los usuarios según los filtros
  List<UserEntity> _sortUsers(List<UserEntity> users) {
    final sortedUsers = List<UserEntity>.from(users);

    switch (state.filters.sortBy) {
      case 'name':
        sortedUsers.sort((a, b) {
          final comparison = '${a.firstName} ${a.lastName}'
              .compareTo('${b.firstName} ${b.lastName}');
          return state.filters.sortOrder == 'desc' ? -comparison : comparison;
        });
        break;
      case 'email':
        sortedUsers.sort((a, b) {
          final comparison = a.email.compareTo(b.email);
          return state.filters.sortOrder == 'desc' ? -comparison : comparison;
        });
        break;
      case 'role':
        sortedUsers.sort((a, b) {
          final comparison = a.role.compareTo(b.role);
          return state.filters.sortOrder == 'desc' ? -comparison : comparison;
        });
        break;
      case 'lastName':
        sortedUsers.sort((a, b) {
          final comparison = a.lastName.compareTo(b.lastName);
          return state.filters.sortOrder == 'desc' ? -comparison : comparison;
        });
        break;
      case 'createdAt':
        sortedUsers.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1900);
          final bDate = b.createdAt ?? DateTime(1900);
          final comparison = aDate.compareTo(bDate);
          return state.filters.sortOrder == 'desc' ? -comparison : comparison;
        });
        break;
    }

    return sortedUsers;
  }

  /// Carga la siguiente página de usuarios
  Future<void> loadMoreUsers() async {
    if (state.isLoading || !state.hasMore) return;
    await loadUsers();
  }

  /// Actualiza los filtros de búsqueda
  void updateFilters(UserFiltersData filters) {
    state = state.copyWith(filters: filters);
    loadUsers(refresh: true);
  }

  /// Actualiza solo la búsqueda de texto
  void updateSearch(String search) {
    final newFilters = state.filters.copyWith(search: search);
    state = state.copyWith(filters: newFilters);
    loadUsers(refresh: true);
  }

  /// Limpia los filtros
  void clearFilters() {
    state = state.copyWith(
      filters: const UserFiltersData(),
    );
    loadUsers(refresh: true);
  }

  /// Actualiza un usuario en la lista
  void updateUserInList(UserEntity updatedUser) {
    final updatedUsers = state.users.map((user) {
      return user.id == updatedUser.id ? updatedUser : user;
    }).toList();

    state = state.copyWith(users: updatedUsers);
  }

  /// Elimina un usuario de la lista
  void removeUserFromList(String userId) {
    final updatedUsers =
        state.users.where((user) => user.id != userId).toList();
    state = state.copyWith(users: updatedUsers);
  }

  /// Añade un nuevo usuario a la lista
  void addUserToList(UserEntity newUser) {
    state = state.copyWith(
      users: [newUser, ...state.users],
    );
  }

  /// Limpia el error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Obtiene estadísticas de usuarios
  Map<String, int> getUsersStats() {
    final stats = <String, int>{};

    for (final user in state.users) {
      stats[user.role] = (stats[user.role] ?? 0) + 1;
    }

    return stats;
  }

  /// Filtra usuarios por texto de búsqueda
  List<UserEntity> searchUsers(String query) {
    if (query.isEmpty) return state.users;

    final lowercaseQuery = query.toLowerCase();
    return state.users.where((user) {
      return user.firstName.toLowerCase().contains(lowercaseQuery) ||
          user.lastName.toLowerCase().contains(lowercaseQuery) ||
          user.email.toLowerCase().contains(lowercaseQuery) ||
          user.role.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}

// Provider para el estado de usuarios
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  return UsersNotifier();
});

// Provider para estadísticas de usuarios
final usersStatsProvider = Provider<Map<String, int>>((ref) {
  final usersState = ref.watch(usersProvider);
  return usersState.users.fold<Map<String, int>>({}, (stats, user) {
    stats[user.role] = (stats[user.role] ?? 0) + 1;
    return stats;
  });
});
