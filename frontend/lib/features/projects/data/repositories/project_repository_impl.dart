import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  // Mock data para desarrollo
  final List<ProjectEntity> _mockProjects = [
    ProjectEntity(
      id: '1',
      title: 'Sistema de Gestión de Biblioteca',
      description:
          'Desarrollo de una aplicación web para gestionar préstamos y devoluciones de libros en una biblioteca universitaria.',
      status: ProjectStatus.active,
      createdBy: 'admin@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      dueDate: DateTime.now().add(const Duration(days: 60)),
      assignedStudents: ['student1', 'student2'],
      tutors: ['tutor1'],
      tags: ['web', 'database', 'java'],
      attachments: ['doc1.pdf', 'diagram.png'],
      progress: 75,
      notes: 'Proyecto en fase de desarrollo avanzada',
    ),
    ProjectEntity(
      id: '2',
      title: 'App Móvil de Fitness',
      description:
          'Aplicación móvil para seguimiento de rutinas de ejercicio y nutrición personalizada.',
      status: ProjectStatus.draft,
      createdBy: 'admin@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      dueDate: DateTime.now().add(const Duration(days: 90)),
      assignedStudents: ['student3'],
      tutors: ['tutor2'],
      tags: ['mobile', 'flutter', 'health'],
      attachments: ['requirements.pdf'],
      progress: 25,
      notes: 'Proyecto en fase de planificación',
    ),
    ProjectEntity(
      id: '3',
      title: 'Sistema de E-commerce',
      description:
          'Plataforma completa de comercio electrónico con gestión de productos, carrito de compras y pagos.',
      status: ProjectStatus.completed,
      createdBy: 'admin@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      dueDate: DateTime.now().subtract(const Duration(days: 30)),
      assignedStudents: ['student4', 'student5'],
      tutors: ['tutor1', 'tutor3'],
      tags: ['web', 'ecommerce', 'payment'],
      attachments: ['final-report.pdf', 'presentation.pptx'],
      progress: 100,
      notes: 'Proyecto completado exitosamente',
    ),
    ProjectEntity(
      id: '4',
      title: 'Chatbot para Atención al Cliente',
      description:
          'Bot inteligente para responder consultas frecuentes y derivar casos complejos a agentes humanos.',
      status: ProjectStatus.onHold,
      createdBy: 'admin@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      dueDate: DateTime.now().add(const Duration(days: 45)),
      assignedStudents: ['student6'],
      tutors: ['tutor2'],
      tags: ['ai', 'chatbot', 'python'],
      attachments: ['ai-model.zip', 'training-data.csv'],
      progress: 60,
      notes: 'Proyecto pausado por falta de datos de entrenamiento',
    ),
  ];

  @override
  Future<List<ProjectEntity>> getProjects({
    String? search,
    ProjectStatus? status,
    String? createdBy,
    int? page,
    int? limit,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    List<ProjectEntity> filteredProjects = List.from(_mockProjects);

    // Aplicar filtros
    if (search != null && search.isNotEmpty) {
      filteredProjects = filteredProjects.where((project) {
        return project.title.toLowerCase().contains(search.toLowerCase()) ||
            project.description.toLowerCase().contains(search.toLowerCase()) ||
            project.tags
                .any((tag) => tag.toLowerCase().contains(search.toLowerCase()));
      }).toList();
    }

    if (status != null) {
      filteredProjects = filteredProjects
          .where((project) => project.status == status)
          .toList();
    }

    if (createdBy != null && createdBy.isNotEmpty) {
      filteredProjects = filteredProjects
          .where((project) => project.createdBy == createdBy)
          .toList();
    }

    // Aplicar paginación
    final startIndex = ((page ?? 1) - 1) * (limit ?? 20);
    final endIndex = startIndex + (limit ?? 20);

    if (startIndex >= filteredProjects.length) {
      return [];
    }

    return filteredProjects.sublist(
      startIndex,
      endIndex > filteredProjects.length ? filteredProjects.length : endIndex,
    );
  }

  @override
  Future<ProjectEntity?> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockProjects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProjectEntity> createProject(ProjectEntity project) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newProject = project.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );

    _mockProjects.add(newProject);
    return newProject;
  }

  @override
  Future<ProjectEntity> updateProject(ProjectEntity project) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _mockProjects.indexWhere((p) => p.id == project.id);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    final updatedProject = project.copyWith(
      updatedAt: DateTime.now(),
    );

    _mockProjects[index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<void> deleteProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockProjects.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    _mockProjects.removeAt(index);
  }

  @override
  Future<ProjectEntity> assignStudents(
      String projectId, List<String> studentIds) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockProjects.indexWhere((p) => p.id == projectId);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    final updatedProject = _mockProjects[index].copyWith(
      assignedStudents: studentIds,
      updatedAt: DateTime.now(),
    );

    _mockProjects[index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<ProjectEntity> assignTutors(
      String projectId, List<String> tutorIds) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockProjects.indexWhere((p) => p.id == projectId);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    final updatedProject = _mockProjects[index].copyWith(
      tutors: tutorIds,
      updatedAt: DateTime.now(),
    );

    _mockProjects[index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<ProjectEntity> updateProgress(String projectId, int progress) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockProjects.indexWhere((p) => p.id == projectId);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    final updatedProject = _mockProjects[index].copyWith(
      progress: progress,
      updatedAt: DateTime.now(),
    );

    _mockProjects[index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<ProjectEntity> updateStatus(
      String projectId, ProjectStatus status) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _mockProjects.indexWhere((p) => p.id == projectId);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    final updatedProject = _mockProjects[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    _mockProjects[index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<ProjectEntity> addAttachments(
      String projectId, List<String> attachmentIds) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _mockProjects.indexWhere((p) => p.id == projectId);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    final currentAttachments =
        List<String>.from(_mockProjects[index].attachments);
    currentAttachments.addAll(attachmentIds);

    final updatedProject = _mockProjects[index].copyWith(
      attachments: currentAttachments,
      updatedAt: DateTime.now(),
    );

    _mockProjects[index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<ProjectEntity> removeAttachments(
      String projectId, List<String> attachmentIds) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _mockProjects.indexWhere((p) => p.id == projectId);
    if (index == -1) {
      throw Exception('Proyecto no encontrado');
    }

    final currentAttachments =
        List<String>.from(_mockProjects[index].attachments);
    currentAttachments
        .removeWhere((attachment) => attachmentIds.contains(attachment));

    final updatedProject = _mockProjects[index].copyWith(
      attachments: currentAttachments,
      updatedAt: DateTime.now(),
    );

    _mockProjects[index] = updatedProject;
    return updatedProject;
  }
}
