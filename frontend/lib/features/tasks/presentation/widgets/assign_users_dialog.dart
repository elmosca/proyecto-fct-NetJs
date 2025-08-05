import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/user_card.dart';
import 'package:fct_frontend/features/users/domain/entities/user_entity.dart';
import 'package:fct_frontend/features/users/presentation/providers/user_providers.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignUsersDialog extends ConsumerStatefulWidget {
  final TaskEntity task;

  const AssignUsersDialog({
    super.key,
    required this.task,
  });

  @override
  ConsumerState<AssignUsersDialog> createState() => _AssignUsersDialogState();
}

class _AssignUsersDialogState extends ConsumerState<AssignUsersDialog> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedRole = 'all';
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.assignUserToTask,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filtros
            _buildFilters(context, l10n),
            const SizedBox(height: 16),

            // Contenido principal
            Expanded(
              child: _buildContent(context, l10n),
            ),

            // Botones de acción
            const SizedBox(height: 16),
            _buildActions(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        // Campo de búsqueda
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.searchUsers,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(width: 16),

        // Filtro por rol
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: InputDecoration(
              labelText: l10n.filterByRole,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: 'all',
                child: Text(l10n.allRoles),
              ),
              DropdownMenuItem(
                value: 'student',
                child: Text(l10n.student),
              ),
              DropdownMenuItem(
                value: 'tutor',
                child: Text(l10n.tutor),
              ),
              DropdownMenuItem(
                value: 'admin',
                child: Text(l10n.admin),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedRole = value ?? 'all';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    // Usar providers para obtener usuarios
    final filters = {'search': _searchQuery, 'role': _selectedRole};
    final filteredUsersAsync = ref.watch(filteredUsersProvider(filters));
    final assignedUsersAsync =
        ref.watch(assignedUsersProvider(widget.task.assignees));

    return Column(
      children: [
        // Usuarios asignados
        _buildAssignedUsersSection(context, l10n, assignedUsersAsync),
        const SizedBox(height: 16),

        // Separador
        const Divider(),
        const SizedBox(height: 16),

        // Usuarios disponibles
        _buildAvailableUsersSection(context, l10n, filteredUsersAsync),
      ],
    );
  }

  Widget _buildAssignedUsersSection(BuildContext context, AppLocalizations l10n,
      AsyncValue<List<UserEntity>> assignedUsersAsync) {
    return assignedUsersAsync.when(
      data: (assignedUsers) {
        if (assignedUsers.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.assignedUsers,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    l10n.noUsersAssigned,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.assignedUsers,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                itemCount: assignedUsers.length,
                itemBuilder: (context, index) {
                  final user = assignedUsers[index];
                  return UserCard(
                    user: user,
                    isAssigned: true,
                    onUnassign: () => _unassignUser(user.id),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildAvailableUsersSection(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<UserEntity>> filteredUsersAsync,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.availableUsers,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredUsersAsync.when(
              data: (availableUsers) {
                if (availableUsers.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.people_outline,
                    title: l10n.noUsersAvailable,
                    message:
                        'No se encontraron usuarios que coincidan con los filtros',
                  );
                }

                return ListView.builder(
                  itemCount: availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = availableUsers[index];
                    final isAssigned = widget.task.assignees.contains(user.id);

                    return UserCard(
                      user: user,
                      isAssigned: isAssigned,
                      onAssign: isAssigned ? null : () => _assignUser(user.id),
                      onUnassign:
                          isAssigned ? () => _unassignUser(user.id) : null,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  Future<void> _assignUser(String userId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar asignación real usando el provider de tareas
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).userAssignedSuccessfully)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${AppLocalizations.of(context).errorAssigningUser}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _unassignUser(String userId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar desasignación real usando el provider de tareas
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context).userUnassignedSuccessfully)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${AppLocalizations.of(context).errorUnassigningUser}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
