import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class CreateMilestoneUseCase {
  final MilestoneRepository _milestoneRepository;

  CreateMilestoneUseCase(this._milestoneRepository);

  Future<MilestoneEntity> execute(CreateMilestoneDto createMilestoneDto) {
    // Convertir DTO a entidad
    final milestone = MilestoneEntity(
      id: '', // Se asignará en el backend
      projectId: createMilestoneDto.projectId,
      milestoneNumber: createMilestoneDto.milestoneNumber,
      title: createMilestoneDto.title,
      description: createMilestoneDto.description,
      plannedDate: createMilestoneDto.plannedDate,
      milestoneType: createMilestoneDto.milestoneType,
      isFromAnteproject: createMilestoneDto.isFromAnteproject,
      expectedDeliverables: createMilestoneDto.expectedDeliverables,
      createdAt: DateTime.now(),
    );

    return _milestoneRepository..(milestone);
  }
}
