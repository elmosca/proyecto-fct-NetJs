import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/defense_providers.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/defense_card_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/defense_filters_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class DefensesListPage extends ConsumerStatefulWidget {
  const DefensesListPage({super.key});

  @override
  ConsumerState<DefensesListPage> createState() => _DefensesListPageState();
}

class _DefensesListPageState extends ConsumerState<DefensesListPage> {
  @override
  void initState() {
    super.initState();
    // Cargar defensas al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(defensesNotifierProvider.notifier).loadDefenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final defensesAsync = ref.watch(defensesNotifierProvider);
    final filters = ref.watch(defenseFiltersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Defensas de Anteproyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navegar a crear defensa
            },
            tooltip: 'Programar Defensa',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          DefenseFiltersWidget(
            onFiltersChanged: (newFilters) {
              ref
                  .read(defenseFiltersNotifierProvider.notifier)
                  .updateSearch(newFilters.search);
              ref
                  .read(defenseFiltersNotifierProvider.notifier)
                  .updateStatus(newFilters.status);
              ref
                  .read(defenseFiltersNotifierProvider.notifier)
                  .updateAnteprojectId(newFilters.anteprojectId);
              ref
                  .read(defenseFiltersNotifierProvider.notifier)
                  .updateStudentId(newFilters.studentId);
              ref
                  .read(defenseFiltersNotifierProvider.notifier)
                  .updateTutorId(newFilters.tutorId);

              // Aplicar filtros
              ref.read(defensesNotifierProvider.notifier).loadDefenses(
                    anteprojectId: newFilters.anteprojectId,
                    studentId: newFilters.studentId,
                    tutorId: newFilters.tutorId,
                    status: newFilters.status,
                  );
            },
          ),

          // Lista de defensas
          Expanded(
            child: defensesAsync.when(
              data: (defenses) {
                if (defenses.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.schedule,
                    title: 'No hay defensas programadas',
                    message:
                        'No se encontraron defensas con los filtros aplicados.',
                  );
                }

                // Filtrar por búsqueda si hay texto
                final filteredDefenses = filters.search.isEmpty
                    ? defenses
                    : defenses.where((defense) {
                        // TODO: Implementar búsqueda por título del anteproyecto, estudiante, etc.
                        return true;
                      }).toList();

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(defensesNotifierProvider.notifier).loadDefenses();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredDefenses.length,
                    itemBuilder: (context, index) {
                      final defense = filteredDefenses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DefenseCardWidget(
                          defense: defense,
                          onTap: () {
                            // TODO: Navegar al detalle de la defensa
                          },
                          onStart: () {
                            _startDefense(defense);
                          },
                          onComplete: () {
                            _completeDefense(defense);
                          },
                          onCancel: () {
                            _cancelDefense(defense);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${error.toString()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(defensesNotifierProvider.notifier)
                            .loadDefenses();
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startDefense(Defense defense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Iniciar Defensa'),
        content: Text(
            '¿Estás seguro de que quieres iniciar la defensa de "${defense.anteprojectId}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(defensesNotifierProvider.notifier)
                  .startDefense(defense.id);
            },
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );
  }

  void _completeDefense(Defense defense) {
    // TODO: Navegar a la página de evaluación
  }

  void _cancelDefense(Defense defense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Defensa'),
        content:
            const Text('¿Estás seguro de que quieres cancelar esta defensa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar cancelación
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancelar Defensa'),
          ),
        ],
      ),
    );
  }
}
