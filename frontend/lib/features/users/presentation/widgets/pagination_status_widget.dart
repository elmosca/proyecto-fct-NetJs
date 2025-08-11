import 'package:fct_frontend/features/users/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationStatusWidget extends ConsumerWidget {
  const PaginationStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);

    if (usersState.users.isEmpty && !usersState.isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getStatusColor(usersState).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(usersState).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(usersState),
            color: _getStatusColor(usersState),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            _getStatusText(usersState),
            style: TextStyle(
              color: _getStatusColor(usersState),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (usersState.isLoadingMore) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStatusColor(usersState),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(UsersState state) {
    if (state.isLoading || state.isLoadingMore) {
      return Colors.blue;
    }
    if (state.error != null) {
      return Colors.red;
    }
    if (!state.hasMore && state.users.isNotEmpty) {
      return Colors.green;
    }
    if (state.hasActiveFilters) {
      return Colors.orange;
    }
    return Colors.grey;
  }

  IconData _getStatusIcon(UsersState state) {
    if (state.isLoading || state.isLoadingMore) {
      return Icons.sync;
    }
    if (state.error != null) {
      return Icons.error_outline;
    }
    if (!state.hasMore && state.users.isNotEmpty) {
      return Icons.check_circle;
    }
    if (state.hasActiveFilters) {
      return Icons.filter_list;
    }
    return Icons.list;
  }

  String _getStatusText(UsersState state) {
    if (state.isLoading) {
      return 'Cargando usuarios...';
    }
    if (state.isLoadingMore) {
      return 'Cargando más...';
    }
    if (state.error != null) {
      return 'Error al cargar';
    }
    if (!state.hasMore && state.users.isNotEmpty) {
      return 'Todos cargados (${state.users.length})';
    }
    if (state.hasActiveFilters) {
      return 'Filtrado (${state.users.length})';
    }
    return '${state.users.length} usuarios';
  }
}
