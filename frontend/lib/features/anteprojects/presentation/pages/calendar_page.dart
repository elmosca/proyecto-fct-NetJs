import 'package:fct_frontend/features/anteprojects/domain/entities/calendar_event.dart'
    as app_calendar;
import 'package:fct_frontend/features/anteprojects/presentation/providers/notification_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filters = ref.read(calendarFiltersNotifierProvider);
      ref
          .read(calendarEventsNotifierProvider.notifier)
          .loadCalendarEvents(filters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(calendarEventsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateEventDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Vista simplificada del calendario
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Fecha seleccionada: ${_formatDate(_selectedDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Lista de eventos
          Expanded(
            child: eventsState.when(
              data: (events) {
                final dayEvents = events.where((event) {
                  final eventDate = DateTime(
                    event.startDate.year,
                    event.startDate.month,
                    event.startDate.day,
                  );
                  final selectedDate = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                  );
                  return eventDate.isAtSameMomentAs(selectedDate);
                }).toList();

                if (dayEvents.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No hay eventos para este día',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: dayEvents.length,
                  itemBuilder: (context, index) {
                    final event = dayEvents[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Text(event.type.icon,
                            style: const TextStyle(fontSize: 24)),
                        title: Text(event.title),
                        subtitle: Text(event.description),
                        trailing: Text(
                            '${event.startDate.hour}:${event.startDate.minute.toString().padLeft(2, '0')}'),
                        onTap: () => _onEventTap(event),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _onEventTap(app_calendar.CalendarEvent event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evento: ${event.title}')),
    );
  }

  void _showCreateEventDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad en desarrollo')),
    );
  }
}
