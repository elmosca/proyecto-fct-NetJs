import 'package:fct_frontend/features/anteprojects/domain/entities/notification.dart'
    as app_notification;
import 'package:fct_frontend/features/anteprojects/presentation/providers/notification_providers.dart';
import 'package:flutter/material.dart';

class NotificationFiltersWidget extends StatefulWidget {
  final Function(NotificationFilters) onFiltersChanged;

  const NotificationFiltersWidget({
    super.key,
    required this.onFiltersChanged,
  });

  @override
  State<NotificationFiltersWidget> createState() =>
      _NotificationFiltersWidgetState();
}

class _NotificationFiltersWidgetState extends State<NotificationFiltersWidget> {
  final TextEditingController _searchController = TextEditingController();
  app_notification.NotificationType? _selectedType;
  app_notification.NotificationStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onFiltersChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFiltersChanged() {
    final filters = NotificationFilters(
      type: _selectedType,
      status: _selectedStatus,
    );
    widget.onFiltersChanged(filters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar notificaciones...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // Filtros
          Row(
            children: [
              // Filtro por tipo
              Expanded(
                child: PopupMenuButton<app_notification.NotificationType>(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedType?.displayName ?? 'Todos los tipos',
                          style: TextStyle(
                            color: _selectedType != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  onSelected: (type) {
                    setState(() {
                      _selectedType = type;
                    });
                    _onFiltersChanged();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('Todos los tipos'),
                    ),
                    ...app_notification.NotificationType.values.map(
                      (type) => PopupMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Text(type.icon),
                            const SizedBox(width: 8),
                            Text(type.displayName),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Filtro por estado
              Expanded(
                child: PopupMenuButton<app_notification.NotificationStatus>(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedStatus?.displayName ?? 'Todos los estados',
                          style: TextStyle(
                            color: _selectedStatus != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  onSelected: (status) {
                    setState(() {
                      _selectedStatus = status;
                    });
                    _onFiltersChanged();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('Todos los estados'),
                    ),
                    ...app_notification.NotificationStatus.values.map(
                      (status) => PopupMenuItem(
                        value: status,
                        child: Text(status.displayName),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Botón para limpiar filtros
              IconButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _selectedType = null;
                    _selectedStatus = null;
                  });
                  _onFiltersChanged();
                },
                icon: const Icon(Icons.clear_all),
                tooltip: 'Limpiar filtros',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
