import {
    ForbiddenException,
    Injectable,
    NotFoundException,
    UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { AttachableTypeEnum } from '../files/entities/file.entity';
import { FilesService } from '../files/files.service';
import { RoleEnum } from '../roles/roles.enum';
import { User } from '../users/entities/user.entity';
import { CreateAnteprojectDto } from './dto/create-anteproject.dto';
import { RejectAnteprojectDto } from './dto/reject-anteproject.dto';
import { ScheduleDefenseDto } from './dto/schedule-defense.dto';
import { UpdateAnteprojectDto } from './dto/update-anteproject.dto';
import {
    Anteproject,
    AnteprojectStatusEnum,
} from './entities/anteproject.entity';

@Injectable()
export class AnteprojectsService {
    constructor(
        @InjectRepository(Anteproject)
        private readonly anteprojectRepository: Repository<Anteproject>,
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
        private readonly filesService: FilesService,
    ) { }

    private checkUserRoles(anteproject: Anteproject, currentUser: User) {
        return {
            isUserAdmin: currentUser.role === RoleEnum.ADMIN,
            isUserTutor: anteproject.tutor.id === currentUser.id,
            isUserStudent: anteproject.students.some((s) => s.id === currentUser.id),
        };
    }

    async create(
        createAnteprojectDto: CreateAnteprojectDto,
        currentUser: User,
    ): Promise<Anteproject> {
        if (currentUser.role !== RoleEnum.STUDENT) {
            throw new ForbiddenException('Only students can create anteprojects.');
        }

        if (!createAnteprojectDto.studentIds.includes(currentUser.id)) {
            throw new ForbiddenException(
                'You must be one of the students in the anteproject.',
            );
        }

        const { tutorId, studentIds, ...rest } = createAnteprojectDto;

        const tutor = await this.userRepository.findOne({
            where: { id: tutorId, role: RoleEnum.TUTOR },
        });
        if (!tutor) {
            throw new NotFoundException(
                `Tutor with ID ${tutorId} not found or is not a tutor.`,
            );
        }

        const students = await this.userRepository.find({
            where: { id: In(studentIds), role: RoleEnum.STUDENT },
        });
        if (students.length !== studentIds.length) {
            throw new NotFoundException(
                'One or more students not found or are not students.',
            );
        }

        const anteprojectData = this.anteprojectRepository.create({
            ...rest,
            status: AnteprojectStatusEnum.DRAFT,
        });

        anteprojectData.tutor = tutor;
        anteprojectData.students = students;

        return this.anteprojectRepository.save(anteprojectData);
    }

    async findAll(currentUser: User): Promise<Anteproject[]> {
        const qb = this.anteprojectRepository
            .createQueryBuilder('anteproject')
            .leftJoinAndSelect('anteproject.tutor', 'tutor')
            .leftJoinAndSelect('anteproject.students', 'students');

        if (currentUser.role === RoleEnum.TUTOR) {
            qb.where('anteproject.tutorId = :tutorId', { tutorId: currentUser.id });
        } else if (currentUser.role === RoleEnum.STUDENT) {
            qb.innerJoin(
                'anteproject.students',
                'student_rel',
                'student_rel.id = :studentId',
                { studentId: currentUser.id },
            );
        }
        // Admin ve todo

        return qb.getMany();
    }

    async findOne(id: number, currentUser: User): Promise<Anteproject> {
        const anteproject = await this.anteprojectRepository.findOne({
            where: { id },
            relations: ['tutor', 'students', 'createdBy'],
        });

        if (!anteproject) {
            throw new NotFoundException(`Anteproject with ID ${id} not found`);
        }

        const { isUserAdmin, isUserTutor, isUserStudent } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (!isUserAdmin && !isUserTutor && !isUserStudent) {
            throw new ForbiddenException(
                'You do not have permission to view this anteproject.',
            );
        }

        return anteproject;
    }

    async update(
        id: number,
        updateAnteprojectDto: UpdateAnteprojectDto,
        currentUser: User,
    ): Promise<Anteproject> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserAdmin, isUserTutor } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (anteproject.status !== AnteprojectStatusEnum.DRAFT && !isUserAdmin) {
            throw new ForbiddenException(
                'This anteproject cannot be updated because it is not in draft status.',
            );
        }

        const { tutorId, studentIds, ...rest } = updateAnteprojectDto;

        if (tutorId && tutorId !== anteproject.tutorId) {
            if (!isUserAdmin && !isUserTutor)
                throw new ForbiddenException(
                    'Only admins and the project tutor can change the tutor.',
                );
            const newTutor = await this.userRepository.findOne({
                where: { id: tutorId, role: RoleEnum.TUTOR },
            });
            if (!newTutor)
                throw new NotFoundException(
                    `Tutor with ID ${tutorId} not found or is not a tutor.`,
                );
            anteproject.tutor = newTutor;
        }

        if (studentIds) {
            if (!isUserAdmin && !isUserTutor)
                throw new ForbiddenException(
                    'Only admins and the project tutor can change students.',
                );
            const newStudents = await this.userRepository.find({
                where: { id: In(studentIds), role: RoleEnum.STUDENT },
            });
            if (newStudents.length !== studentIds.length)
                throw new NotFoundException(
                    'One or more students not found or are not students.',
                );
            anteproject.students = newStudents;
        }

        Object.assign(anteproject, rest);

        return this.anteprojectRepository.save(anteproject);
    }

    async remove(id: number, currentUser: User): Promise<void> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserAdmin } = this.checkUserRoles(anteproject, currentUser);

        if (anteproject.status !== AnteprojectStatusEnum.DRAFT && !isUserAdmin) {
            throw new ForbiddenException(
                'This anteproject cannot be deleted because it is not in draft status.',
            );
        }
        await this.anteprojectRepository.softDelete(id);
    }

    async submit(id: number, currentUser: User): Promise<Anteproject> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserStudent } = this.checkUserRoles(anteproject, currentUser);

        if (!isUserStudent) {
            throw new ForbiddenException(
                'Only students of this anteproject can submit it.',
            );
        }

        if (anteproject.status !== AnteprojectStatusEnum.DRAFT) {
            throw new ForbiddenException(
                'Only anteprojects in draft status can be submitted.',
            );
        }

        anteproject.status = AnteprojectStatusEnum.SUBMITTED;
        anteproject.submittedAt = new Date();

        return this.anteprojectRepository.save(anteproject);
    }

    async review(id: number, currentUser: User): Promise<Anteproject> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserTutor, isUserAdmin } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (!isUserTutor && !isUserAdmin) {
            throw new ForbiddenException(
                'Only the assigned tutor or an admin can review this anteproject.',
            );
        }
        if (anteproject.status !== AnteprojectStatusEnum.SUBMITTED) {
            throw new ForbiddenException(
                'Only submitted anteprojects can be put under review.',
            );
        }
        anteproject.status = AnteprojectStatusEnum.UNDER_REVIEW;
        return this.anteprojectRepository.save(anteproject);
    }

    async approve(id: number, currentUser: User): Promise<Anteproject> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserTutor, isUserAdmin } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (!isUserTutor && !isUserAdmin) {
            throw new ForbiddenException(
                'Only the assigned tutor or an admin can approve this anteproject.',
            );
        }
        if (anteproject.status !== AnteprojectStatusEnum.UNDER_REVIEW) {
            throw new ForbiddenException(
                'Only anteprojects under review can be approved.',
            );
        }
        anteproject.status = AnteprojectStatusEnum.APPROVED;
        anteproject.reviewedAt = new Date();
        anteproject.evaluationDate = new Date();
        return this.anteprojectRepository.save(anteproject);
    }

    async reject(
        id: number,
        rejectDto: RejectAnteprojectDto,
        currentUser: User,
    ): Promise<Anteproject> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserTutor, isUserAdmin } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (!isUserTutor && !isUserAdmin) {
            throw new ForbiddenException(
                'Only the assigned tutor or an admin can reject this anteproject.',
            );
        }
        if (anteproject.status !== AnteprojectStatusEnum.UNDER_REVIEW) {
            throw new ForbiddenException(
                'Only anteprojects under review can be rejected.',
            );
        }
        anteproject.status = AnteprojectStatusEnum.REJECTED;
        anteproject.tutorComments = rejectDto.tutorComments;
        anteproject.reviewedAt = new Date();
        anteproject.evaluationDate = new Date();
        return this.anteprojectRepository.save(anteproject);
    }

    async scheduleDefense(
        id: number,
        scheduleDefenseDto: ScheduleDefenseDto,
        currentUser: User,
    ): Promise<Anteproject> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserTutor, isUserAdmin } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (!isUserTutor && !isUserAdmin) {
            throw new ForbiddenException(
                'Only the assigned tutor or an admin can schedule the defense.',
            );
        }
        if (anteproject.status !== AnteprojectStatusEnum.APPROVED) {
            throw new ForbiddenException(
                'Only approved anteprojects can have their defense scheduled.',
            );
        }
        anteproject.status = AnteprojectStatusEnum.DEFENSE_SCHEDULED;
        anteproject.defenseDate = scheduleDefenseDto.defenseDate;
        anteproject.defenseLocation = scheduleDefenseDto.defenseLocation;

        return this.anteprojectRepository.save(anteproject);
    }

    async uploadAnteprojectFile(
        anteprojectId: number,
        file: Express.Multer.File,
        currentUser: User,
    ): Promise<Anteproject> {
        const anteproject = await this.findOne(anteprojectId, currentUser);

        const { isUserAdmin, isUserTutor, isUserStudent } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (!isUserAdmin && !isUserTutor && !isUserStudent) {
            throw new UnauthorizedException(
                'You do not have permission to upload files to this anteproject.',
            );
        }

        if (!file) {
            throw new NotFoundException('File not found in request.');
        }

        await this.filesService.createFileRecord(
            file,
            currentUser,
            {
                type: AttachableTypeEnum.ANTEPROJECT,
                id: anteprojectId,
            },
            anteproject,
        );

        return anteproject;
    }

    async completeDefense(id: number, currentUser: User): Promise<Anteproject> {
        const anteproject = await this.findOne(id, currentUser);
        const { isUserTutor, isUserAdmin } = this.checkUserRoles(
            anteproject,
            currentUser,
        );

        if (!isUserTutor && !isUserAdmin) {
            throw new ForbiddenException(
                'Only the assigned tutor or an admin can mark the defense as completed.',
            );
        }
        if (anteproject.status !== AnteprojectStatusEnum.DEFENSE_SCHEDULED) {
            throw new ForbiddenException(
                'Only anteprojects with a scheduled defense can be marked as completed.',
            );
        }
        anteproject.status = AnteprojectStatusEnum.COMPLETED;
        return this.anteprojectRepository.save(anteproject);
    }
}
