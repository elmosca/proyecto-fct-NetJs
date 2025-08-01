import 'package:fct_frontend/core/services/http_service.dart';
import 'package:fct_frontend/core/utils/logger.dart';

enum AuditActionType {
  create,
  update,
  delete,
  login,
  logout,
  passwordChange,
  roleChange,
  statusChange,
  export,
  bulkAction,
}

enum AuditSeverity {
  low,
  medium,
  high,
  critical,
}

class AuditLogEntity {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final AuditActionType actionType;
  final String resourceType;
  final String resourceId;
  final String description;
  final AuditSeverity severity;
  final DateTime timestamp;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final Map<String, dynamic>? metadata;
  final String? sessionId;

  AuditLogEntity({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.actionType,
    required this.resourceType,
    required this.resourceId,
    required this.description,
    required this.severity,
    required this.timestamp,
    this.ipAddress,
    this.userAgent,
    this.oldValues,
    this.newValues,
    this.metadata,
    this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'actionType': actionType.name,
      'resourceType': resourceType,
      'resourceId': resourceId,
      'description': description,
      'severity': severity.name,
      'timestamp': timestamp.toIso8601String(),
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'oldValues': oldValues,
      'newValues': newValues,
      'metadata': metadata,
      'sessionId': sessionId,
    };
  }

  factory AuditLogEntity.fromJson(Map<String, dynamic> json) {
    return AuditLogEntity(
      id: json['id'],
      userId: json['userId'],
      userEmail: json['userEmail'],
      userName: json['userName'],
      actionType: AuditActionType.values.firstWhere(
        (e) => e.name == json['actionType'],
        orElse: () => AuditActionType.update,
      ),
      resourceType: json['resourceType'],
      resourceId: json['resourceId'],
      description: json['description'],
      severity: AuditSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => AuditSeverity.medium,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
      oldValues: json['oldValues'],
      newValues: json['newValues'],
      metadata: json['metadata'],
      sessionId: json['sessionId'],
    );
  }
}

class AuditService {
  static final AuditService _instance = AuditService._internal();
  factory AuditService() => _instance;
  AuditService._internal();

  final HttpService _httpService = HttpService();

