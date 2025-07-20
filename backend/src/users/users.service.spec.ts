import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsersService } from './users.service';
import { User, UserStatus } from './entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import { ForbiddenException, NotFoundException } from '@nestjs/common';

// Mock user data
const mockAdminUser: User = {
  id: 1,
  fullName: 'Admin User',
  email: 'admin@example.com',
  passwordHash: 'hashedpassword',
  role: RoleEnum.ADMIN,
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};

const mockStudentUser: User = {
  id: 2,
  fullName: 'Student User',
  email: 'student@example.com',
  passwordHash: 'hashedpassword',
  role: RoleEnum.STUDENT,
  status: UserStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
};

describe('UsersService', () => {
  let service: UsersService;
  let userRepository: Repository<User>;

  const mockUserRepository = {
    findOne: jest.fn(),
    softDelete: jest.fn(),
    create: jest.fn().mockImplementation((dto) => dto),
    save: jest
      .fn()
      .mockImplementation((user) =>
        Promise.resolve({ id: Date.now(), ...user }),
      ),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('remove', () => {
    beforeEach(() => {
      jest.clearAllMocks();
    });

    it('should call softDelete on the repository for the given id by an admin', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockStudentUser);
      mockUserRepository.softDelete.mockResolvedValue({ affected: 1 });

      await service.remove(mockStudentUser.id, mockAdminUser);
      expect(userRepository.softDelete).toHaveBeenCalledWith(
        mockStudentUser.id,
      );
    });

    it('should throw NotFoundException if user to delete is not found', async () => {
      mockUserRepository.findOne.mockResolvedValue(null);
      await expect(service.remove(999, mockAdminUser)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if a non-admin tries to delete a user', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockAdminUser);
      await expect(
        service.remove(mockAdminUser.id, mockStudentUser),
      ).rejects.toThrow(
        new ForbiddenException('You do not have permission to delete users.'),
      );
    });

    it('should throw ForbiddenException if an admin tries to delete themselves', async () => {
      mockUserRepository.findOne.mockResolvedValue(mockAdminUser);
      await expect(
        service.remove(mockAdminUser.id, mockAdminUser),
      ).rejects.toThrow(
        new ForbiddenException('Admins cannot delete their own account.'),
      );
    });
  });

  describe('update', () => {
    beforeEach(() => {
      jest.clearAllMocks();
    });

    it('should allow a user to update their own profile', async () => {
      const updateDto = { fullName: 'New Name' };
      mockUserRepository.findOne.mockResolvedValue(mockStudentUser);
      mockUserRepository.save.mockResolvedValue({
        ...mockStudentUser,
        ...updateDto,
      });

      const result = await service.update(
        mockStudentUser.id,
        updateDto,
        mockStudentUser,
      );
      expect(userRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({ fullName: 'New Name' }),
      );
      expect(result.fullName).toEqual('New Name');
    });

    it('should prevent a user from updating their own role', async () => {
      const updateDto = { role: RoleEnum.ADMIN };
      mockUserRepository.findOne.mockResolvedValue(mockStudentUser);

      await expect(
        service.update(mockStudentUser.id, updateDto, mockStudentUser),
      ).rejects.toThrow(
        new ForbiddenException('You cannot change your own role.'),
      );
    });

    it('should allow an admin to update any user profile', async () => {
      const updateDto = { fullName: 'Updated by Admin' };
      mockUserRepository.findOne.mockResolvedValue(mockStudentUser);
      mockUserRepository.save.mockResolvedValue({
        ...mockStudentUser,
        ...updateDto,
      });

      await service.update(mockStudentUser.id, updateDto, mockAdminUser);
      expect(userRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({ fullName: 'Updated by Admin' }),
      );
    });

    it("should prevent a non-admin from updating another user's profile", async () => {
      const anotherStudent = { ...mockStudentUser, id: 3 };
      const updateDto = { fullName: 'Trying to update' };
      mockUserRepository.findOne.mockResolvedValue(anotherStudent);

      await expect(
        service.update(anotherStudent.id, updateDto, mockStudentUser),
      ).rejects.toThrow(
        new ForbiddenException(
          'You do not have permission to update this user.',
        ),
      );
    });

    it('should hash the password if it is provided in the update dto', async () => {
      const updateDto = { password: 'newPassword' };
      mockUserRepository.findOne.mockResolvedValue(mockStudentUser);

      await service.update(mockStudentUser.id, updateDto, mockAdminUser);
      expect(userRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({
          passwordHash: expect.any(String),
        }),
      );
      const savedUser = mockUserRepository.save.mock.calls[0][0];
      expect(savedUser.password).toBeUndefined(); // ensure original password is not saved
    });
  });
});
