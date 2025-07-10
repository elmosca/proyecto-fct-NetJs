import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SystemSetting } from './entities/system_setting.entity';

@Injectable()
export class SystemSettingsService {
  constructor(
    @InjectRepository(SystemSetting)
    private readonly systemSettingRepository: Repository<SystemSetting>,
  ) {}

  async findOne(key: string): Promise<SystemSetting> {
    const setting = await this.systemSettingRepository.findOne({
      where: { settingKey: key },
    });

    if (!setting) {
      throw new NotFoundException(`Setting with key "${key}" not found`);
    }

    return setting;
  }

  async getValue(key: string): Promise<any> {
    const setting = await this.findOne(key);

    switch (setting.settingType) {
      case 'json':
        try {
          return JSON.parse(setting.settingValue);
        } catch (error) {
          // Si falla el parseo, devolver el valor como string.
          // También se podría loggear el error.
          return setting.settingValue;
        }
      case 'integer':
        return parseInt(setting.settingValue, 10);
      case 'boolean':
        return setting.settingValue.toLowerCase() === 'true';
      case 'string':
      default:
        return setting.settingValue;
    }
  }
} 