import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { dataSourceOptions } from '../../data-source';
import { AnteprojectEvaluationCriteriaSeedModule } from './anteproject-evaluation-criteria/anteproject-evaluation-criteria-seed.module';
import { UserSeedModule } from './user/user-seed.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env'],
    }),
    TypeOrmModule.forRoot(dataSourceOptions),
    AnteprojectEvaluationCriteriaSeedModule,
    UserSeedModule,
  ],
})
export class SeedModule {} 