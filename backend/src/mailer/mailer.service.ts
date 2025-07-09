import { Injectable } from '@nestjs/common';
import { MailerService as NestMailerService } from '@nestjs-modules/mailer';

@Injectable()
export class MailerService {
  constructor(private readonly mailerService: NestMailerService) {}

  async sendMail(to: string, subject: string, template: string, context: any) {
    await this.mailerService.sendMail({
      to,
      subject,
      template,
      context,
    });
  }

  async sendWelcomeEmail(to: string, name: string) {
    await this.sendMail(
      to,
      'Bienvenido a Proyecto FCT',
      'welcome',
      {
        name,
      },
    );
  }

  async sendPasswordResetEmail(to: string, resetToken: string) {
    await this.sendMail(
      to,
      'Recuperación de contraseña',
      'password-reset',
      {
        resetToken,
      },
    );
  }

  async sendProjectInvitationEmail(to: string, projectName: string, inviterName: string) {
    await this.sendMail(
      to,
      'Invitación a proyecto',
      'project-invitation',
      {
        projectName,
        inviterName,
      },
    );
  }
} 