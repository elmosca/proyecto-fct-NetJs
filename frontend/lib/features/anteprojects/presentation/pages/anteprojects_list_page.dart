import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/theme/app_colors.dart';
import 'package:fct_frontend/core/widgets/empty_state_widget.dart';
import 'package:fct_frontend/core/widgets/error_widget.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/anteproject.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/anteproject_providers.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/anteproject_card_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/anteproject_filters_widget.dart';
import 'package:fct_frontend/l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context).anteprojectsTitle),
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
                  return EmptyStateWidget(
                    icon: Icons.description_outlined,
                    title: AppLocalizations.of(context).noAnteprojectsTitle,
                    message:
                        AppLocalizations.of(context).noAnteprojectsMessage,
                    actionText: AppLocalizations.of(context).createAnteproject,
                    onActionPressed: () {
                      context.router.pushNamed('/anteprojects/create');
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(anteprojectsNotifierProvider.notifier).refresh();
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
              error: (error, stackTrace) => AppErrorWidget(
                message: error.toString(),
                onRetry: () {
                  ref.read(anteprojectsNotifierProvider.notifier).refresh();
                },
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
        title: Text(AppLocalizations.of(context).deleteAnteprojectTitle),
        content: Text(AppLocalizations.of(context).deleteAnteprojectMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(anteprojectsNotifierProvider.notifier)
                  .deleteAnteproject(anteproject.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog(Anteproject anteproject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).submitAnteprojectTitle),
        content: Text(AppLocalizations.of(context).submitAnteprojectMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(anteprojectsNotifierProvider.notifier)
                  .submitAnteproject(anteproject.id);
            },
            child: Text(AppLocalizations.of(context).submit),
          ),
        ],
      ),
    );
  }
}
