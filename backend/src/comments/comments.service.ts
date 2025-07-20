import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Comment } from './entities/comment.entity';
import { User } from '../users/entities/user.entity';
import { Task } from '../tasks/entities/task.entity';
import { TasksService } from '../tasks/tasks.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { RoleEnum } from '../roles/roles.enum';

@Injectable()
export class CommentsService {
  constructor(
    @InjectRepository(Comment) private commentsRepository: Repository<Comment>,
    private tasksService: TasksService,
  ) {}

  async findAllByTask(taskId: number, currentUser: User): Promise<Comment[]> {
    await this.tasksService.findOne(taskId, currentUser); // Check access to task
    return this.commentsRepository.find({
      where: { taskId },
      relations: ['author'],
    });
  }

  async findOne(id: number, currentUser: User): Promise<Comment> {
    const comment = await this.commentsRepository.findOne({ where: { id } });
    if (!comment) {
      throw new NotFoundException(`Comment with ID ${id} not found`);
    }
    await this.tasksService.findOne(comment.taskId, currentUser); // Check access
    return comment;
  }

  async create(
    createCommentDto: CreateCommentDto,
    currentUser: User,
  ): Promise<Comment> {
    const task = await this.tasksService.findOne(
      createCommentDto.taskId,
      currentUser,
    );
    const newComment = this.commentsRepository.create({
      ...createCommentDto,
      authorId: currentUser.id,
      taskId: task.id,
    });
    return this.commentsRepository.save(newComment);
  }

  async update(
    id: number,
    updateCommentDto: UpdateCommentDto,
    currentUser: User,
  ): Promise<Comment> {
    const comment = await this.findOne(id, currentUser); // Checks task access
    if (comment.authorId !== currentUser.id) {
      throw new ForbiddenException('You can only update your own comments.');
    }
    Object.assign(comment, updateCommentDto);
    return this.commentsRepository.save(comment);
  }

  async remove(id: number, currentUser: User): Promise<void> {
    const comment = await this.commentsRepository.findOne({
      where: { id },
      relations: ['task', 'task.project', 'task.project.tutor'],
    });
    if (!comment) {
      throw new NotFoundException(`Comment with ID ${id} not found`);
    }
    await this.tasksService.findOne(comment.taskId, currentUser); // Check access

    const isAuthor = comment.authorId === currentUser.id;
    const isTutor = comment.task.project.tutor.id === currentUser.id;
    const isAdmin = currentUser.role === RoleEnum.ADMIN;

    if (!isAuthor && !isTutor && !isAdmin) {
      throw new ForbiddenException(
        'You do not have permission to delete this comment.',
      );
    }

    await this.commentsRepository.softDelete(id);
  }
}
