import { Controller } from '@nestjs/common';
import { SystemSettingsService } from './system-settings.service';

@Controller('system-settings')
export class SystemSettingsController {
  constructor(private readonly systemSettingsService: SystemSettingsService) {}

  // Endpoints de la API se implementarán aquí.
}
