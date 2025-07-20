import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SystemSetting, SettingTypeEnum } from '../../../system-settings/entities/system_setting.entity';

@Injectable()
export class SystemSettingsSeedService {
  constructor(
    @InjectRepository(SystemSetting)
    private readonly repository: Repository<SystemSetting>,
  ) {}

  async run() {
    const settings = [
      {
        settingKey: 'allowed_file_types',
        settingValue: JSON.stringify(['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png', 'gif']),
        settingType: SettingTypeEnum.JSON,
        description: 'Tipos de archivos permitidos para subida',
        isEditable: true,
      },
      {
        settingKey: 'max_file_size_mb',
        settingValue: '50',
        settingType: SettingTypeEnum.INTEGER,
        description: 'Tamaño máximo de archivo en MB',
        isEditable: true,
      },
      {
        settingKey: 'app_name',
        settingValue: 'Sistema de Gestión de Proyectos FCT',
        settingType: SettingTypeEnum.STRING,
        description: 'Nombre de la aplicación',
        isEditable: true,
      },
      {
        settingKey: 'app_version',
        settingValue: '1.0.0',
        settingType: SettingTypeEnum.STRING,
        description: 'Versión actual de la aplicación',
        isEditable: false,
      },
      {
        settingKey: 'maintenance_mode',
        settingValue: 'false',
        settingType: SettingTypeEnum.BOOLEAN,
        description: 'Modo de mantenimiento activo',
        isEditable: true,
      }
    ];

    for (const settingData of settings) {
      const existingSetting = await this.repository.findOne({
        where: { settingKey: settingData.settingKey },
      });

      if (!existingSetting) {
        const newSetting = this.repository.create(settingData);
        await this.repository.save(newSetting);
        console.log(`✅ Created system setting: ${settingData.settingKey}`);
      } else {
        console.log(`⚠️  System setting already exists: ${settingData.settingKey}`);
      }
    }
  }
} 