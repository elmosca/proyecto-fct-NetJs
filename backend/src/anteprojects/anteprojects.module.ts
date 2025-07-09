import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Anteproject } from './entities/anteproject.entity';
import { AnteprojectsController } from './anteprojects.controller';
import { AnteprojectsService } from './anteprojects.service';
import { User } from '../users/entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Anteproject, User])],
  controllers: [AnteprojectsController],
  providers: [AnteprojectsService],
})
export class AnteprojectsModule {} 