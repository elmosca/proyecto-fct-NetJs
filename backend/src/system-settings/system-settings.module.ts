import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SystemSetting } from './entities/system_setting.entity';

@Module({
  imports: [TypeOrmModule.forFeature([SystemSetting])],
})
export class SystemSettingsModule {} 