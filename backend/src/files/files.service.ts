import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Anteproject } from 'src/anteprojects/entities/anteproject.entity';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { AttachableTypeEnum, File } from './entities/file.entity';

@Injectable()
export class FilesService {
    constructor(
        @InjectRepository(File)
        private readonly fileRepository: Repository<File>,
    ) { }

    async createFileRecord(
        file: Express.Multer.File,
        uploadedBy: User,
        attachable: { type: AttachableTypeEnum; id: number },
        anteproject?: Anteproject,
    ): Promise<File> {
        const newFile = this.fileRepository.create({
            filename: file.filename,
            originalFilename: file.originalname,
            filePath: file.path,
            fileSize: file.size,
            mimeType: file.mimetype,
            uploadedById: uploadedBy.id,
            attachableType: attachable.type,
            attachableId: attachable.id,
        });

        if (anteproject) {
            newFile.anteproject = anteproject;
        }

        return this.fileRepository.save(newFile);
    }
}
