// Módulo de Evaluaciones - Sistema FCT
// Este módulo maneja todo el sistema de evaluaciones de anteproyectos y proyectos

export 'data/datasources/evaluation_local_data_source.dart';
// Data Layer
export 'data/datasources/evaluation_remote_data_source.dart';
export 'data/models/evaluation_criteria_model.dart';
export 'data/models/evaluation_model.dart';
export 'data/repositories/evaluation_repository_impl.dart';
// Domain Layer
export 'domain/entities/evaluation.dart';
export 'domain/entities/evaluation_criteria.dart';
export 'domain/entities/evaluation_result.dart';
export 'domain/repositories/evaluation_repository.dart';
export 'domain/usecases/calculate_evaluation_score_usecase.dart';
export 'domain/usecases/create_evaluation_usecase.dart';
export 'domain/usecases/delete_evaluation_usecase.dart';
export 'domain/usecases/get_evaluation_criteria_usecase.dart';
export 'domain/usecases/get_evaluation_statistics_usecase.dart';
export 'domain/usecases/get_evaluations_usecase.dart';
export 'domain/usecases/update_evaluation_usecase.dart';
export 'presentation/pages/create_evaluation_page.dart';
// Presentation Layer
export 'presentation/pages/evaluations_list_page.dart';
export 'presentation/providers/evaluation_providers.dart';
export 'presentation/widgets/evaluation_card.dart';
