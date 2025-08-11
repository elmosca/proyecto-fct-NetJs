import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required CalendarEventType type,
    required String userId,
    String? anteprojectId,
    String? defenseId,
    String? location,
    String? notes,
    @Default(false) bool isAllDay,
    String? color,
    @Default(false) bool isRecurring,
    String? recurrenceRule,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}

enum CalendarEventType {
  @JsonValue('defense')
  defense,
  @JsonValue('meeting')
  meeting,
  @JsonValue('deadline')
  deadline,
  @JsonValue('reminder')
  reminder,
  @JsonValue('other')
  other,
}

extension CalendarEventTypeExtension on CalendarEventType {
  String get displayName {
    switch (this) {
      case CalendarEventType.defense:
        return 'Defensa';
      case CalendarEventType.meeting:
        return 'Reunión';
      case CalendarEventType.deadline:
        return 'Fecha Límite';
      case CalendarEventType.reminder:
        return 'Recordatorio';
      case CalendarEventType.other:
        return 'Otro';
    }
  }

  String get icon {
    switch (this) {
      case CalendarEventType.defense:
        return '🎓';
      case CalendarEventType.meeting:
        return '👥';
      case CalendarEventType.deadline:
        return '⏰';
      case CalendarEventType.reminder:
        return '🔔';
      case CalendarEventType.other:
        return '📅';
    }
  }

  String get defaultColor {
    switch (this) {
      case CalendarEventType.defense:
        return '#FF6B6B';
      case CalendarEventType.meeting:
        return '#4ECDC4';
      case CalendarEventType.deadline:
        return '#FFE66D';
      case CalendarEventType.reminder:
        return '#95E1D3';
      case CalendarEventType.other:
        return '#A8E6CF';
    }
  }
}
