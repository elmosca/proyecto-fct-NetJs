import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MulterModule } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import * as path from 'path';
import * as fs from 'fs';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { SystemSettingsModule } from '../system-settings/system-settings.module';
import { SystemSettingsService } from '../system-settings/system-settings.service';
import { File } from './entities/file.entity';
import { FilesService } from './files.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([File]),
    SystemSettingsModule, // Importar para poder inyectar el servicio
    MulterModule.registerAsync({
      imports: [SystemSettingsModule, ConfigModule], // Importar módulos necesarios para la factory
      useFactory: async (
        systemSettingsService: SystemSettingsService,
        configService: ConfigService,
      ) => {
        const allowedFileTypes =
          await systemSettingsService.getValue('allowed_file_types');

        const maxFileSize =
          (await systemSettingsService.getValue('max_file_size_mb')) || 50;

        return {
          storage: diskStorage({
            destination: (req, file, cb) => {
              const uploadPath =
                configService.get<string>('UPLOAD_LOCATION') ||
                './storage/uploads';
              if (!fs.existsSync(uploadPath)) {
                fs.mkdirSync(uploadPath, { recursive: true });
              }
              cb(null, uploadPath);
            },
            filename: (req, file, cb) => {
              const uniqueSuffix =
                Date.now() + '-' + Math.round(Math.random() * 1e9);
              const extension = path.extname(file.originalname);
              cb(null, `${uniqueSuffix}${extension}`);
            },
          }),
          fileFilter: (req, file, cb) => {
            const extension = path.extname(file.originalname).substring(1);
            if (allowedFileTypes.includes(extension)) {
              cb(null, true);
            } else {
              cb(
                new Error(
                  `File type not allowed. Allowed types: ${allowedFileTypes.join(', ')}`,
                ),
                false,
              );
            }
          },
          limits: {
            fileSize: maxFileSize * 1024 * 1024,
          },
        };
      },
      inject: [SystemSettingsService, ConfigService], // Inyectar los servicios
    }),
  ],
  providers: [FilesService],
  exports: [FilesService],
})
export class FilesModule {}
