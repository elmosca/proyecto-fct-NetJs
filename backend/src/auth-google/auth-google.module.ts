import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule } from '@nestjs/config';
import { UsersModule } from '../users/users.module';
import { AuthGoogleService } from './auth-google.service';
import { AuthGoogleController } from './auth-google.controller';
import { GoogleStrategy } from './google.strategy';

@Module({
  imports: [PassportModule, ConfigModule, UsersModule],
  controllers: [AuthGoogleController],
  providers: [AuthGoogleService, GoogleStrategy],
  exports: [AuthGoogleService],
})
export class AuthGoogleModule {}
