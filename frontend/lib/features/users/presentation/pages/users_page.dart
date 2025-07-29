import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/error_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/users/domain/entities/permission_enum.dart';
import 'package:fct_frontend/features/users/presentation/providers/users_provider.dart';
import 'package:fct_frontend/features/users/presentation/widgets/authorized_widget.dart';
import 'package:fct_frontend/features/users/presentation/widgets/pagination_controls_widget.dart';
import 'package:fct_frontend/features/users/presentation/widgets/pagination_status_widget.dart';
import 'package:fct_frontend/features/users/presentation/widgets/quick_search_widget.dart';
import 'package:fct_frontend/features/users/presentation/widgets/user_filters.dart';
import 'package:fct_frontend/features/users/presentation/widgets/user_list_item.dart';
import 'package:fct_frontend/features/users/presentation/widgets/users_stats_widget.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Cargar usuarios al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usersProvider.notifier).loadUsers(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final usersState = ref.read(usersProvider);
    if (usersState.canLoadMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      ref.read(usersProvider.notifier).loadMoreUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.users),
        actions: [
          // Estado de paginación
          PermissionWidget(
            permission: PermissionEnum.usersView,
            child: const PaginationStatusWidget(),
          ),
          const SizedBox(width: 8),
          // Búsqueda rápida
          PermissionWidget(
            permission: PermissionEnum.usersView,
            child: QuickSearchWidget(
              onSearch: (query) {
                ref.read(usersProvider.notifier).updateSearch(query);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Botón de filtros
          PermissionWidget(
            permission: PermissionEnum.usersView,
            child: IconButton(
              icon: Icon(_showFilters
                  ? Icons.filter_list
                  : Icons.filter_list_outlined),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ),
          // Botón de crear usuario
          PermissionWidget(
            permission: PermissionEnum.usersCreate,
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Implementar creación de usuario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad de creación en desarrollo'),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(usersProvider.notifier).loadUsers(refresh: true);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Estadísticas de usuarios
          PermissionWidget(
            permission: PermissionEnum.usersView,
            child: const UsersStatsWidget(),
          ),

          // Filtros avanzados
          if (_showFilters)
            PermissionWidget(
              permission: PermissionEnum.usersView,
              child: UserFilters(
                onFiltersChanged: (filters) {
                  ref.read(usersProvider.notifier).updateFilters(filters);
                },
                onClearFilters: () {
                  ref.read(usersProvider.notifier).clearFilters();
                },
              ),
            ),

          // Lista de usuarios
          Expanded(
            child: _buildUsersList(usersState),
          ),

          // Controles de paginación
          PermissionWidget(
            permission: PermissionEnum.usersView,
            child: const PaginationControlsWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(UsersState state) {
    if (state.isLoading && state.users.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.users.isEmpty) {
      return ErrorDisplayWidget(
        message: state.error!,
        onRetry: () {
          ref.read(usersProvider.notifier).clearError();
          ref.read(usersProvider.notifier).loadUsers(refresh: true);
        },
      );
    }

    if (state.users.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.people,
        title: 'No hay usuarios',
        message: state.hasActiveFilters
            ? 'No se encontraron usuarios con los filtros aplicados'
            : 'No hay usuarios registrados en el sistema',
        onAction: () {
          if (state.hasActiveFilters) {
            ref.read(usersProvider.notifier).clearFilters();
          } else {
            ref.read(usersProvider.notifier).loadUsers(refresh: true);
          }
        },
        actionLabel: state.hasActiveFilters ? 'Limpiar filtros' : 'Recargar',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(usersProvider.notifier).loadUsers(refresh: true);
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.users.length) {
            // Indicador de carga para paginación
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Cargando más usuarios...'),
                  ],
                ),
              ),
            );
          }

          final user = state.users[index];
          return UserListItem(
            user: user,
            onEdit: () {
              // TODO: Implementar edición de usuario
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad de edición en desarrollo'),
                ),
              );
            },
            onDelete: () {
              // TODO: Implementar eliminación de usuario
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad de eliminación en desarrollo'),
                ),
              );
            },
            onToggleStatus: () {
              // TODO: Implementar cambio de estado
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Funcionalidad de cambio de estado en desarrollo'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
