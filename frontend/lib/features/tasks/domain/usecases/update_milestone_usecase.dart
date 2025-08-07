import 'package:fct_frontend/features/tasks/domain/entities/milestone_entity.dart';
import 'package:fct_frontend/features/tasks/domain/entities/milestone_dto.dart';
import 'package:fct_frontend/features/tasks/domain/repositories/milestone_repository.dart';

class UpdateMilestoneUseCase {
  final MilestoneRepository _milestoneRepository;

  UpdateMilestoneUseCase(this._milestoneRepository);

  Future<MilestoneEntity> execute(String milestoneId, UpdateMilestoneDto updateMilestoneDto) async {
    // Primero obtener el milestone existente
    final existingMilestone = await _milestoneRepository.getMilestoneById(milestoneId);
    if (existingMilestone == null) {
      throw Exception('Milestone no encontrado');
    }
    
    // Crear un nuevo milestone con los datos actualizados
    final updatedMilestone = MilestoneEntity(
      id: milestoneId,
      projectId: existingMilestone.projectId,
      milestoneNumber: existingMilestone.milestoneNumber,
      title: updateMilestoneDto.title ?? existingMilestone.title,
      description: updateMilestoneDto.description ?? existingMilestone.description,
      plannedDate: updateMilestoneDto.plannedDate ?? existingMilestone.plannedDate,
      completedDate: updateMilestoneDto.completedDate ?? existingMilestone.completedDate,
      status: updateMilestoneDto.status ?? existingMilestone.status,
      milestoneType: updateMilestoneDto.milestoneType ?? existingMilestone.milestoneType,
      expectedDeliverables: updateMilestoneDto.expectedDeliverables ?? existingMilestone.expectedDeliverables,
      reviewComments: updateMilestoneDto.reviewComments ?? existingMilestone.reviewComments,
      createdAt: existingMilestone.createdAt,
      updatedAt: DateTime.now(),
    );
    
    return _milestoneRepository.updateMilestone(updatedMilestone);
  }
}
