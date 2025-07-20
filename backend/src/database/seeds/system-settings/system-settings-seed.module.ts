import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SystemSetting } from '../../../system-settings/entities/system_setting.entity';
import { SystemSettingsSeedService } from './system-settings-seed.service';

@Module({
  imports: [TypeOrmModule.forFeature([SystemSetting])],
  providers: [SystemSettingsSeedService],
  exports: [SystemSettingsSeedService],
})
export class SystemSettingsSeedModule {} 