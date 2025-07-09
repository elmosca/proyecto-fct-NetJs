import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Request,
  UseGuards,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../roles/roles.guard';
import { Roles } from '../roles/roles.decorator';
import { RoleEnum } from '../roles/roles.enum';
import { User } from '../users/entities/user.entity';
import { CreateEvaluationDto } from './dto/create-evaluation.dto';
import { EvaluationsService } from './evaluations.service';

@Controller('evaluations')
@UseGuards(JwtAuthGuard, RolesGuard)
export class EvaluationsController {
  constructor(private readonly evaluationsService: EvaluationsService) {}

  @Post()
  @Roles(RoleEnum.ADMIN, RoleEnum.TUTOR)
  createOrUpdate(
    @Body() createEvaluationDto: CreateEvaluationDto,
    @Request() req: { user: User },
  ) {
    return this.evaluationsService.createOrUpdate(
      createEvaluationDto,
      req.user,
    );
  }

  @Get('anteproject/:anteprojectId')
  @Roles(RoleEnum.ADMIN, RoleEnum.TUTOR)
  findAllByAnteproject(
    @Param('anteprojectId', ParseIntPipe) anteprojectId: number,
    @Request() req: { user: User },
  ) {
    return this.evaluationsService.findAllByAnteproject(anteprojectId, req.user);
  }
} 