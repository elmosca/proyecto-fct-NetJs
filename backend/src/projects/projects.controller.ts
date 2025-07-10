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
import { ProjectsService } from './projects.service';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { Roles } from '../roles/roles.decorator';
import { RoleEnum } from '../roles/roles.enum';
import { RolesGuard } from '../roles/roles.guard';
import { AddStudentDto } from './dto/add-student.dto';

@Controller('projects')
@UseGuards(JwtAuthGuard, RolesGuard)
export class ProjectsController {
  constructor(private readonly projectsService: ProjectsService) {}

  @Get()
  findAll(@Request() req: { user: User }) {
    return this.projectsService.findAll(req.user);
  }

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.projectsService.findOne(id, req.user);
  }

  @Post(':id/students')
  @Roles(RoleEnum.ADMIN, RoleEnum.TUTOR)
  addStudent(
    @Param('id', ParseIntPipe) projectId: number,
    @Body() addStudentDto: AddStudentDto,
    @Request() req: { user: User },
  ) {
    return this.projectsService.addStudent(
      projectId,
      addStudentDto.studentId,
      req.user,
    );
  }

  @Delete(':id/students/:studentId')
  @Roles(RoleEnum.ADMIN, RoleEnum.TUTOR)
  removeStudent(
    @Param('id', ParseIntPipe) projectId: number,
    @Param('studentId', ParseIntPipe) studentId: number,
    @Request() req: { user: User },
  ) {
    return this.projectsService.removeStudent(projectId, studentId, req.user);
  }

  @Post()
  create(
    @Body() createProjectDto: CreateProjectDto,
    @Request() req: { user: User },
  ) {
    return this.projectsService.create(createProjectDto, req.user);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateProjectDto: UpdateProjectDto,
    @Request() req: { user: User },
  ) {
    return this.projectsService.update(id, updateProjectDto, req.user);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.projectsService.remove(id, req.user);
  }
}
