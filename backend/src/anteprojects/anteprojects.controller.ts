import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ParseIntPipe,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AnteprojectsService } from './anteprojects.service';
import { CreateAnteprojectDto } from './dto/create-anteproject.dto';
import { UpdateAnteprojectDto } from './dto/update-anteproject.dto';
import { RejectAnteprojectDto } from './dto/reject-anteproject.dto';
import { ScheduleDefenseDto } from './dto/schedule-defense.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';

@Controller('anteprojects')
@UseGuards(JwtAuthGuard)
export class AnteprojectsController {
  constructor(private readonly anteprojectsService: AnteprojectsService) {}

  @Post()
  create(
    @Body() createAnteprojectDto: CreateAnteprojectDto,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.create(createAnteprojectDto, req.user);
  }

  @Get()
  findAll(@Request() req: { user: User }) {
    return this.anteprojectsService.findAll(req.user);
  }

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.findOne(id, req.user);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateAnteprojectDto: UpdateAnteprojectDto,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.update(id, updateAnteprojectDto, req.user);
  }

  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number, @Request() req: { user: User }) {
    return this.anteprojectsService.remove(id, req.user);
  }

  @Post(':id/submit')
  submit(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.submit(id, req.user);
  }

  @Post(':id/review')
  review(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.review(id, req.user);
  }

  @Post(':id/approve')
  approve(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.approve(id, req.user);
  }

  @Post(':id/reject')
  reject(
    @Param('id', ParseIntPipe) id: number,
    @Body() rejectAnteprojectDto: RejectAnteprojectDto,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.reject(id, rejectAnteprojectDto, req.user);
  }

  @Post(':id/schedule-defense')
  scheduleDefense(
    @Param('id', ParseIntPipe) id: number,
    @Body() scheduleDefenseDto: ScheduleDefenseDto,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.scheduleDefense(
      id,
      scheduleDefenseDto,
      req.user,
    );
  }

  @Post(':id/complete-defense')
  completeDefense(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.anteprojectsService.completeDefense(id, req.user);
  }
} 