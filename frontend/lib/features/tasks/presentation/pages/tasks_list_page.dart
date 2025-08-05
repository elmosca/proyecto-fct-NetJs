import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/task_providers.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_card_widget.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_filters_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';

class TasksListPage extends ConsumerStatefulWidget {
  final String? projectId;
  final String? anteprojectId;

  const TasksListPage({
    super.key,
    this.projectId,
    this.anteprojectId,
  });

  @override
  ConsumerState<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends ConsumerState<TasksListPage> {
  String? _selectedStatus;
  String? _selectedPriority;
  String? _assignedUserId;
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksNotifierProvider(
      projectId: widget.projectId,
      anteprojectId: widget.anteprojectId,
      assignedUserId: _assignedUserId,
      status: _selectedStatus != null ? TaskStatus.values.firstWhere(
        (s) => s.name == _selectedStatus,
        orElse: () => TaskStatus.pending,
      ) : null,
      priority: _selectedPriority != null ? TaskPriority.values.firstWhere(
        (p) => p.name == _selectedPriority,
        orElse: () => TaskPriority.medium,
      ) : null,
      searchQuery: _searchQuery,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navegar a página de crear tarea
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(tasksNotifierProvider(
                projectId: widget.projectId,
                anteprojectId: widget.anteprojectId,
                assignedUserId: _assignedUserId,
                status: _selectedStatus != null ? TaskStatus.values.firstWhere(
                  (s) => s.name == _selectedStatus,
                  orElse: () => TaskStatus.pending,
                ) : null,
                priority: _selectedPriority != null ? TaskPriority.values.firstWhere(
                  (p) => p.name == _selectedPriority,
                  orElse: () => TaskPriority.medium,
                ) : null,
                searchQuery: _searchQuery,
              ).notifier).refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          TaskFiltersWidget(
            selectedStatus: _selectedStatus,
            selectedPriority: _selectedPriority,
            assignedUserId: _assignedUserId,
            searchQuery: _searchQuery,
            onFiltersChanged: (status, priority, userId, search) {
              setState(() {
                _selectedStatus = status;
                _selectedPriority = priority;
                _assignedUserId = userId;
                _searchQuery = search;
              });
            },
          ),
          
          // Lista de tareas
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.task_alt,
                    title: 'No hay tareas',
                    message: 'No se encontraron tareas con los filtros aplicados',
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(tasksNotifierProvider(
                      projectId: widget.projectId,
                      anteprojectId: widget.anteprojectId,
                      assignedUserId: _assignedUserId,
                      status: _selectedStatus != null ? TaskStatus.values.firstWhere(
                        (s) => s.name == _selectedStatus,
                        orElse: () => TaskStatus.pending,
                      ) : null,
                      priority: _selectedPriority != null ? TaskPriority.values.firstWhere(
                        (p) => p.name == _selectedPriority,
                        orElse: () => TaskPriority.medium,
                      ) : null,
                      searchQuery: _searchQuery,
                    ).notifier).refresh();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TaskCardWidget(
                          task: task,
                          onTap: () {
                            // TODO: Navegar a detalle de tarea
                          },
                          onStatusChanged: (newStatus) {
                            ref.read(tasksNotifierProvider(
                              projectId: widget.projectId,
                              anteprojectId: widget.anteprojectId,
                              assignedUserId: _assignedUserId,
                              status: _selectedStatus != null ? TaskStatus.values.firstWhere(
                                (s) => s.name == _selectedStatus,
                                orElse: () => TaskStatus.pending,
                              ) : null,
                              priority: _selectedPriority != null ? TaskPriority.values.firstWhere(
                                (p) => p.name == _selectedPriority,
                                orElse: () => TaskPriority.medium,
                              ) : null,
                              searchQuery: _searchQuery,
                            ).notifier).updateTaskStatus(task.id, newStatus);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stack) => ErrorDisplayWidget(
                message: 'Error al cargar tareas: $error',
                onRetry: () {
                  ref.read(tasksNotifierProvider(
                    projectId: widget.projectId,
                    anteprojectId: widget.anteprojectId,
                    assignedUserId: _assignedUserId,
                    status: _selectedStatus != null ? TaskStatus.values.firstWhere(
                      (s) => s.name == _selectedStatus,
                      orElse: () => TaskStatus.pending,
                    ) : null,
                    priority: _selectedPriority != null ? TaskPriority.values.firstWhere(
                      (p) => p.name == _selectedPriority,
                      orElse: () => TaskPriority.medium,
                    ) : null,
                    searchQuery: _searchQuery,
                  ).notifier).refresh();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navegar a página de crear tarea
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 