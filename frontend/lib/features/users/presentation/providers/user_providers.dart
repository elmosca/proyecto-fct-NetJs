import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para el repositorio de usuarios
final userRepositoryProvider = Provider<UserRepository>((ref) {
  // TODO: Implementar inyección de dependencias real
  throw UnimplementedError('UserRepository not implemented yet');
});

// Provider para obtener todos los usuarios
final usersProvider = FutureProvider<List<UserEntity>>((ref) async {
  final repository = ref.read(userRepositoryProvider);
  return await repository.getUsers();
});

// Provider para obtener usuarios por rol
final usersByRoleProvider =
    FutureProvider.family<List<UserEntity>, String>((ref, role) async {
  final users = await ref.read(usersProvider.future);
  if (role == 'all') return users;
  return users
      .where((user) => user.role.toLowerCase() == role.toLowerCase())
      .toList();
});

// Provider para buscar usuarios
final searchUsersProvider =
    FutureProvider.family<List<UserEntity>, String>((ref, query) async {
  final users = await ref.read(usersProvider.future);
  if (query.isEmpty) return users;

  return users.where((user) {
    final searchQuery = query.toLowerCase();
    return user.firstName.toLowerCase().contains(searchQuery) ||
        user.lastName.toLowerCase().contains(searchQuery) ||
        user.email.toLowerCase().contains(searchQuery);
  }).toList();
});

// Provider para obtener usuarios filtrados (búsqueda + rol)
final filteredUsersProvider =
    FutureProvider.family<List<UserEntity>, Map<String, String>>(
        (ref, filters) async {
  final searchQuery = filters['search'] ?? '';
  final role = filters['role'] ?? 'all';

  List<UserEntity> users;

  if (searchQuery.isNotEmpty) {
    users = await ref.read(searchUsersProvider(searchQuery).future);
  } else {
    users = await ref.read(usersByRoleProvider(role).future);
  }

  // Aplicar filtro de rol si no es 'all'
  if (role != 'all') {
    users = users
        .where((user) => user.role.toLowerCase() == role.toLowerCase())
        .toList();
  }

  return users;
});

// Provider para obtener un usuario específico
final userByIdProvider =
    FutureProvider.family<UserEntity?, String>((ref, userId) async {
  final users = await ref.read(usersProvider.future);
  try {
    return users.firstWhere((user) => user.id == userId);
  } catch (e) {
    return null;
  }
});

// Provider para obtener usuarios asignados a una tarea
final assignedUsersProvider =
    FutureProvider.family<List<UserEntity>, List<String>>((ref, userIds) async {
  if (userIds.isEmpty) return [];

  final users = await ref.read(usersProvider.future);
  return users.where((user) => userIds.contains(user.id)).toList();
});

// Provider para obtener usuarios disponibles (no asignados)
final availableUsersProvider =
    FutureProvider.family<List<UserEntity>, List<String>>(
        (ref, assignedUserIds) async {
  final users = await ref.read(usersProvider.future);
  return users.where((user) => !assignedUserIds.contains(user.id)).toList();
});
