import 'package:fct_frontend/features/tasks/domain/entities/task.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_notification_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task_notification_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/task_notification_repository.dart';

/// Servicio para manejar notificaciones específicas de tareas
class TaskNotificationService {
  final TaskNotificationRepository _repository;

  TaskNotificationService(this._repository);

  /// Notificar cuando se asigna una tarea a un usuario
  Future<void> notifyTaskAssigned(
      Task task, String assignedUserId) async {
    final dto = CreateTaskNotificationDto(
      title: 'Nueva tarea asignada',
      message: 'Se te ha asignado la tarea: ${task.title}',
      type: TaskNotificationType.taskAssigned,
      userId: assignedUserId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'taskPriority': task.priority.name,
        'assignedBy': task.createdById,
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando cambia el estado de una tarea
  Future<void> notifyTaskStatusChanged(
    Task task,
    String userId,
    String previousStatus,
  ) async {
    final dto = CreateTaskNotificationDto(
      title: 'Estado de tarea actualizado',
      message:
          'La tarea "${task.title}" cambió de $previousStatus a ${task.status.name}',
      type: TaskNotificationType.taskStatusChanged,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'previousStatus': previousStatus,
        'newStatus': task.status.name,
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando se acerca la fecha de vencimiento
  Future<void> notifyTaskDueDateReminder(
    Task task,
    String userId,
    int daysUntilDue,
  ) async {
    final dto = CreateTaskNotificationDto(
      title: 'Recordatorio de fecha de vencimiento',
      message: 'La tarea "${task.title}" vence en $daysUntilDue días',
      type: TaskNotificationType.taskDueDateReminder,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'daysUntilDue': daysUntilDue,
        'dueDate': task.dueDate?.toIso8601String(),
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando una tarea está vencida
  Future<void> notifyTaskOverdue(Task task, String userId) async {
    final dto = CreateTaskNotificationDto(
      title: 'Tarea vencida',
      message: 'La tarea "${task.title}" está vencida',
      type: TaskNotificationType.taskOverdue,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'dueDate': task.dueDate?.toIso8601String(),
        'daysOverdue': DateTime.now().difference(task.dueDate!).inDays,
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando se completa una tarea
  Future<void> notifyTaskCompleted(Task task, String userId) async {
    final dto = CreateTaskNotificationDto(
      title: 'Tarea completada',
      message: 'La tarea "${task.title}" ha sido completada',
      type: TaskNotificationType.taskCompleted,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'completedAt': DateTime.now().toIso8601String(),
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando se completa una dependencia
  Future<void> notifyDependencyCompleted(
    Task task,
    Task dependencyTask,
    String userId,
  ) async {
    final dto = CreateTaskNotificationDto(
      title: 'Dependencia completada',
      message:
          'La dependencia "${dependencyTask.title}" de la tarea "${task.title}" ha sido completada',
      type: TaskNotificationType.taskDependencyCompleted,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'dependencyTaskTitle': dependencyTask.title,
        'dependencyTaskId': dependencyTask.id,
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando se agrega un comentario
  Future<void> notifyTaskCommentAdded(
    Task task,
    String userId,
    String commentAuthor,
  ) async {
    final dto = CreateTaskNotificationDto(
      title: 'Nuevo comentario',
      message: '$commentAuthor agregó un comentario a la tarea "${task.title}"',
      type: TaskNotificationType.taskCommentAdded,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'commentAuthor': commentAuthor,
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando cambia la prioridad
  Future<void> notifyTaskPriorityChanged(
    Task task,
    String userId,
    String previousPriority,
  ) async {
    final dto = CreateTaskNotificationDto(
      title: 'Prioridad actualizada',
      message:
          'La prioridad de la tarea "${task.title}" cambió de $previousPriority a ${task.priority.name}',
      type: TaskNotificationType.taskPriorityChanged,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      metadata: {
        'taskTitle': task.title,
        'previousPriority': previousPriority,
        'newPriority': task.priority.name,
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Notificar cuando se alcanza un hito
  Future<void> notifyMilestoneReached(
    Task task,
    String userId,
    String milestoneName,
  ) async {
    final dto = CreateTaskNotificationDto(
      title: 'Hito alcanzado',
      message:
          'Se ha alcanzado el hito "$milestoneName" con la tarea "${task.title}"',
      type: TaskNotificationType.taskMilestoneReached,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      milestoneId: task.milestoneId,
      metadata: {
        'taskTitle': task.title,
        'milestoneName': milestoneName,
        'milestoneId': task.milestoneId,
      },
    );

    await _repository.createTaskNotification(dto);
  }

  /// Programar notificación de recordatorio
  Future<void> scheduleDueDateReminder(
    Task task,
    String userId,
    DateTime reminderDate,
  ) async {
    final dto = CreateTaskNotificationDto(
      title: 'Recordatorio programado',
      message: 'Recordatorio para la tarea "${task.title}"',
      type: TaskNotificationType.taskDueDateReminder,
      userId: userId,
      taskId: task.id,
      projectId: task.projectId,
      scheduledAt: reminderDate,
      metadata: {
        'taskTitle': task.title,
        'dueDate': task.dueDate?.toIso8601String(),
      },
    );

    await _repository.scheduleTaskNotification(dto, reminderDate);
  }

  /// Obtener notificaciones no leídas de un usuario
  Future<List<TaskNotification>> getUnreadNotifications(String userId) async {
    return await _repository.getUnreadNotifications(userId);
  }

  /// Obtener contador de notificaciones no leídas
  Future<int> getUnreadCount(String userId) async {
    return await _repository.getUnreadCount(userId);
  }

  /// Marcar notificación como leída
  Future<TaskNotification> markAsRead(String notificationId) async {
    final dto = MarkNotificationAsReadDto(
      notificationId: notificationId,
      readAt: DateTime.now(),
    );

    return await _repository.markAsRead(dto);
  }

  /// Marcar múltiples notificaciones como leídas
  Future<List<TaskNotification>> bulkMarkAsRead(
      List<String> notificationIds) async {
    final dto = BulkMarkNotificationsAsReadDto(
      notificationIds: notificationIds,
      readAt: DateTime.now(),
    );

    return await _repository.bulkMarkAsRead(dto);
  }
}
