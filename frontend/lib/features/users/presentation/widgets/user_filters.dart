import 'package:fct_frontend/features/users/domain/entities/role_enum.dart';
import 'package:flutter/material.dart';

class UserFilters extends StatefulWidget {
  const UserFilters({
    super.key,
    required this.onFiltersChanged,
    required this.onClearFilters,
  });

  final Function(UserFiltersData filters) onFiltersChanged;
  final VoidCallback onClearFilters;

  @override
  State<UserFilters> createState() => _UserFiltersState();
}

class _UserFiltersState extends State<UserFilters> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedRole;
  bool? _selectedStatus;
  String _sortBy = 'name';
  String _sortOrder = 'asc';
  bool _showAdvancedFilters = false;

  final List<Map<String, String>> _sortOptions = [
    {'value': 'name', 'label': 'Nombre'},
    {'value': 'email', 'label': 'Email'},
    {'value': 'role', 'label': 'Rol'},
    {'value': 'createdAt', 'label': 'Fecha de creación'},
    {'value': 'lastName', 'label': 'Apellidos'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = UserFiltersData(
      search: _searchController.text.trim(),
      role: _selectedRole,
      isActive: _selectedStatus,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
    );
    widget.onFiltersChanged(filters);
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedRole = null;
      _selectedStatus = null;
      _sortBy = 'name';
      _sortOrder = 'asc';
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Búsqueda por texto
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, email o apellidos...',
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
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => _applyFilters(),
          ),

          const SizedBox(height: 16),

          // Filtros básicos
          Row(
            children: [
              // Filtro de rol
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Rol',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.security),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todos los roles'),
                    ),
                    ...RoleEnum.allRoles.map((role) => DropdownMenuItem<String>(
                          value: role.value,
                          child: Text(role.displayName),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                    _applyFilters();
                  },
                ),
              ),

              const SizedBox(width: 16),

              // Filtro de estado
              Expanded(
                child: DropdownButtonFormField<bool>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: const [
                    DropdownMenuItem<bool>(
                      value: null,
                      child: Text('Todos'),
                    ),
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Activos'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Inactivos'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    _applyFilters();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Botón para mostrar filtros avanzados
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showAdvancedFilters = !_showAdvancedFilters;
                  });
                },
                icon: Icon(_showAdvancedFilters
                    ? Icons.expand_less
                    : Icons.expand_more),
                label: Text(_showAdvancedFilters
                    ? 'Ocultar filtros avanzados'
                    : 'Mostrar filtros avanzados'),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Limpiar filtros'),
              ),
            ],
          ),

          // Filtros avanzados
          if (_showAdvancedFilters) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Ordenamiento
            Row(
              children: [
                const Text('Ordenar por: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: const InputDecoration(
                      labelText: 'Campo',
                      border: OutlineInputBorder(),
                    ),
                    items: _sortOptions
                        .map((option) => DropdownMenuItem<String>(
                              value: option['value']!,
                              child: Text(option['label']!),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortBy = value!;
                      });
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButtonFormField<String>(
                  value: _sortOrder,
                  decoration: const InputDecoration(
                    labelText: 'Orden',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'asc',
                      child: Text('Ascendente'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'desc',
                      child: Text('Descendente'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortOrder = value!;
                    });
                    _applyFilters();
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Datos de filtros para pasar al provider
class UserFiltersData {
  const UserFiltersData({
    this.search = '',
    this.role,
    this.isActive,
    this.sortBy = 'name',
    this.sortOrder = 'asc',
  });

  final String search;
  final String? role;
  final bool? isActive;
  final String sortBy;
  final String sortOrder;

  UserFiltersData copyWith({
    String? search,
    String? role,
    bool? isActive,
    String? sortBy,
    String? sortOrder,
  }) {
    return UserFiltersData(
      search: search ?? this.search,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  bool get hasActiveFilters =>
      search.isNotEmpty || role != null || isActive != null;

  @override
  String toString() {
    return 'UserFiltersData(search: $search, role: $role, isActive: $isActive, sortBy: $sortBy, sortOrder: $sortOrder)';
  }
}
