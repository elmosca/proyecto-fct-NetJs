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
  HttpCode,
} from '@nestjs/common';
import { TasksService } from './tasks.service';
import {
  CreateTaskDto,
  UpdateTaskDto,
  MoveTaskDto,
  AssignUserDto,
} from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { RolesGuard } from '../roles/roles.guard';
import { Roles } from '../roles/roles.decorator';
import { RoleEnum } from '../roles/roles.enum';

@Controller('tasks')
@UseGuards(JwtAuthGuard, RolesGuard)
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Get('project/:projectId/kanban')
  getKanbanData(
    @Param('projectId', ParseIntPipe) projectId: number,
    @Request() req: { user: User },
  ) {
    return this.tasksService.getKanbanData(projectId, req.user);
  }

  @Get('project/:projectId')
  findAllByProject(
    @Param('projectId', ParseIntPipe) projectId: number,
    @Request() req: { user: User },
  ) {
    return this.tasksService.findAllByProject(projectId, req.user);
  }

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.tasksService.findOne(id, req.user);
  }

  @Post(':id/assignees')
  @Roles(RoleEnum.ADMIN, RoleEnum.TUTOR)
  assignUser(
    @Param('id', ParseIntPipe) taskId: number,
    @Body() assignUserDto: AssignUserDto,
    @Request() req: { user: User },
  ) {
    return this.tasksService.assignUser(taskId, assignUserDto.userId, req.user);
  }

  @Delete(':id/assignees/:userId')
  @Roles(RoleEnum.ADMIN, RoleEnum.TUTOR)
  removeAssignee(
    @Param('id', ParseIntPipe) taskId: number,
    @Param('userId', ParseIntPipe) userId: number,
    @Request() req: { user: User },
  ) {
    return this.tasksService.removeAssignee(taskId, userId, req.user);
  }

  @Patch(':id/move')
  @HttpCode(204)
  moveTask(
    @Param('id', ParseIntPipe) id: number,
    @Body() moveTaskDto: MoveTaskDto,
    @Request() req: { user: User },
  ) {
    return this.tasksService.moveTask(id, moveTaskDto, req.user);
  }

  @Post()
  create(@Body() createTaskDto: CreateTaskDto, @Request() req: { user: User }) {
    return this.tasksService.create(createTaskDto, req.user);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateTaskDto: UpdateTaskDto,
    @Request() req: { user: User },
  ) {
    return this.tasksService.update(id, updateTaskDto, req.user);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.tasksService.remove(id, req.user);
  }
}
