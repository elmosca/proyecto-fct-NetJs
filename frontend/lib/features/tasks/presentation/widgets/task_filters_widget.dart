import 'package:flutter/material.dart';
import 'package:fct_frontend/features/tasks/domain/entities/task.dart';

class TaskFiltersWidget extends StatefulWidget {
  final String? selectedStatus;
  final String? selectedPriority;
  final String? assignedUserId;
  final String? searchQuery;
  final Function(String?, String?, String?, String?) onFiltersChanged;

  const TaskFiltersWidget({
    super.key,
    this.selectedStatus,
    this.selectedPriority,
    this.assignedUserId,
    this.searchQuery,
    required this.onFiltersChanged,
  });

  @override
  State<TaskFiltersWidget> createState() => _TaskFiltersWidgetState();
}

class _TaskFiltersWidgetState extends State<TaskFiltersWidget> {
  late TextEditingController _searchController;
  String? _selectedStatus;
  String? _selectedPriority;
  String? _assignedUserId;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _selectedStatus = widget.selectedStatus;
    _selectedPriority = widget.selectedPriority;
    _assignedUserId = widget.assignedUserId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar tareas...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              _applyFilters();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Filtros
          Row(
            children: [
              // Filtro de estado
              Expanded(
                child: _buildStatusFilter(),
              ),
              const SizedBox(width: 8),
              
              // Filtro de prioridad
              Expanded(
                child: _buildPriorityFilter(),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Botón para limpiar filtros
          if (_hasActiveFilters())
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Limpiar filtros'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: const InputDecoration(
        labelText: 'Estado',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Todos'),
        ),
        ...TaskStatus.values.map((status) => DropdownMenuItem<String>(
          value: status.name,
          child: Row(
            children: [
              Text(status.icon),
              const SizedBox(width: 8),
              Text(status.displayName),
            ],
          ),
        )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedStatus = value;
        });
        _applyFilters();
      },
    );
  }

  Widget _buildPriorityFilter() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      decoration: const InputDecoration(
        labelText: 'Prioridad',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Todas'),
        ),
        ...TaskPriority.values.map((priority) => DropdownMenuItem<String>(
          value: priority.name,
          child: Row(
            children: [
              Text(priority.icon),
              const SizedBox(width: 8),
              Text(priority.displayName),
            ],
          ),
        )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedPriority = value;
        });
        _applyFilters();
      },
    );
  }

  bool _hasActiveFilters() {
    return _selectedStatus != null ||
           _selectedPriority != null ||
           _assignedUserId != null ||
           _searchController.text.isNotEmpty;
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedPriority = null;
      _assignedUserId = null;
      _searchController.clear();
    });
    _applyFilters();
  }

  void _applyFilters() {
    widget.onFiltersChanged(
      _selectedStatus,
      _selectedPriority,
      _assignedUserId,
      _searchController.text.isEmpty ? null : _searchController.text,
    );
  }
} 
