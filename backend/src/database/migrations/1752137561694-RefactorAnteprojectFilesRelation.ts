import { MigrationInterface, QueryRunner } from "typeorm";

export class RefactorAnteprojectFilesRelation1752137561694 implements MigrationInterface {
    name = 'RefactorAnteprojectFilesRelation1752137561694'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "anteprojects" DROP COLUMN "pdfFilePath"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" DROP COLUMN "createdAt"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" DROP COLUMN "updatedAt"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ADD "defenseDate" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ADD "defenseLocation" character varying(255)`);
        await queryRunner.query(`ALTER TABLE "files" ADD "anteprojectId" integer`);
        await queryRunner.query(`ALTER TYPE "public"."anteprojects_status_enum" RENAME TO "anteprojects_status_enum_old"`);
        await queryRunner.query(`CREATE TYPE "public"."anteprojects_status_enum" AS ENUM('draft', 'submitted', 'under_review', 'approved', 'rejected', 'defense_scheduled', 'completed')`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ALTER COLUMN "status" DROP DEFAULT`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ALTER COLUMN "status" TYPE "public"."anteprojects_status_enum" USING "status"::"text"::"public"."anteprojects_status_enum"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ALTER COLUMN "status" SET DEFAULT 'draft'`);
        await queryRunner.query(`DROP TYPE "public"."anteprojects_status_enum_old"`);
        await queryRunner.query(`ALTER TABLE "files" ADD CONSTRAINT "FK_0f4f4dd60a587302d753ede2b87" FOREIGN KEY ("anteprojectId") REFERENCES "anteprojects"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "files" DROP CONSTRAINT "FK_0f4f4dd60a587302d753ede2b87"`);
        await queryRunner.query(`CREATE TYPE "public"."anteprojects_status_enum_old" AS ENUM('draft', 'submitted', 'under_review', 'approved', 'rejected')`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ALTER COLUMN "status" DROP DEFAULT`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ALTER COLUMN "status" TYPE "public"."anteprojects_status_enum_old" USING "status"::"text"::"public"."anteprojects_status_enum_old"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ALTER COLUMN "status" SET DEFAULT 'draft'`);
        await queryRunner.query(`DROP TYPE "public"."anteprojects_status_enum"`);
        await queryRunner.query(`ALTER TYPE "public"."anteprojects_status_enum_old" RENAME TO "anteprojects_status_enum"`);
        await queryRunner.query(`ALTER TABLE "files" DROP COLUMN "anteprojectId"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" DROP COLUMN "defenseLocation"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" DROP COLUMN "defenseDate"`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ADD "updatedAt" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ADD "createdAt" TIMESTAMP NOT NULL DEFAULT now()`);
        await queryRunner.query(`ALTER TABLE "anteprojects" ADD "pdfFilePath" character varying(500)`);
    }

}
