import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/defense_providers.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';

@RoutePage()
class DefenseDetailPage extends ConsumerWidget {
  final String defenseId;

  const DefenseDetailPage({
    super.key,
    @PathParam('id') required this.defenseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defenseAsync = ref.watch(defenseDetailNotifierProvider(defenseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Defensa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(defenseDetailNotifierProvider(defenseId).notifier).refresh();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: defenseAsync.when(
        data: (defense) {
          if (defense == null) {
            return const Center(
              child: Text('Defensa no encontrada'),
            );
          }
          return _DefenseDetailContent(defense: defense);
        },
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => CustomErrorWidget(
          error: error.toString(),
          onRetry: () {
            ref.read(defenseDetailNotifierProvider(defenseId).notifier).refresh();
          },
        ),
      ),
    );
  }
}

class _DefenseDetailContent extends ConsumerWidget {
  final Defense defense;

  const _DefenseDetailContent({required this.defense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con estado
          _buildHeader(context),
          
          const SizedBox(height: 24),
          
          // Información básica
          _buildSection(
            context,
            title: 'Información General',
            children: [
              _buildInfoRow('ID de Defensa:', defense.id),
              _buildInfoRow('Anteproyecto:', defense.anteprojectId),
              _buildInfoRow('Estudiante:', defense.studentId),
              _buildInfoRow('Tutor:', defense.tutorId),
              _buildInfoRow('Estado:', defense.status.displayName),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Programación
          _buildSection(
            context,
            title: 'Programación',
            children: [
              _buildInfoRow('Fecha Programada:', 
                DateFormat('dd/MM/yyyy HH:mm').format(defense.scheduledDate)),
              if (defense.location != null)
                _buildInfoRow('Ubicación:', defense.location!),
              if (defense.notes != null)
                _buildInfoRow('Notas:', defense.notes!),
            ],
          ),
          
          // Evaluación (si está completada)
          if (defense.status == DefenseStatus.completed) ...[
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: 'Evaluación',
              children: [
                if (defense.score != null)
                  _buildInfoRow('Puntuación:', '${defense.score}/10'),
                if (defense.evaluationComments != null)
                  _buildInfoRow('Comentarios:', defense.evaluationComments!),
                if (defense.completedDate != null)
                  _buildInfoRow('Fecha de Finalización:', 
                    DateFormat('dd/MM/yyyy HH:mm').format(defense.completedDate!)),
              ],
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Metadatos
          _buildSection(
            context,
            title: 'Metadatos',
            children: [
              _buildInfoRow('Creado:', 
                DateFormat('dd/MM/yyyy HH:mm').format(defense.createdAt)),
              if (defense.updatedAt != null)
                _buildInfoRow('Actualizado:', 
                  DateFormat('dd/MM/yyyy HH:mm').format(defense.updatedAt!)),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Acciones
          _buildActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    
    switch (defense.status) {
      case DefenseStatus.scheduled:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
      case DefenseStatus.inProgress:
        statusColor = Colors.blue;
        statusIcon = Icons.play_arrow;
        break;
      case DefenseStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case DefenseStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
    }

    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              statusIcon,
              color: statusColor,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Defensa #${defense.id.substring(0, 8)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    defense.status.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (defense.status.canStart)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(defensesNotifierProvider.notifier).startDefense(defense.id);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Iniciar Defensa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                
                if (defense.status.canComplete) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navegar a la página de evaluación
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Completar Defensa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                
                if (defense.status.canCancel) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar cancelación
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar Defensa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
} 