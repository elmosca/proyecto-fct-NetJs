import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CommentsService } from './comments.service';
import { Comment } from './entities/comment.entity';
import { TasksService } from '../tasks/tasks.service';
import { User, UserStatus } from '../users/entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import { Task } from '../tasks/entities/task.entity';
import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';

// Mocks
const mockAdminUser: User = {
  id: 99,
  role: RoleEnum.ADMIN,
  email: 'admin@test.com',
  fullName: 'Admin',
  passwordHash: '',
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};
const mockTutorUser: User = {
  id: 2,
  role: RoleEnum.TUTOR,
  email: 'tutor@test.com',
  fullName: 'Tutor',
  passwordHash: '',
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};
const mockAuthorUser: User = {
  id: 1,
  role: RoleEnum.STUDENT,
  email: 'test@test.com',
  fullName: 'Test',
  passwordHash: '',
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};

const mockProject = { id: 1, tutor: mockTutorUser };
const mockTask = { id: 1, projectId: 1, project: mockProject } as Task;
const mockComment: Comment = {
  id: 1,
  content: 'Test comment',
  taskId: 1,
  authorId: 1,
  author: mockAuthorUser,
  task: mockTask,
  isInternal: false,
  createdAt: new Date(),
  updatedAt: new Date(),
};

describe('CommentsService', () => {
  let service: CommentsService;
  let commentRepository: Repository<Comment>;
  let tasksService: TasksService;

  const mockCommentRepository = {
    save: jest.fn(),
    create: jest.fn(),
    findOne: jest.fn(),
    find: jest.fn(),
    softDelete: jest.fn(),
  };
  const mockTasksService = { findOne: jest.fn() };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CommentsService,
        {
          provide: getRepositoryToken(Comment),
          useValue: mockCommentRepository,
        },
        { provide: TasksService, useValue: mockTasksService },
      ],
    }).compile();

    service = module.get<CommentsService>(CommentsService);
    commentRepository = module.get<Repository<Comment>>(
      getRepositoryToken(Comment),
    );
    tasksService = module.get<TasksService>(TasksService);

    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    const createDto: CreateCommentDto = { content: 'New comment', taskId: 1 };

    it('should create a comment if user has access to the task', async () => {
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.create.mockReturnValue(mockComment);
      mockCommentRepository.save.mockResolvedValue(mockComment);

      await service.create(createDto, mockAuthorUser);
      expect(tasksService.findOne).toHaveBeenCalledWith(
        createDto.taskId,
        mockAuthorUser,
      );
      expect(commentRepository.save).toHaveBeenCalled();
    });

    it('should throw error if user cannot access task', async () => {
      mockTasksService.findOne.mockRejectedValue(new ForbiddenException());
      await expect(service.create(createDto, mockAuthorUser)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('update', () => {
    const updateDto: UpdateCommentDto = { content: 'Updated content' };

    it('should allow author to update a comment', async () => {
      mockTasksService.findOne.mockResolvedValue(mockTask); // for the findOne call inside service.update
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      mockCommentRepository.save.mockResolvedValue({
        ...mockComment,
        ...updateDto,
      });

      await service.update(mockComment.id, updateDto, mockAuthorUser);
      expect(commentRepository.save).toHaveBeenCalledWith(
        expect.objectContaining(updateDto),
      );
    });

    it('should prevent non-author from updating a comment', async () => {
      const otherUser = { ...mockAuthorUser, id: 2 };
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.findOne.mockResolvedValue(mockComment);

      await expect(
        service.update(mockComment.id, updateDto, otherUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('findAllByTask', () => {
    it('should return comments for a task if user has access', async () => {
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.find.mockResolvedValue([mockComment]);
      const result = await service.findAllByTask(mockTask.id, mockAuthorUser);
      expect(result).toEqual([mockComment]);
      expect(commentRepository.find).toHaveBeenCalledWith({
        where: { taskId: mockTask.id },
        relations: ['author'],
      });
    });

    it('should throw error if user cannot access task', async () => {
      mockTasksService.findOne.mockRejectedValue(new ForbiddenException());
      await expect(
        service.findAllByTask(mockTask.id, mockAuthorUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('findOne', () => {
    it('should return a comment if user has access to the task', async () => {
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      const result = await service.findOne(mockComment.id, mockAuthorUser);
      expect(result).toEqual(mockComment);
    });

    it('should throw error if user cannot access task', async () => {
      mockTasksService.findOne.mockRejectedValue(new ForbiddenException());
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      await expect(
        service.findOne(mockComment.id, mockAuthorUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('should allow author to delete a comment', async () => {
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      await service.remove(mockComment.id, mockAuthorUser);
      expect(commentRepository.softDelete).toHaveBeenCalledWith(mockComment.id);
    });

    it('should allow project tutor to delete a comment', async () => {
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      await service.remove(mockComment.id, mockTutorUser);
      expect(commentRepository.softDelete).toHaveBeenCalledWith(mockComment.id);
    });

    it('should allow admin to delete a comment', async () => {
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      await service.remove(mockComment.id, mockAdminUser);
      expect(commentRepository.softDelete).toHaveBeenCalledWith(mockComment.id);
    });

    it('should prevent another user from deleting a comment', async () => {
      const anotherUser = { ...mockAuthorUser, id: 123 };
      mockTasksService.findOne.mockResolvedValue(mockTask);
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      await expect(service.remove(mockComment.id, anotherUser)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });
});
