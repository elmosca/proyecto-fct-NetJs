import 'package:fct_frontend/features/tasks/domain/entities/task_entity.dart';
import 'package:fct_frontend/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskKanbanColumn extends StatelessWidget {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final Function(TaskEntity) onTaskTap;
  final Function(TaskEntity, TaskStatus) onTaskMove;

  const TaskKanbanColumn({
    super.key,
    required this.status,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskMove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildColumnHeader(context),
          const SizedBox(height: 8),
          Expanded(
            child: _buildColumnContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            status.icon,
            color: status.color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              status.displayName,
              style: TextStyle(
                color: status.color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${tasks.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child:
          tasks.isEmpty ? _buildEmptyState(context) : _buildTasksList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            status.icon,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Sin tareas',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Draggable<TaskEntity>(
            data: task,
            feedback: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 280,
                child: TaskCard(
                  task: task,
                  onTap: () => onTaskTap(task),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: TaskCard(
                task: task,
                onTap: () => onTaskTap(task),
              ),
            ),
            child: TaskCard(
              task: task,
              onTap: () => onTaskTap(task),
            ),
          ),
        );
      },
    );
  }
}

class TaskKanbanBoard extends StatelessWidget {
  final List<TaskEntity> tasks;
  final Function(TaskEntity) onTaskTap;
  final Function(TaskEntity, TaskStatus) onTaskMove;

  const TaskKanbanBoard({
    super.key,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskMove,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<TaskEntity>(
      onWillAcceptWithDetails: (data) => data != null,
      onAcceptWithDetails: (task) {
        // El estado se maneja en el provider
      },
      builder: (context, candidateData, rejectedData) {
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
                onTaskTap: onTaskTap,
                onTaskMove: onTaskMove,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
