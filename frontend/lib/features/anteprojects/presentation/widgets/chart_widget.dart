import 'package:flutter/material.dart';

enum ChartType { pie, bar, line }

class ChartWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final ChartType chartType;

  const ChartWidget({
    super.key,
    required this.title,
    required this.data,
    required this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    if (data.isEmpty) {
      return const Center(
        child: Text('No hay datos disponibles'),
      );
    }

    switch (chartType) {
      case ChartType.pie:
        return _buildPieChart();
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.line:
        return _buildLineChart();
    }
  }

  Widget _buildPieChart() {
    final entries = data.entries.toList();
    final total =
        entries.fold<double>(0, (sum, entry) => sum + (entry.value as num));

    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: const Size(150, 150),
            painter: PieChartPainter(entries, total),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final percentage =
                  total > 0 ? (entry.value as num) / total * 100 : 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getColor(index),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${entry.key}: ${entry.value} (${percentage.toStringAsFixed(1)}%)',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    final entries = data.entries.toList();
    final maxValue = entries.fold<double>(
      0,
      (max, entry) => (entry.value as num).toDouble() > max
          ? (entry.value as num).toDouble()
          : max,
    );

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: entries.map((entry) {
              final height = maxValue > 0
                  ? (entry.value as num).toDouble() / maxValue
                  : 0.0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            heightFactor: height,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        entry.key,
                        style: const TextStyle(fontSize: 8),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    // Implementación simplificada de gráfico de líneas
    return const Center(
      child: Text('Gráfico de líneas - En desarrollo'),
    );
  }

  Color _getColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}

class PieChartPainter extends CustomPainter {
  final List<MapEntry<String, dynamic>> entries;
  final double total;

  PieChartPainter(this.entries, this.total);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = 0;
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final sweepAngle = total > 0
          ? (entry.value as num).toDouble() / total * 2 * 3.14159
          : 0.0;

      final paint = Paint()
        ..color = _getColor(i)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Color _getColor(int index) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }
}
