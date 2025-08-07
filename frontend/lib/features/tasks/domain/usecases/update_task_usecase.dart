import 'package:fct_frontend/features/tasks/domain/entities/task_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository _taskRepository;

  UpdateTaskUseCase(this._taskRepository);

  Future<Task> execute(String taskId, UpdateTaskDto updateTaskDto) async {
    // Primero obtener la tarea existente
    final existingTask = await _taskRepository.getTaskById(taskId);
    if (existingTask == null) {
      throw Exception('Tarea no encontrada');
    }
    
    // Crear una nueva tarea con los datos actualizados
    final updatedTask = Task(
      id: taskId,
      projectId: existingTask.projectId,
      milestoneId: existingTask.milestoneId,
      createdById: existingTask.createdById,
      title: updateTaskDto.title ?? existingTask.title,
      description: updateTaskDto.description ?? existingTask.description,
      status: updateTaskDto.status ?? existingTask.status,
      priority: updateTaskDto.priority ?? existingTask.priority,
      complexity: updateTaskDto.complexity ?? existingTask.complexity,
      dueDate: updateTaskDto.dueDate ?? existingTask.dueDate,
      completedAt: updateTaskDto.completedAt ?? existingTask.completedAt,
      kanbanPosition: updateTaskDto.kanbanPosition ?? existingTask.kanbanPosition,
      estimatedHours: updateTaskDto.estimatedHours ?? existingTask.estimatedHours,
      actualHours: updateTaskDto.actualHours ?? existingTask.actualHours,
      tags: updateTaskDto.tags ?? existingTask.tags,
      assignees: updateTaskDto.assignees ?? existingTask.assignees,
      dependencies: updateTaskDto.dependencies ?? existingTask.dependencies,
      dependents: existingTask.dependents,
      createdAt: existingTask.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: existingTask.deletedAt,
    );
    
    return _taskRepository.updateTask(updatedTask);
  }
}
