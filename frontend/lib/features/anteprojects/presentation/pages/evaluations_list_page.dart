import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/evaluation.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/evaluation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class EvaluationsListPage extends ConsumerStatefulWidget {
  const EvaluationsListPage({super.key});

  @override
  ConsumerState<EvaluationsListPage> createState() =>
      _EvaluationsListPageState();
}

class _EvaluationsListPageState extends ConsumerState<EvaluationsListPage> {
  @override
  void initState() {
    super.initState();
    // Cargar evaluaciones al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(evaluationsNotifierProvider.notifier).loadEvaluations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final evaluationsAsync = ref.watch(evaluationsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluaciones de Defensas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navegar a crear evaluación
            },
            tooltip: 'Crear Evaluación',
          ),
        ],
      ),
      body: evaluationsAsync.when(
        data: (evaluations) {
          if (evaluations.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assessment, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay evaluaciones',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Las evaluaciones aparecerán aquí cuando se creen',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(evaluationsNotifierProvider.notifier).loadEvaluations();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: evaluations.length,
              itemBuilder: (context, index) {
                final evaluation = evaluations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(evaluation.status),
                      child: Text(
                        evaluation.totalScore.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text('Evaluación #${evaluation.id.substring(0, 8)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Defensa: ${evaluation.defenseId}'),
                        Text('Evaluador: ${evaluation.evaluatorId}'),
                        Text('Estado: ${evaluation.status.displayName}'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(evaluation.status.displayName),
                      backgroundColor:
                          _getStatusColor(evaluation.status).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: _getStatusColor(evaluation.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      // TODO: Navegar al detalle de la evaluación
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(evaluationsNotifierProvider.notifier)
                      .loadEvaluations();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(EvaluationStatus status) {
    switch (status) {
      case EvaluationStatus.draft:
        return Colors.orange;
      case EvaluationStatus.submitted:
        return Colors.blue;
      case EvaluationStatus.approved:
        return Colors.green;
      case EvaluationStatus.rejected:
        return Colors.red;
    }
  }
}
