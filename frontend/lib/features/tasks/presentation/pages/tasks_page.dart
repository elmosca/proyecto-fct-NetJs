import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/presentation/pages/task_details_page.dart';
import 'package:fct_frontend/features/tasks/presentation/providers/task_providers.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/create_task_dialog.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/edit_task_dialog.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_card.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_filters_dialog.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_kanban_column.dart';
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
      ref.read(tasksNotifierProvider.notifier).refreshTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tasks),
        actions: [
          // Botón de cambio de vista
          IconButton(
            icon: Icon(_isKanbanView ? Icons.view_list : Icons.view_column),
            onPressed: () {
              setState(() {
                _isKanbanView = !_isKanbanView;
              });
            },
            tooltip: _isKanbanView
                ? AppLocalizations.of(context).listView
                : AppLocalizations.of(context).kanbanView,
          ),
          // Botón de filtros
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(context),
            tooltip: AppLocalizations.of(context).filters,
          ),
          // Botón de crear tarea
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateTaskDialog(context),
            tooltip: AppLocalizations.of(context).createTask,
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
                    ref.read(tasksNotifierProvider.notifier).refreshTasks(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksView(List<TaskEntity> tasks) {
    if (tasks.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.task,
        title: AppLocalizations.of(context).noTasks,
        message: AppLocalizations.of(context).noTasksMessage,
        onAction: () => _showCreateTaskDialog(context),
      );
    }

    if (_isKanbanView) {
      return _buildKanbanView(tasks);
    } else {
      return _buildListView(tasks);
    }
  }

  Widget _buildKanbanView(List<TaskEntity> tasks) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: TaskStatus.values.map((status) {
          final statusTasks =
              tasks.where((task) => task.status == status).toList();
          return TaskKanbanColumn(
            status: status,
            tasks: statusTasks,
            onTaskTap: (task) => _showTaskDetails(context, task),
            onTaskMove: (task, newStatus) => _moveTask(task, newStatus),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListView(List<TaskEntity> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TaskCard(
            task: task,
            onTap: () => _showTaskDetails(context, task),
            onEdit: () => _showEditTaskDialog(context, task),
            onDelete: () => _showDeleteTaskDialog(context, task),
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

  void _showTaskDetails(BuildContext context, TaskEntity task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(task: task),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );
  }

  void _showDeleteTaskDialog(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteTask),
        content: Text(AppLocalizations.of(context).deleteTaskConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTask(task);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
  }

  void _moveTask(TaskEntity task, TaskStatus newStatus) {
    ref
        .read(tasksNotifierProvider.notifier)
        .updateTaskStatus(task.id, newStatus);
  }

  void _deleteTask(TaskEntity task) {
    ref.read(tasksNotifierProvider.notifier).deleteTask(task.id);
  }
}
