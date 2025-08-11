import 'package:flutter/material.dart';
import 'package:fct_frontend/features/anteprojects/domain/entities/defense.dart';
import 'package:fct_frontend/features/anteprojects/presentation/providers/defense_providers.dart';

class DefenseFiltersWidget extends StatefulWidget {
  final Function(DefenseFilters) onFiltersChanged;

  const DefenseFiltersWidget({
    super.key,
    required this.onFiltersChanged,
  });

  @override
  State<DefenseFiltersWidget> createState() => _DefenseFiltersWidgetState();
}

class _DefenseFiltersWidgetState extends State<DefenseFiltersWidget> {
  final TextEditingController _searchController = TextEditingController();
  DefenseStatus? _selectedStatus;

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
    final filters = DefenseFilters(
      search: _searchController.text,
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
              hintText: 'Buscar defensas...',
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Filtros adicionales
          Row(
            children: [
              // Filtro por estado
              Expanded(
                child: PopupMenuButton<DefenseStatus?>(
                  initialValue: _selectedStatus,
                  onSelected: (status) {
                    setState(() {
                      _selectedStatus = status;
                    });
                    _onFiltersChanged();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
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
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('Todos los estados'),
                    ),
                    ...DefenseStatus.values.map((status) => PopupMenuItem(
                      value: status,
                      child: Text(status.displayName),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Botón para limpiar filtros
              if (_searchController.text.isNotEmpty || _selectedStatus != null)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _selectedStatus = null;
                    });
                    _onFiltersChanged();
                  },
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Limpiar'),
                ),
            ],
          ),
        ],
      ),
    );
  }
} 
