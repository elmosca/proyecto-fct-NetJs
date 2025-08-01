import 'package:fct_frontend/core/services/audit_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditLogsState {
  final List<AuditLogEntity> logs;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final Map<String, dynamic> filters;
  final Map<String, dynamic> stats;

  const AuditLogsState({
    this.logs = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.filters = const {},
    this.stats = const {},
  });

  AuditLogsState copyWith({
    List<AuditLogEntity>? logs,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? stats,
  }) {
    return AuditLogsState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      filters: filters ?? this.filters,
      stats: stats ?? this.stats,
    );
  }

  bool get canLoadMore => hasMore && !isLoading && !isLoadingMore;
}

class AuditLogsNotifier extends StateNotifier<AuditLogsState> {
  AuditLogsNotifier() : super(const AuditLogsState());

  final AuditService _auditService = AuditService();

  /// Carga logs de auditoría
  Future<void> loadAuditLogs({
    bool refresh = false,
    Map<String, dynamic>? filters,
  }) async {
    if (state.isLoading && !refresh) return;

    state = state.copyWith(
      isLoading: !refresh,
      isLoadingMore: refresh,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
    );

    try {
      final newFilters = filters ?? state.filters;
      final logs = await _auditService.getAuditLogs(
        userId: newFilters['userId'],
        actionType: newFilters['actionType'] != null
            ? AuditActionType.values.firstWhere(
                (e) => e.name == newFilters['actionType'],
                orElse: () => AuditActionType.update,
              )
            : null,
        resourceType: newFilters['resourceType'],
        resourceId: newFilters['resourceId'],
        startDate: newFilters['startDate'],
        endDate: newFilters['endDate'],
        page: refresh ? 1 : state.currentPage,
        limit: 20,
      );

      state = state.copyWith(
        logs: refresh ? logs : [...state.logs, ...logs],
        isLoading: false,
        isLoadingMore: false,
        hasMore: logs.length == 20,
        currentPage: refresh ? 2 : state.currentPage + 1,
        filters: newFilters,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Carga más logs
  Future<void> loadMoreLogs() async {
    if (!state.canLoadMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final logs = await _auditService.getAuditLogs(
        userId: state.filters['userId'],
        actionType: state.filters['actionType'] != null
            ? AuditActionType.values.firstWhere(
                (e) => e.name == state.filters['actionType'],
                orElse: () => AuditActionType.update,
              )
            : null,
        resourceType: state.filters['resourceType'],
        resourceId: state.filters['resourceId'],
        startDate: state.filters['startDate'],
        endDate: state.filters['endDate'],
        page: state.currentPage,
        limit: 20,
      );

      state = state.copyWith(
        logs: [...state.logs, ...logs],
        isLoadingMore: false,
        hasMore: logs.length == 20,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Actualiza filtros
  Future<void> updateFilters(Map<String, dynamic> filters) async {
    state = state.copyWith(
      filters: filters,
      currentPage: 1,
      hasMore: true,
    );
    await loadAuditLogs(refresh: true);
  }

  /// Limpia filtros
  Future<void> clearFilters() async {
    state = state.copyWith(
      filters: {},
      currentPage: 1,
      hasMore: true,
    );
    await loadAuditLogs(refresh: true);
  }

  /// Carga estadísticas
  Future<void> loadStats({DateTime? startDate, DateTime? endDate}) async {
    try {
      final stats = await _auditService.getAuditStats(
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(stats: stats);
    } catch (e) {
      // No actualizar estado en caso de error para no perder datos existentes
    }
  }

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
    await _auditService.logAction(
      actionType: actionType,
      resourceType: resourceType,
      resourceId: resourceId,
      description: description,
      severity: severity,
      oldValues: oldValues,
      newValues: newValues,
      metadata: metadata,
    );
  }
}

final auditLogsProvider =
    StateNotifierProvider<AuditLogsNotifier, AuditLogsState>((ref) {
  return AuditLogsNotifier();
});

final auditServiceProvider = Provider<AuditService>((ref) {
  return AuditService();
});
