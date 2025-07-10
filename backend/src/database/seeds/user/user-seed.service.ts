import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User, UserStatus } from 'src/users/entities/user.entity';
import { RoleEnum } from 'src/roles/roles.enum';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserSeedService {
  constructor(
    @InjectRepository(User)
    private readonly repository: Repository<User>,
  ) {}

  async run() {
    const adminUser = await this.repository.findOne({
      where: { role: RoleEnum.ADMIN },
    });

    if (!adminUser) {
      const salt = await bcrypt.genSalt();
      const hashedPassword = await bcrypt.hash('password', salt); // Default password

      const newUser = this.repository.create({
        fullName: 'Admin User',
        email: 'admin@example.com',
        passwordHash: hashedPassword,
        role: RoleEnum.ADMIN,
        status: UserStatus.ACTIVE,
      });

      await this.repository.save(newUser);
    }
  }
}
