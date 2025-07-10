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
import { CommentsService } from './comments.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';

@Controller('comments')
@UseGuards(JwtAuthGuard)
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  @Get('task/:taskId')
  findAllByTask(
    @Param('taskId', ParseIntPipe) taskId: number,
    @Request() req: { user: User },
  ) {
    return this.commentsService.findAllByTask(taskId, req.user);
  }

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.commentsService.findOne(id, req.user);
  }

  @Post()
  create(
    @Body() createCommentDto: CreateCommentDto,
    @Request() req: { user: User },
  ) {
    return this.commentsService.create(createCommentDto, req.user);
  }

  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateCommentDto: UpdateCommentDto,
    @Request() req: { user: User },
  ) {
    return this.commentsService.update(id, updateCommentDto, req.user);
  }

  @Delete(':id')
  remove(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: { user: User },
  ) {
    return this.commentsService.remove(id, req.user);
  }
}
