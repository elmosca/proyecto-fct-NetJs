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
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.filters = const UserFiltersData(),
    this.totalUsers = 0,
    this.pageSize = 20,
    this.isRefreshing = false,
  });

  final List<UserEntity> users;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final UserFiltersData filters;
  final int totalUsers;
  final int pageSize;
  final bool isRefreshing;

  UsersState copyWith({
    List<UserEntity>? users,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
    UserFiltersData? filters,
    int? totalUsers,
    int? pageSize,
    bool? isRefreshing,
  }) {
    return UsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      filters: filters ?? this.filters,
      totalUsers: totalUsers ?? this.totalUsers,
      pageSize: pageSize ?? this.pageSize,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  bool get hasActiveFilters => filters.hasActiveFilters;
  bool get canLoadMore => hasMore && !isLoading && !isLoadingMore;
  int get totalPages => (totalUsers / pageSize).ceil();
  double get progressPercentage =>
      totalUsers > 0 ? (users.length / totalUsers) : 0.0;
}

// Notifier para gestionar el estado de usuarios
class UsersNotifier extends StateNotifier<UsersState> {
  UsersNotifier() : super(const UsersState()) {
    _getUsersUseCase = getIt<GetUsersUseCase>();
  }

  late final GetUsersUseCase _getUsersUseCase;

  /// Carga la primera página de usuarios
  Future<void> loadUsers({bool refresh = false}) async {
    if (state.isLoading && !refresh) return;

    state = state.copyWith(
      isLoading: !refresh,
      isRefreshing: refresh,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
    );

    try {
      final users = await _getUsersUseCase(
        page: refresh ? 1 : state.currentPage,
        limit: state.pageSize,
        search: state.filters.search,
        role: state.filters.role,
        isActive: state.filters.isActive,
      );

      // Aplicar ordenamiento local si es necesario
      final sortedUsers = _sortUsers(users);

      state = state.copyWith(
        users: refresh ? sortedUsers : [...state.users, ...sortedUsers],
        isLoading: false,
        isRefreshing: false,
        hasMore: users.length == state.pageSize,
        currentPage: refresh ? 2 : state.currentPage + 1,
        totalUsers: refresh ? users.length : state.totalUsers + users.length,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: e.toString(),
      );
    }
  }

  /// Carga la siguiente página de usuarios
  Future<void> loadMoreUsers() async {
    if (!state.canLoadMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final users = await _getUsersUseCase(
        page: state.currentPage,
        limit: state.pageSize,
        search: state.filters.search,
        role: state.filters.role,
        isActive: state.filters.isActive,
      );

      if (users.isNotEmpty) {
        final sortedUsers = _sortUsers(users);
        state = state.copyWith(
          users: [...state.users, ...sortedUsers],
          isLoadingMore: false,
          hasMore: users.length == state.pageSize,
          currentPage: state.currentPage + 1,
          totalUsers: state.totalUsers + users.length,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
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

  /// Actualiza los filtros de búsqueda
  void updateFilters(UserFiltersData filters) {
    state = state.copyWith(
      filters: filters,
      currentPage: 1,
      hasMore: true,
      totalUsers: 0,
    );
    loadUsers(refresh: true);
  }

  /// Actualiza solo la búsqueda de texto
  void updateSearch(String search) {
    final newFilters = state.filters.copyWith(search: search);
    state = state.copyWith(
      filters: newFilters,
      currentPage: 1,
      hasMore: true,
      totalUsers: 0,
    );
    loadUsers(refresh: true);
  }

  /// Limpia los filtros
  void clearFilters() {
    state = state.copyWith(
      filters: const UserFiltersData(),
      currentPage: 1,
      hasMore: true,
      totalUsers: 0,
    );
    loadUsers(refresh: true);
  }

  /// Cambia el tamaño de página
  void changePageSize(int newPageSize) {
    if (newPageSize != state.pageSize) {
      state = state.copyWith(
        pageSize: newPageSize,
        currentPage: 1,
        hasMore: true,
        totalUsers: 0,
      );
      loadUsers(refresh: true);
    }
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
    state = state.copyWith(
      users: updatedUsers,
      totalUsers: state.totalUsers - 1,
    );
  }

  /// Añade un nuevo usuario a la lista
  void addUserToList(UserEntity newUser) {
    state = state.copyWith(
      users: [newUser, ...state.users],
      totalUsers: state.totalUsers + 1,
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

  /// Reinicia la paginación
  void resetPagination() {
    state = state.copyWith(
      currentPage: 1,
      hasMore: true,
      totalUsers: 0,
    );
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

// Provider para opciones de tamaño de página
final pageSizeOptionsProvider = Provider<List<int>>((ref) {
  return [10, 20, 50, 100];
});