  /// Registra una acción de auditoría
  Future<void> logAction({
    required AuditActionType actionType,
    required String resourceType,
    required String resourceId,
    required String description,
    required AuditSeverity severity,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final auditLog = AuditLogEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current-user-id', // TODO: Obtener del AuthService
        userEmail: 'current-user@email.com', // TODO: Obtener del AuthService
        userName: 'Current User', // TODO: Obtener del AuthService
        actionType: actionType,
        resourceType: resourceType,
        resourceId: resourceId,
        description: description,
        severity: severity,
        timestamp: DateTime.now(),
        ipAddress: '127.0.0.1', // TODO: Obtener IP real
        userAgent: 'Flutter App', // TODO: Obtener User-Agent real
        oldValues: oldValues,
        newValues: newValues,
        metadata: metadata,
        sessionId: 'session-id', // TODO: Obtener Session ID
      );

      // Enviar al backend
      await _httpService.post('/audit-logs', data: auditLog.toJson());

      // Log local para debugging
      Logger.info('Audit log created: $description');
    } catch (e) {
      Logger.error('Error creating audit log: $e');
      // No lanzar excepción para no interrumpir el flujo principal
    }
  }

  /// Registra creación de usuario
  Future<void> logUserCreated({
    required String userId,
    required String userEmail,
    Map<String, dynamic>? userData,
  }) async {
    await logAction(
      actionType: AuditActionType.create,
      resourceType: 'user',
      resourceId: userId,
      description: 'Usuario creado: $userEmail',
      severity: AuditSeverity.medium,
      newValues: userData,
      metadata: {'action': 'user_created'},
    );
  }

  /// Registra actualización de usuario
  Future<void> logUserUpdated({
    required String userId,
    required String userEmail,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
  }) async {
    await logAction(
      actionType: AuditActionType.update,
      resourceType: 'user',
      resourceId: userId,
      description: 'Usuario actualizado: $userEmail',
      severity: AuditSeverity.medium,
      oldValues: oldValues,
      newValues: newValues,
      metadata: {'action': 'user_updated'},
    );
  }

  /// Registra eliminación de usuario
  Future<void> logUserDeleted({
    required String userId,
    required String userEmail,
    Map<String, dynamic>? userData,
  }) async {
    await logAction(
      actionType: AuditActionType.delete,
      resourceType: 'user',
      resourceId: userId,
      description: 'Usuario eliminado: $userEmail',
      severity: AuditSeverity.high,
      oldValues: userData,
      metadata: {'action': 'user_deleted'},
    );
  }

  /// Registra cambio de contraseña
  Future<void> logPasswordChanged({
    required String userId,
    required String userEmail,
  }) async {
    await logAction(
      actionType: AuditActionType.passwordChange,
      resourceType: 'user',
      resourceId: userId,
      description: 'Contraseña cambiada: $userEmail',
      severity: AuditSeverity.high,
      metadata: {'action': 'password_changed'},
    );
  }

  /// Registra cambio de rol
  Future<void> logRoleChanged({
    required String userId,
    required String userEmail,
    required String oldRole,
    required String newRole,
  }) async {
    await logAction(
      actionType: AuditActionType.roleChange,
      resourceType: 'user',
      resourceId: userId,
      description: 'Rol cambiado: $userEmail ($oldRole -> $newRole)',
      severity: AuditSeverity.critical,
      oldValues: {'role': oldRole},
      newValues: {'role': newRole},
      metadata: {'action': 'role_changed'},
    );
  }

  /// Registra cambio de estado
  Future<void> logStatusChanged({
    required String userId,
    required String userEmail,
    required bool oldStatus,
    required bool newStatus,
  }) async {
    await logAction(
      actionType: AuditActionType.statusChange,
      resourceType: 'user',
      resourceId: userId,
      description:
          'Estado cambiado: $userEmail (${oldStatus ? 'Activo' : 'Inactivo'} -> ${newStatus ? 'Activo' : 'Inactivo'})',
      severity: AuditSeverity.medium,
      oldValues: {'isActive': oldStatus},
      newValues: {'isActive': newStatus},
      metadata: {'action': 'status_changed'},
    );
  }

  /// Registra exportación de datos
  Future<void> logDataExported({
    required String format,
    required int recordCount,
    required String scope,
    List<String>? selectedFields,
  }) async {
    await logAction(
      actionType: AuditActionType.export,
      resourceType: 'users',
      resourceId: 'export-${DateTime.now().millisecondsSinceEpoch}',
      description:
          'Datos exportados: $recordCount usuarios en formato $format ($scope)',
      severity: AuditSeverity.low,
      metadata: {
        'action': 'data_exported',
        'format': format,
        'recordCount': recordCount,
        'scope': scope,
        'selectedFields': selectedFields,
      },
    );
  }

  /// Registra acción masiva
  Future<void> logBulkAction({
    required String action,
    required int recordCount,
    required List<String> recordIds,
    Map<String, dynamic>? actionData,
  }) async {
    await logAction(
      actionType: AuditActionType.bulkAction,
      resourceType: 'users',
      resourceId: 'bulk-${DateTime.now().millisecondsSinceEpoch}',
      description: 'Acción masiva: $action en $recordCount usuarios',
      severity: AuditSeverity.high,
      metadata: {
        'action': 'bulk_action',
        'bulkAction': action,
        'recordCount': recordCount,
        'recordIds': recordIds,
        'actionData': actionData,
      },
    );
  }

  /// Registra login de usuario
  Future<void> logUserLogin({
    required String userId,
    required String userEmail,
    String? ipAddress,
    String? userAgent,
  }) async {
    await logAction(
      actionType: AuditActionType.login,
      resourceType: 'auth',
      resourceId: userId,
      description: 'Usuario conectado: $userEmail',
      severity: AuditSeverity.low,
      metadata: {
        'action': 'user_login',
        'ipAddress': ipAddress,
        'userAgent': userAgent,
      },
    );
  }

  /// Registra logout de usuario
  Future<void> logUserLogout({
    required String userId,
    required String userEmail,
  }) async {
    await logAction(
      actionType: AuditActionType.logout,
      resourceType: 'auth',
      resourceId: userId,
      description: 'Usuario desconectado: $userEmail',
      severity: AuditSeverity.low,
      metadata: {'action': 'user_logout'},
    );
  }

  /// Obtiene logs de auditoría
  Future<List<AuditLogEntity>> getAuditLogs({
    String? userId,
    AuditActionType? actionType,
    String? resourceType,
    String? resourceId,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['userId'] = userId;
      if (actionType != null) queryParams['actionType'] = actionType.name;
      if (resourceType != null) queryParams['resourceType'] = resourceType;
      if (resourceId != null) queryParams['resourceId'] = resourceId;
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response =
          await _httpService.get('/audit-logs', queryParameters: queryParams);

      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => AuditLogEntity.fromJson(json)).toList();
    } catch (e) {
      Logger.error('Error fetching audit logs: $e');
      return [];
    }
  }

  /// Obtiene estadísticas de auditoría
  Future<Map<String, dynamic>> getAuditStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null)
        queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();

      final response = await _httpService.get('/audit-logs/stats',
          queryParameters: queryParams);
      return response.data;
    } catch (e) {
      Logger.error('Error fetching audit stats: $e');
      return {};
    }
  }
}
