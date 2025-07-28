import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message = 'Cargando...',
    this.size = LoadingSize.medium,
    this.color,
  });

  final String message;
  final LoadingSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.value,
              height: size.value,
              child: CircularProgressIndicator(
                color: color ?? Theme.of(context).primaryColor,
                strokeWidth: size.strokeWidth,
              ),
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
}

class LoadingSize {
  const LoadingSize._(this.value, this.strokeWidth);

  final double value;
  final double strokeWidth;

  static const LoadingSize small = LoadingSize._(24, 2);
  static const LoadingSize medium = LoadingSize._(32, 3);
  static const LoadingSize large = LoadingSize._(48, 4);
  static const LoadingSize extraLarge = LoadingSize._(64, 5);
}

/// Widget de carga para botones
class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    this.message = 'Cargando...',
    this.size = 16,
    this.color,
  });

  final String message;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? Colors.white,
              strokeWidth: 2,
            ),
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color ?? Colors.white,
                  ),
            ),
          ],
        ],
      );
}

/// Widget de carga para listas
class LoadingListWidget extends StatelessWidget {
  const LoadingListWidget({
    super.key,
    this.itemCount = 3,
    this.message = 'Cargando elementos...',
  });

  final int itemCount;
  final String message;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: itemCount,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                  title: Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  subtitle: Container(
                    height: 12,
                    width: 200,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
}

/// Widget de carga para pantallas completas
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
    this.message = 'Cargando aplicación...',
    this.showLogo = true,
  });

  final String message;
  final bool showLogo;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showLogo) ...[
                Icon(
                  Icons.school,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
              ],
              const LoadingWidget(
                message: '',
                size: LoadingSize.large,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.color
                          ?.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
