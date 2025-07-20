import { NestFactory } from '@nestjs/core';
import { SeedModule } from './seed.module';
import { AnteprojectEvaluationCriteriaSeedService } from './anteproject-evaluation-criteria/anteproject-evaluation-criteria-seed.service';
import { UserSeedService } from './user/user-seed.service';
import { SystemSettingsSeedService } from './system-settings/system-settings-seed.service';

const runSeed = async () => {
  const app = await NestFactory.create(SeedModule);

  // Run seeders
  await app.get(SystemSettingsSeedService).run();
  await app.get(AnteprojectEvaluationCriteriaSeedService).run();
  await app.get(UserSeedService).run();

  await app.close();
};

void runSeed();
