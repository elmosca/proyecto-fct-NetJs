import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/anteproject_providers.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/anteproject_card_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/anteproject_filters_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AnteprojectsListPage extends ConsumerStatefulWidget {
  const AnteprojectsListPage({super.key});

  @override
  ConsumerState<AnteprojectsListPage> createState() =>
      _AnteprojectsListPageState();
}

class _AnteprojectsListPageState extends ConsumerState<AnteprojectsListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Cargar más datos cuando se acerca al final
      final filters = ref.read(anteprojectFiltersNotifierProvider);
      final currentPage = filters.page;
      ref
          .read(anteprojectFiltersNotifierProvider.notifier)
          .updatePage(currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(anteprojectFiltersNotifierProvider);
    final anteprojectsAsync = ref.watch(anteprojectsNotifierProvider(
      search: filters.search,
      status: filters.status,
      studentId: filters.studentId,
      tutorId: filters.tutorId,
      page: filters.page,
      limit: filters.limit,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anteproyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar a crear anteproyecto
              context.router.pushNamed('/anteprojects/create');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          AnteprojectFiltersWidget(
            onFiltersChanged: (newFilters) {
              ref
                  .read(anteprojectFiltersNotifierProvider.notifier)
                  .updateSearch(newFilters.search ?? '');
              ref
                  .read(anteprojectFiltersNotifierProvider.notifier)
                  .updateStatus(newFilters.status);
              ref
                  .read(anteprojectFiltersNotifierProvider.notifier)
                  .updateStudentId(newFilters.studentId);
              ref
                  .read(anteprojectFiltersNotifierProvider.notifier)
                  .updateTutorId(newFilters.tutorId);
            },
          ),

          // Lista de anteproyectos
          Expanded(
            child: anteprojectsAsync.when(
              data: (anteprojects) {
                if (anteprojects.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.description_outlined,
                    title: 'No hay anteproyectos',
                    message:
                        'No se encontraron anteproyectos con los filtros aplicados',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(anteprojectsNotifierProvider(
                      search: filters.search,
                      status: filters.status,
                      studentId: filters.studentId,
                      tutorId: filters.tutorId,
                      page: filters.page,
                      limit: filters.limit,
                    ));
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: anteprojects.length,
                    itemBuilder: (context, index) {
                      final anteproject = anteprojects[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnteprojectCardWidget(
                          anteproject: anteproject,
                          onTap: () {
                            context.router
                                .pushNamed('/anteprojects/${anteproject.id}');
                          },
                          onEdit: anteproject.status.canEdit
                              ? () {
                                  context.router.pushNamed(
                                      '/anteprojects/${anteproject.id}/edit');
                                }
                              : null,
                          onDelete: anteproject.status.canEdit
                              ? () {
                                  _showDeleteDialog(anteproject);
                                }
                              : null,
                          onSubmit: anteproject.status.canSubmit
                              ? () {
                                  _showSubmitDialog(anteproject);
                                }
                              : null,
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
                    Text('Error: ${error.toString()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(anteprojectsNotifierProvider(
                          search: filters.search,
                          status: filters.status,
                          studentId: filters.studentId,
                          tutorId: filters.tutorId,
                          page: filters.page,
                          limit: filters.limit,
                        ));
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

  void _showDeleteDialog(Anteproject anteproject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Anteproyecto'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar este anteproyecto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar eliminación de anteproyecto
              ref.invalidate(anteprojectsNotifierProvider);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog(Anteproject anteproject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enviar Anteproyecto'),
        content: const Text(
            '¿Estás seguro de que quieres enviar este anteproyecto para revisión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar envío de anteproyecto
              ref.invalidate(anteprojectsNotifierProvider);
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
