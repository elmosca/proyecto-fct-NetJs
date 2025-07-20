import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { RoleEnum } from '../roles/roles.enum';
import * as bcrypt from 'bcrypt';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  async create(
    createUserDto: CreateUserDto,
    currentUser?: User,
  ): Promise<User> {
    if (currentUser && currentUser.role !== RoleEnum.ADMIN) {
      if (
        createUserDto.role &&
        (createUserDto.role === RoleEnum.TUTOR ||
          createUserDto.role === RoleEnum.ADMIN)
      ) {
        throw new ForbiddenException(
          'You do not have permission to create users with this role.',
        );
      }
    }

    const { password, ...userData } = createUserDto;
    const passwordHash = await bcrypt.hash(password, 10);

    const newUser = this.usersRepository.create({
      ...userData,
      passwordHash,
    });

    return this.usersRepository.save(newUser);
  }

  async findAll(): Promise<User[]> {
    return this.usersRepository.find();
  }

  async findOne(id: number): Promise<User> {
    const user = await this.usersRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }
    return user;
  }

  async findById(id: number): Promise<User | null> {
    return this.usersRepository.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }

  async findByRole(role: RoleEnum): Promise<User[]> {
    return this.usersRepository.find({ where: { role } });
  }

  async update(
    id: number,
    updateUserDto: UpdateUserDto,
    currentUser: User,
  ): Promise<User> {
    const userToUpdate = await this.findOne(id); // Reuses findOne to ensure user exists

    const isUpdatingOwnProfile = currentUser.id === userToUpdate.id;
    const isAdmin = currentUser.role === RoleEnum.ADMIN;

    // A user can update their own profile, or an admin can update any profile.
    if (!isUpdatingOwnProfile && !isAdmin) {
      throw new ForbiddenException(
        'You do not have permission to update this user.',
      );
    }

    // If a user is updating their own profile, they cannot change their role.
    if (isUpdatingOwnProfile && !isAdmin && updateUserDto.role) {
      throw new ForbiddenException('You cannot change your own role.');
    }

    // If the updater is not an admin, they cannot promote a user to tutor or admin.
    if (
      !isAdmin &&
      updateUserDto.role &&
      (updateUserDto.role === RoleEnum.TUTOR ||
        updateUserDto.role === RoleEnum.ADMIN)
    ) {
      throw new ForbiddenException(
        'You do not have permission to set this role.',
      );
    }

    if (updateUserDto.password) {
      updateUserDto.passwordHash = await bcrypt.hash(
        updateUserDto.password,
        10,
      );
      delete updateUserDto.password;
    }

    Object.assign(userToUpdate, updateUserDto);

    return this.usersRepository.save(userToUpdate);
  }

  async remove(id: number, currentUser: User): Promise<void> {
    const userToDelete = await this.findOne(id); // Reuses findOne to ensure user exists

    const isAdmin = currentUser.role === RoleEnum.ADMIN;

    // An admin cannot delete themselves
    if (isAdmin && currentUser.id === userToDelete.id) {
      throw new ForbiddenException('Admins cannot delete their own account.');
    }

    // Only admins can delete users
    if (!isAdmin) {
      throw new ForbiddenException(
        'You do not have permission to delete users.',
      );
    }

    const result = await this.usersRepository.softDelete(userToDelete.id);

    if (result.affected === 0) {
      throw new NotFoundException(`User with ID ${userToDelete.id} not found`);
    }
  }
}
