import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { AnteprojectEvaluationCriteria } from 'src/evaluations/entities/anteproject_evaluation_criteria.entity';
import { Repository } from 'typeorm';

@Injectable()
export class AnteprojectEvaluationCriteriaSeedService {
  constructor(
    @InjectRepository(AnteprojectEvaluationCriteria)
    private readonly repository: Repository<AnteprojectEvaluationCriteria>,
  ) {}

  async run() {
    const data = [
      {
        name: 'Viabilidad técnica',
        description:
          'Factibilidad de implementación con los recursos disponibles',
        maxScore: 10.0,
        displayOrder: 1,
      },
      {
        name: 'Coherencia objetivos-resultados',
        description:
          'Alineación entre objetivos propuestos y resultados esperados',
        maxScore: 10.0,
        displayOrder: 2,
      },
      {
        name: 'Adecuación a competencias DAM',
        description: 'Cobertura de competencias del ciclo formativo',
        maxScore: 10.0,
        displayOrder: 3,
      },
      {
        name: 'Claridad en descripción',
        description: 'Calidad y claridad en la exposición del proyecto',
        maxScore: 10.0,
        displayOrder: 4,
      },
      {
        name: 'Realismo temporal',
        description: 'Viabilidad de la temporalización propuesta',
        maxScore: 10.0,
        displayOrder: 5,
      },
    ];

    for (const item of data) {
      const existing = await this.repository.findOne({
        where: { name: item.name },
      });
      if (!existing) {
        await this.repository.save(this.repository.create(item));
      }
    }
  }
}
