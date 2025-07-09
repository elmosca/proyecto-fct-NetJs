import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ActivityLog } from './entities/activity_log.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ActivityLog])],
})
export class ActivityLogModule {} 