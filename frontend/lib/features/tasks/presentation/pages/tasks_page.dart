import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/task_providers.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/create_task_dialog.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_filters_dialog.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  bool _isKanbanView = true;

  @override
  void initState() {
    super.initState();
    // Cargar tareas al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tasksNotifierProvider().notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(tasksNotifierProvider());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasks),
        actions: [
          // Botón de cambio de vista
          IconButton(
            icon: Icon(_isKanbanView ? Icons.view_list : Icons.view_column),
            onPressed: () {
              setState(() {
                _isKanbanView = !_isKanbanView;
              });
            },
            tooltip: _isKanbanView ? l10n.listView : l10n.kanbanView,
          ),
          // Botón de filtros
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(context),
            tooltip: l10n.filters,
          ),
          // Botón de crear tarea
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateTaskDialog(context),
            tooltip: l10n.createTask,
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) => _buildTasksView(tasks),
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: ${error.toString()}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(tasksNotifierProvider().notifier).refresh(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksView(List<Task> tasks) {
    final l10n = AppLocalizations.of(context)!;
    if (tasks.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.task,
        title: l10n.noTasks,
        message: l10n.noTasksMessage,
        onAction: () => _showCreateTaskDialog(context),
      );
    }

    if (_isKanbanView) {
      return _buildKanbanView(tasks);
    } else {
      return _buildListView(tasks);
    }
  }

  Widget _buildKanbanView(List<Task> tasks) {
    // TODO: [REVIEW_NEEDED] - Resolver conflicto de tipos Task vs Task
    // Por ahora, mostramos un widget temporal
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.view_column, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Vista Kanban - En desarrollo',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Funcionalidad temporal mientras se resuelven conflictos de tipos',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Task> tasks) {
    // TODO: [REVIEW_NEEDED] - Resolver conflicto de tipos Task vs Task
    // Por ahora, mostramos una lista temporal
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTask(task),
            ),
          ),
        );
      },
    );
  }

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TaskFiltersDialog(),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateTaskDialog(
        projectId: 'default-project', // TODO: Obtener projectId real
        milestoneId: null,
      ),
    );
  }

  // TODO: [REVIEW_NEEDED] - Implementar cuando se resuelva conflicto de tipos
  // void _showTaskDetails(BuildContext context, Task task) {
  //   // TODO: [REVIEW_NEEDED] - Resolver conflicto de tipos Task vs Task
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Ver detalles de tarea: ${task.title}'),
  //     ),
  //   );
  // }

  // TODO: [REVIEW_NEEDED] - Implementar cuando se resuelva conflicto de tipos
  // void _showEditTaskDialog(BuildContext context, Task task) {
  //   // TODO: [REVIEW_NEEDED] - Resolver conflicto de tipos Task vs Task
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Editar tarea: ${task.title}'),
  //     ),
  //   );
  // }

  // TODO: [REVIEW_NEEDED] - Implementar cuando se resuelva conflicto de tipos
  // void _showDeleteTaskDialog(BuildContext context, Task task) {
  //   final l10n = AppLocalizations.of(context)!;
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(l10n.deleteTask),
  //       content: Text(l10n.deleteTaskConfirmation),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text(l10n.cancel),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             _deleteTask(task);
  //           },
  //           style: TextButton.styleFrom(foregroundColor: Colors.red),
  //           child: Text(l10n.delete),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // TODO: [REVIEW_NEEDED] - Resolver conflicto de tipos Task vs Task
  // void _moveTask(Task task, TaskStatus newStatus) {
  //   ref
  //       .read(tasksNotifierProvider().notifier)
  //       .updateTaskStatus(task.id, newStatus);
  // }

  void _deleteTask(Task task) {
    // TODO: [REVIEW_NEEDED] - Implementar método deleteTask en TasksNotifier
    // Por ahora, solo mostramos un mensaje temporal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Eliminar tarea: ${task.id} - Funcionalidad en desarrollo'),
      ),
    );
  }
}
