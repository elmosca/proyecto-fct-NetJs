import 'package:auto_route/auto_route.dart';
import 'package:fct_frontend/core/widgets/loading_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/anteproject_providers.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/anteproject_actions_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/anteproject_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AnteprojectDetailPage extends ConsumerWidget {
  final String anteprojectId;

  const AnteprojectDetailPage({
    super.key,
    @PathParam('id') required this.anteprojectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anteprojectAsync =
        ref.watch(anteprojectDetailNotifierProvider(anteprojectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Anteproyecto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(
                      anteprojectDetailNotifierProvider(anteprojectId).notifier)
                  .refresh();
            },
          ),
        ],
      ),
      body: anteprojectAsync.when(
        data: (anteproject) {
          if (anteproject == null) {
            return const Center(
              child: Text('Anteproyecto no encontrado'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnteprojectDetailWidget(anteproject: anteproject),
                const SizedBox(height: 24),
                AnteprojectActionsWidget(
                  anteproject: anteproject,
                  onActionCompleted: () {
                    ref
                        .read(anteprojectDetailNotifierProvider(anteprojectId)
                            .notifier)
                        .refresh();
                  },
                ),
              ],
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
                  ref
                      .read(anteprojectDetailNotifierProvider(anteprojectId)
                          .notifier)
                      .refresh();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
