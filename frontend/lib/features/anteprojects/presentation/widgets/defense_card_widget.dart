import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';

class DefenseCardWidget extends StatelessWidget {
  final Defense defense;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const DefenseCardWidget({
    super.key,
    required this.defense,
    this.onTap,
    this.onStart,
    this.onComplete,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con estado
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Defensa #${defense.id.substring(0, 8)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Información de la defensa
              _buildInfoRow('Anteproyecto:', defense.anteprojectId),
              _buildInfoRow('Estudiante:', defense.studentId),
              _buildInfoRow('Tutor:', defense.tutorId),
              _buildInfoRow('Fecha:', DateFormat('dd/MM/yyyy HH:mm').format(defense.scheduledDate)),
              
              if (defense.location != null)
                _buildInfoRow('Ubicación:', defense.location!),
              
              if (defense.score != null)
                _buildInfoRow('Puntuación:', '${defense.score}/10'),
              
              // Acciones
              if (_shouldShowActions())
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (defense.status.canStart && onStart != null)
                        ElevatedButton.icon(
                          onPressed: onStart,
                          icon: const Icon(Icons.play_arrow, size: 16),
                          label: const Text('Iniciar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      
                      if (defense.status.canComplete && onComplete != null) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: onComplete,
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Completar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                      
                      if (defense.status.canCancel && onCancel != null) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: onCancel,
                          icon: const Icon(Icons.cancel, size: 16),
                          label: const Text('Cancelar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    IconData chipIcon;
    
    switch (defense.status) {
      case DefenseStatus.scheduled:
        chipColor = Colors.orange;
        chipIcon = Icons.schedule;
        break;
      case DefenseStatus.inProgress:
        chipColor = Colors.blue;
        chipIcon = Icons.play_arrow;
        break;
      case DefenseStatus.completed:
        chipColor = Colors.green;
        chipIcon = Icons.check_circle;
        break;
      case DefenseStatus.cancelled:
        chipColor = Colors.red;
        chipIcon = Icons.cancel;
        break;
    }

    return Chip(
      avatar: Icon(chipIcon, color: Colors.white, size: 16),
      label: Text(
        defense.status.displayName,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowActions() {
    return defense.status.canStart || 
           defense.status.canComplete || 
           defense.status.canCancel;
  }
} 