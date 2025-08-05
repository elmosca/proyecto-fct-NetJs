import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/project_entity.dart';
import '../providers/project_providers.dart';
import '../widgets/project_card_widget.dart';
import '../widgets/project_filters_widget.dart';

@RoutePage()
class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  ProjectStatus? _selectedStatus;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    await ref.read(projectsNotifierProvider.notifier).loadProjects(
          search: _searchQuery,
          status: _selectedStatus,
        );
  }

  @override
  Widget build(BuildContext context) {
    final projectsState = ref.watch(projectsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).projects),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navegar a página de creación de proyecto
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Función de creación en desarrollo')),
              );
            },
            tooltip: 'Crear Proyecto',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(),
            tooltip: 'Filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFiltersChips(),
          Expanded(
            child: projectsState.when(
              data: (state) => _buildProjectsList(state),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorWidget(error.toString()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navegar a página de creación de proyecto
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Función de creación en desarrollo')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar proyectos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                    _loadProjects();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        onSubmitted: (value) {
          _loadProjects();
        },
      ),
    );
  }

  Widget _buildFiltersChips() {
    if (_selectedStatus == null && _searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8,
        children: [
          if (_searchQuery.isNotEmpty)
            Chip(
              label: Text('Búsqueda: $_searchQuery'),
              onDeleted: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
                _loadProjects();
              },
            ),
          if (_selectedStatus != null)
            Chip(
              label: Text('Estado: ${_selectedStatus!.displayName}'),
              onDeleted: () {
                setState(() {
                  _selectedStatus = null;
                });
                _loadProjects();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(ProjectsState state) {
    if (state.hasError) {
      return _buildErrorWidget(state.errorMessage ?? 'Error desconocido');
    }

    if (state.projects.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadProjects,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: state.projects.length + (state.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.projects.length) {
            return _buildLoadMoreButton(state);
          }

          final project = state.projects[index];
          return ProjectCardWidget(
            project: project,
            onTap: () => _navigateToProjectDetail(project),
            onEdit: () => _editProject(project),
            onDelete: () => _deleteProject(project),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreButton(ProjectsState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(projectsNotifierProvider.notifier).loadMoreProjects();
          },
          child: const Text('Cargar más proyectos'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No hay proyectos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer proyecto para comenzar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navegar a página de creación de proyecto
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Función de creación en desarrollo')),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear Proyecto'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar proyectos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.red[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProjects,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (context) => ProjectFiltersWidget(
        selectedStatus: _selectedStatus,
        onFiltersChanged: (status) {
          setState(() {
            _selectedStatus = status;
          });
          _loadProjects();
        },
      ),
    );
  }

  void _navigateToProjectDetail(ProjectEntity project) {
    // TODO: Navegar a página de detalle del proyecto
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ver detalles de: ${project.title}')),
    );
  }

  void _editProject(ProjectEntity project) {
    // TODO: Navegar a página de edición del proyecto
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar proyecto: ${project.title}')),
    );
  }

  void _deleteProject(ProjectEntity project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Proyecto'),
        content:
            Text('¿Estás seguro de que quieres eliminar "${project.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(projectsNotifierProvider.notifier)
                    .deleteProject(project.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Proyecto eliminado correctamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar proyecto: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
