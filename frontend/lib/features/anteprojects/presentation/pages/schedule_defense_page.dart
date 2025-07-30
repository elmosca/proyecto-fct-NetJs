import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/defense_providers.dart';

@RoutePage()
class ScheduleDefensePage extends ConsumerStatefulWidget {
  final String? anteprojectId;
  final String? studentId;
  final String? tutorId;

  const ScheduleDefensePage({
    super.key,
    this.anteprojectId,
    this.studentId,
    this.tutorId,
  });

  @override
  ConsumerState<ScheduleDefensePage> createState() => _ScheduleDefensePageState();
}

class _ScheduleDefensePageState extends ConsumerState<ScheduleDefensePage> {
  final _formKey = GlobalKey<FormState>();
  final _anteprojectController = TextEditingController();
  final _studentController = TextEditingController();
  final _tutorController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.anteprojectId != null) {
      _anteprojectController.text = widget.anteprojectId!;
    }
    if (widget.studentId != null) {
      _studentController.text = widget.studentId!;
    }
    if (widget.tutorId != null) {
      _tutorController.text = widget.tutorId!;
    }
  }

  @override
  void dispose() {
    _anteprojectController.dispose();
    _studentController.dispose();
    _tutorController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programar Defensa'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _anteprojectController,
                decoration: const InputDecoration(
                  labelText: 'ID del Anteproyecto *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El ID del anteproyecto es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _studentController,
                decoration: const InputDecoration(
                  labelText: 'ID del Estudiante *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El ID del estudiante es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tutorController,
                decoration: const InputDecoration(
                  labelText: 'ID del Tutor *',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El ID del tutor es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _scheduleDefense,
                child: _isLoading 
                    ? const CircularProgressIndicator()
                    : const Text('Programar Defensa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scheduleDefense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final scheduledDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await ref.read(defensesNotifierProvider.notifier).scheduleDefense(
        anteprojectId: _anteprojectController.text.trim(),
        studentId: _studentController.text.trim(),
        tutorId: _tutorController.text.trim(),
        scheduledDate: scheduledDate,
        location: _locationController.text.trim().isEmpty 
            ? null 
            : _locationController.text.trim(),
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Defensa programada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.router.pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al programar la defensa: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 