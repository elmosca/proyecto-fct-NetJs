import 'package:fct_frontend/shared/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectAssignmentWidget extends ConsumerStatefulWidget {
  final String projectId;
  final List<String> currentStudents;
  final List<String> currentTutors;
  final Function(List<String>) onStudentsAssigned;
  final Function(List<String>) onTutorsAssigned;

  const ProjectAssignmentWidget({
    super.key,
    required this.projectId,
    required this.currentStudents,
    required this.currentTutors,
    required this.onStudentsAssigned,
    required this.onTutorsAssigned,
  });

  @override
  ConsumerState<ProjectAssignmentWidget> createState() =>
      _ProjectAssignmentWidgetState();
}

class _ProjectAssignmentWidgetState
    extends ConsumerState<ProjectAssignmentWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _selectedStudents = [];
  List<String> _selectedTutors = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedStudents = List.from(widget.currentStudents);
    _selectedTutors = List.from(widget.currentTutors);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.school),
              text: 'Estudiantes',
            ),
            Tab(
              icon: Icon(Icons.person),
              text: 'Tutores',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStudentsTab(),
              _buildTutorsTab(),
            ],
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildStudentsTab() {
    return _buildAssignmentList(
      title: 'Asignar Estudiantes',
      currentAssignments: widget.currentStudents,
      selectedAssignments: _selectedStudents,
      onSelectionChanged: (selected) {
        setState(() {
          _selectedStudents = selected;
        });
      },
      // TODO: Implementar provider para obtener lista de estudiantes
      availableItems: _getMockStudents(),
    );
  }

  Widget _buildTutorsTab() {
    return _buildAssignmentList(
      title: 'Asignar Tutores',
      currentAssignments: widget.currentTutors,
      selectedAssignments: _selectedTutors,
      onSelectionChanged: (selected) {
        setState(() {
          _selectedTutors = selected;
        });
      },
      // TODO: Implementar provider para obtener lista de tutores
      availableItems: _getMockTutors(),
    );
  }

  Widget _buildAssignmentList({
    required String title,
    required List<String> currentAssignments,
    required List<String> selectedAssignments,
    required Function(List<String>) onSelectionChanged,
    required List<User> availableItems,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: availableItems.length,
            itemBuilder: (context, index) {
              final user = availableItems[index];
              final isSelected = selectedAssignments.contains(user.id);
              final isCurrentlyAssigned = currentAssignments.contains(user.id);

              return CheckboxListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
                value: isSelected,
                onChanged: (bool? value) {
                  final newSelection = List<String>.from(selectedAssignments);
                  if (value == true) {
                    newSelection.add(user.id);
                  } else {
                    newSelection.remove(user.id);
                  }
                  onSelectionChanged(newSelection);
                },
                secondary: CircleAvatar(
                  backgroundColor:
                      isCurrentlyAssigned ? Colors.green : Colors.grey,
                  child: Text(
                    user.firstName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                tileColor:
                    isCurrentlyAssigned ? Colors.green.withOpacity(0.1) : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onStudentsAssigned(_selectedStudents);
                widget.onTutorsAssigned(_selectedTutors);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }

  // Mock data - TODO: Reemplazar con providers reales
  List<User> _getMockStudents() {
    return [
      const User(
        id: '1',
        email: 'estudiante1@example.com',
        firstName: 'Ana',
        lastName: 'García',
        role: 'student',
      ),
      const User(
        id: '2',
        email: 'estudiante2@example.com',
        firstName: 'Carlos',
        lastName: 'López',
        role: 'student',
      ),
      const User(
        id: '3',
        email: 'estudiante3@example.com',
        firstName: 'María',
        lastName: 'Rodríguez',
        role: 'student',
      ),
    ];
  }

  List<User> _getMockTutors() {
    return [
      const User(
        id: '4',
        email: 'tutor1@example.com',
        firstName: 'Dr. Juan',
        lastName: 'Pérez',
        role: 'tutor',
      ),
      const User(
        id: '5',
        email: 'tutor2@example.com',
        firstName: 'Dra. Laura',
        lastName: 'Martínez',
        role: 'tutor',
      ),
    ];
  }
}
