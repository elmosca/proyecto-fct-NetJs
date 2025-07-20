import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Anteproject } from './entities/anteproject.entity';
import { AnteprojectsController } from './anteprojects.controller';
import { AnteprojectsService } from './anteprojects.service';
import { User } from '../users/entities/user.entity';
import { FilesModule } from '../files/files.module';

@Module({
  imports: [TypeOrmModule.forFeature([Anteproject, User]), FilesModule],
  controllers: [AnteprojectsController],
  providers: [AnteprojectsService],
  exports: [AnteprojectsService],
})
export class AnteprojectsModule {}
