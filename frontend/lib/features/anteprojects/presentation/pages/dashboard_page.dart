import 'package:fct_frontend/features/anteprojects/presentation/providers/report_providers.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/chart_widget.dart';
import 'package:fct_frontend/features/anteprojects/presentation/widgets/metric_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Cargar métricas al inicializar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardMetricsNotifierProvider.notifier).loadMetrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(dashboardMetricsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dashboardMetricsNotifierProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: metricsAsync.when(
        data: (metrics) {
          if (metrics == null) {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Métricas principales
                const Text(
                  'Métricas Principales',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    MetricCardWidget(
                      title: 'Total Anteproyectos',
                      value: metrics.totalAnteprojects.toString(),
                      icon: Icons.assignment,
                      color: Colors.blue,
                    ),
                    MetricCardWidget(
                      title: 'Anteproyectos Activos',
                      value: metrics.activeAnteprojects.toString(),
                      icon: Icons.work,
                      color: Colors.orange,
                    ),
                    MetricCardWidget(
                      title: 'Anteproyectos Completados',
                      value: metrics.completedAnteprojects.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                    MetricCardWidget(
                      title: 'Total Defensas',
                      value: metrics.totalDefenses.toString(),
                      icon: Icons.gavel,
                      color: Colors.purple,
                    ),
                    MetricCardWidget(
                      title: 'Defensas Programadas',
                      value: metrics.scheduledDefenses.toString(),
                      icon: Icons.schedule,
                      color: Colors.indigo,
                    ),
                    MetricCardWidget(
                      title: 'Defensas Completadas',
                      value: metrics.completedDefenses.toString(),
                      icon: Icons.done_all,
                      color: Colors.teal,
                    ),
                    MetricCardWidget(
                      title: 'Total Estudiantes',
                      value: metrics.totalStudents.toString(),
                      icon: Icons.people,
                      color: Colors.cyan,
                    ),
                    MetricCardWidget(
                      title: 'Total Tutores',
                      value: metrics.totalTutors.toString(),
                      icon: Icons.school,
                      color: Colors.amber,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Métricas de rendimiento
                const Text(
                  'Rendimiento',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: MetricCardWidget(
                        title: 'Promedio de Calificaciones',
                        value: '${metrics.averageScore.toStringAsFixed(1)}/10',
                        icon: Icons.star,
                        color: Colors.yellow.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: MetricCardWidget(
                        title: 'Tasa de Finalización',
                        value:
                            '${(metrics.completionRate * 100).toStringAsFixed(1)}%',
                        icon: Icons.trending_up,
                        color: Colors.lightGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Gráficos
                const Text(
                  'Distribución por Estado',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ChartWidget(
                        title: 'Anteproyectos por Estado',
                        data: metrics.anteprojectsByStatus,
                        chartType: ChartType.pie,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ChartWidget(
                        title: 'Defensas por Estado',
                        data: metrics.defensesByStatus,
                        chartType: ChartType.pie,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Distribución de calificaciones
                const Text(
                  'Distribución de Calificaciones',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ChartWidget(
                  title: 'Rango de Calificaciones',
                  data: metrics.scoresDistribution,
                  chartType: ChartType.bar,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar métricas: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(dashboardMetricsNotifierProvider.notifier).refresh();
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
