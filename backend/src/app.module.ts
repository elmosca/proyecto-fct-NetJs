import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ActivityLogModule } from './activity-log/activity-log.module';
import { AnteprojectsModule } from './anteprojects/anteprojects.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { CommentsModule } from './comments/comments.module';
import { CommonModule } from './common/common.module';
import { EvaluationsModule } from './evaluations/evaluations.module';
import { FilesModule } from './files/files.module';
import { MilestonesModule } from './milestones/milestones.module';
import { NotificationsModule } from './notifications/notifications.module';
import { ProjectsModule } from './projects/projects.module';
import { RolesModule } from './roles/roles.module';
import { SystemSettingsModule } from './system-settings/system-settings.module';
import { TasksModule } from './tasks/tasks.module';
import { UsersModule } from './users/users.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    CommonModule,
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('DB_HOST', 'localhost'),
        port: +configService.get<number>('DB_PORT', 5432),
        username: configService.get('DB_USERNAME', 'postgres'),
        password: configService.get('DB_PASSWORD', 'postgres'),
        database: configService.get('DB_DATABASE', 'nestjs'),
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        autoLoadEntities: true,
        synchronize: configService.get('NODE_ENV') !== 'production',
      }),
      inject: [ConfigService],
    }),
    UsersModule,
    AuthModule,
    ProjectsModule,
    TasksModule,
    CommentsModule,
    RolesModule,
    AnteprojectsModule,
    MilestonesModule,
    FilesModule,
    NotificationsModule,
    ActivityLogModule,
    EvaluationsModule,
    SystemSettingsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
