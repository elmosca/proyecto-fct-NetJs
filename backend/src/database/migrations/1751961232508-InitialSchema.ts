import { MigrationInterface, QueryRunner } from 'typeorm';

export class InitialSchema1751961232508 implements MigrationInterface {
  name = 'InitialSchema1751961232508';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `CREATE TYPE "public"."users_role_enum" AS ENUM('student', 'tutor', 'admin')`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."users_status_enum" AS ENUM('active', 'inactive')`,
    );
    await queryRunner.query(
      `CREATE TABLE "users" ("id" SERIAL NOT NULL, "fullName" character varying(255) NOT NULL, "email" character varying(255) NOT NULL, "passwordHash" character varying(255) NOT NULL, "nre" character varying(20), "role" "public"."users_role_enum" NOT NULL DEFAULT 'student', "phone" character varying(20), "biography" text, "status" "public"."users_status_enum" NOT NULL DEFAULT 'active', "emailVerifiedAt" TIMESTAMP, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE ("email"), CONSTRAINT "UQ_44539f412518f781c0b75cce416" UNIQUE ("nre"), CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."projects_status_enum" AS ENUM('anteproject', 'planning', 'in_development', 'under_review', 'completed')`,
    );
    await queryRunner.query(
      `CREATE TABLE "projects" ("id" SERIAL NOT NULL, "title" character varying(500) NOT NULL, "description" text NOT NULL, "status" "public"."projects_status_enum" NOT NULL DEFAULT 'anteproject', "startDate" date, "estimatedEndDate" date, "actualEndDate" date, "githubRepositoryUrl" character varying(500), "githubMainBranch" character varying(100) NOT NULL DEFAULT 'main', "lastActivityAt" TIMESTAMP NOT NULL DEFAULT now(), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "tutorId" integer NOT NULL, CONSTRAINT "PK_6271df0a7aed1d6c0691ce6ac50" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."milestones_status_enum" AS ENUM('pending', 'in_progress', 'completed', 'delayed')`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."milestones_milestonetype_enum" AS ENUM('planning', 'execution', 'review', 'final')`,
    );
    await queryRunner.query(
      `CREATE TABLE "milestones" ("id" SERIAL NOT NULL, "projectId" integer NOT NULL, "milestoneNumber" integer NOT NULL, "title" character varying(500) NOT NULL, "description" text NOT NULL, "plannedDate" date NOT NULL, "completedDate" date, "status" "public"."milestones_status_enum" NOT NULL DEFAULT 'pending', "milestoneType" "public"."milestones_milestonetype_enum" NOT NULL DEFAULT 'execution', "isFromAnteproject" boolean NOT NULL DEFAULT false, "expectedDeliverables" json, "reviewComments" text, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, CONSTRAINT "UQ_49cbd1487e49bd51c798a8d716e" UNIQUE ("projectId", "milestoneNumber"), CONSTRAINT "PK_0bdbfe399c777a6a8520ff902d9" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."tasks_status_enum" AS ENUM('pending', 'in_progress', 'under_review', 'completed')`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."tasks_priority_enum" AS ENUM('low', 'medium', 'high')`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."tasks_complexity_enum" AS ENUM('simple', 'medium', 'complex')`,
    );
    await queryRunner.query(
      `CREATE TABLE "tasks" ("id" SERIAL NOT NULL, "projectId" integer NOT NULL, "milestoneId" integer, "createdById" integer NOT NULL, "title" character varying(500) NOT NULL, "description" text NOT NULL, "status" "public"."tasks_status_enum" NOT NULL DEFAULT 'pending', "priority" "public"."tasks_priority_enum" NOT NULL DEFAULT 'medium', "dueDate" date, "completedAt" TIMESTAMP, "kanbanPosition" integer NOT NULL DEFAULT '0', "estimatedHours" integer, "actualHours" integer, "complexity" "public"."tasks_complexity_enum" NOT NULL DEFAULT 'medium', "tags" json, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, CONSTRAINT "PK_8d12ff38fcc62aaba2cab748772" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."system_settings_settingtype_enum" AS ENUM('string', 'integer', 'boolean', 'json')`,
    );
    await queryRunner.query(
      `CREATE TABLE "system_settings" ("id" SERIAL NOT NULL, "settingKey" character varying(100) NOT NULL, "settingValue" text NOT NULL, "settingType" "public"."system_settings_settingtype_enum" NOT NULL DEFAULT 'string', "description" text, "isEditable" boolean NOT NULL DEFAULT true, "updatedById" integer, "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "UQ_62505774632b6cf75db1c720982" UNIQUE ("settingKey"), CONSTRAINT "PK_82521f08790d248b2a80cc85d40" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TABLE "notifications" ("id" SERIAL NOT NULL, "userId" integer NOT NULL, "type" character varying(50) NOT NULL, "title" character varying(255) NOT NULL, "message" text NOT NULL, "actionUrl" character varying(500), "metadata" json, "readAt" TIMESTAMP, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_6a72c3c0f683f6462415e653c3a" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_eb224d6d3acf40220d84a63720" ON "notifications" ("userId", "readAt") `,
    );
    await queryRunner.query(
      `CREATE TABLE "anteproject_evaluation_criteria" ("id" SERIAL NOT NULL, "name" character varying(255) NOT NULL, "description" text, "maxScore" numeric(3,1) NOT NULL DEFAULT '10', "isActive" boolean NOT NULL DEFAULT true, "displayOrder" integer NOT NULL DEFAULT '0', "createdAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_2e4c314fa6707185b76e512f9b5" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."files_attachabletype_enum" AS ENUM('task', 'comment', 'anteproject')`,
    );
    await queryRunner.query(
      `CREATE TABLE "files" ("id" SERIAL NOT NULL, "filename" character varying(255) NOT NULL, "originalFilename" character varying(255) NOT NULL, "filePath" character varying(500) NOT NULL, "fileSize" bigint NOT NULL, "mimeType" character varying(100) NOT NULL, "uploadedById" integer NOT NULL, "attachableType" "public"."files_attachabletype_enum" NOT NULL, "attachableId" integer NOT NULL, "uploadedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_6c16b9093a142e0e7613b04a3d9" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_69c2b98d062f9a8ffefd0d72f3" ON "files" ("attachableType", "attachableId") `,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."anteprojects_projecttype_enum" AS ENUM('execution', 'research', 'bibliographic', 'management')`,
    );
    await queryRunner.query(
      `CREATE TYPE "public"."anteprojects_status_enum" AS ENUM('draft', 'submitted', 'under_review', 'approved', 'rejected')`,
    );
    await queryRunner.query(
      `CREATE TABLE "anteprojects" ("id" SERIAL NOT NULL, "title" character varying(500) NOT NULL, "projectType" "public"."anteprojects_projecttype_enum" NOT NULL, "description" text NOT NULL, "academicYear" character varying(20) NOT NULL, "institution" character varying(255) NOT NULL DEFAULT 'CIFP Carlos III de Cartagena', "modality" character varying(100) NOT NULL DEFAULT 'modalidad distancia', "location" character varying(100) NOT NULL DEFAULT 'Cartagena', "expectedResults" json NOT NULL, "timeline" json NOT NULL, "status" "public"."anteprojects_status_enum" NOT NULL DEFAULT 'draft', "submittedAt" TIMESTAMP, "submissionDate" date, "reviewedAt" TIMESTAMP, "evaluationDate" date, "tutorComments" text, "pdfFilePath" character varying(500), "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, "tutorId" integer NOT NULL, CONSTRAINT "PK_25251e2d39174e7c2bed535ad7d" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TABLE "anteproject_evaluations" ("id" SERIAL NOT NULL, "anteprojectId" integer NOT NULL, "criteriaId" integer NOT NULL, "evaluatedById" integer NOT NULL, "score" numeric(3,1), "comments" text, "evaluatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "UQ_98bd94ceaf0fdfa8bccba775f05" UNIQUE ("anteprojectId", "criteriaId"), CONSTRAINT "PK_007a569d1b30d97063c9472754c" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TABLE "comments" ("id" SERIAL NOT NULL, "taskId" integer NOT NULL, "authorId" integer NOT NULL, "content" text NOT NULL, "isInternal" boolean NOT NULL DEFAULT false, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), "deletedAt" TIMESTAMP, CONSTRAINT "PK_8bf68bc960f2b69e818bdb90dcb" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE TABLE "activity_log" ("id" SERIAL NOT NULL, "userId" integer NOT NULL, "action" character varying(100) NOT NULL, "entityType" character varying(50) NOT NULL, "entityId" integer NOT NULL, "oldValues" json, "newValues" json, "ipAddress" character varying(45), "userAgent" text, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_067d761e2956b77b14e534fd6f1" PRIMARY KEY ("id"))`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_d556d97a2bef84be58cb7f3123" ON "activity_log" ("userId", "createdAt") `,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_c43e606cb37733ca06222d2064" ON "activity_log" ("entityType", "entityId") `,
    );
    await queryRunner.query(
      `CREATE TABLE "project_students" ("projectId" integer NOT NULL, "studentId" integer NOT NULL, CONSTRAINT "PK_77fcc653a0d288ab240a3a91329" PRIMARY KEY ("projectId", "studentId"))`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_fca0a44f0dde67e65220bdce62" ON "project_students" ("projectId") `,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_d76403fd9ba49368d6775d3437" ON "project_students" ("studentId") `,
    );
    await queryRunner.query(
      `CREATE TABLE "task_assignees" ("taskId" integer NOT NULL, "userId" integer NOT NULL, CONSTRAINT "PK_296ec87b94a488aea22063f7f3e" PRIMARY KEY ("taskId", "userId"))`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_8b1600551063c485554bca74c1" ON "task_assignees" ("taskId") `,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_e1f7dbf3fd1b02451882ea7c7b" ON "task_assignees" ("userId") `,
    );
    await queryRunner.query(
      `CREATE TABLE "anteproject_students" ("anteprojectId" integer NOT NULL, "studentId" integer NOT NULL, CONSTRAINT "PK_54df9170979362101a2c1f4b445" PRIMARY KEY ("anteprojectId", "studentId"))`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_e0eea405d426c567e94e98fc0a" ON "anteproject_students" ("anteprojectId") `,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_8c7f50ad217c76766a926aef97" ON "anteproject_students" ("studentId") `,
    );
    await queryRunner.query(
      `ALTER TABLE "projects" ADD CONSTRAINT "FK_c2ae3496f35fbea6eec253c9aa8" FOREIGN KEY ("tutorId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "milestones" ADD CONSTRAINT "FK_662a1f9d865fe49768fa369fd0f" FOREIGN KEY ("projectId") REFERENCES "projects"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "tasks" ADD CONSTRAINT "FK_e08fca67ca8966e6b9914bf2956" FOREIGN KEY ("projectId") REFERENCES "projects"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "tasks" ADD CONSTRAINT "FK_6dc5020fc4c6814347816455e7a" FOREIGN KEY ("milestoneId") REFERENCES "milestones"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "tasks" ADD CONSTRAINT "FK_660898d912c6e71107e9ef8f38d" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "system_settings" ADD CONSTRAINT "FK_8ac9d8bf3da43eaf36466c59c12" FOREIGN KEY ("updatedById") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "notifications" ADD CONSTRAINT "FK_692a909ee0fa9383e7859f9b406" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "files" ADD CONSTRAINT "FK_a525d85f0ac59aa9a971825e1af" FOREIGN KEY ("uploadedById") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteprojects" ADD CONSTRAINT "FK_2d3e0b449bd2d4e70d436d988a7" FOREIGN KEY ("tutorId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_evaluations" ADD CONSTRAINT "FK_59db5961da7b36f372fdf281c72" FOREIGN KEY ("anteprojectId") REFERENCES "anteprojects"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_evaluations" ADD CONSTRAINT "FK_9a2d170764500a7f08ee232cfc2" FOREIGN KEY ("criteriaId") REFERENCES "anteproject_evaluation_criteria"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_evaluations" ADD CONSTRAINT "FK_3cefac0d7d8b63890093b3201fb" FOREIGN KEY ("evaluatedById") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "comments" ADD CONSTRAINT "FK_9adf2d3106c6dc87d6262ccadfe" FOREIGN KEY ("taskId") REFERENCES "tasks"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "comments" ADD CONSTRAINT "FK_4548cc4a409b8651ec75f70e280" FOREIGN KEY ("authorId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "activity_log" ADD CONSTRAINT "FK_d19abacc8a508c0429478ad166b" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`,
    );
    await queryRunner.query(
      `ALTER TABLE "project_students" ADD CONSTRAINT "FK_fca0a44f0dde67e65220bdce620" FOREIGN KEY ("projectId") REFERENCES "projects"("id") ON DELETE CASCADE ON UPDATE CASCADE`,
    );
    await queryRunner.query(
      `ALTER TABLE "project_students" ADD CONSTRAINT "FK_d76403fd9ba49368d6775d3437d" FOREIGN KEY ("studentId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignees" ADD CONSTRAINT "FK_8b1600551063c485554bca74c13" FOREIGN KEY ("taskId") REFERENCES "tasks"("id") ON DELETE CASCADE ON UPDATE CASCADE`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignees" ADD CONSTRAINT "FK_e1f7dbf3fd1b02451882ea7c7b4" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_students" ADD CONSTRAINT "FK_e0eea405d426c567e94e98fc0a2" FOREIGN KEY ("anteprojectId") REFERENCES "anteprojects"("id") ON DELETE CASCADE ON UPDATE CASCADE`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_students" ADD CONSTRAINT "FK_8c7f50ad217c76766a926aef97e" FOREIGN KEY ("studentId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "anteproject_students" DROP CONSTRAINT "FK_8c7f50ad217c76766a926aef97e"`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_students" DROP CONSTRAINT "FK_e0eea405d426c567e94e98fc0a2"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignees" DROP CONSTRAINT "FK_e1f7dbf3fd1b02451882ea7c7b4"`,
    );
    await queryRunner.query(
      `ALTER TABLE "task_assignees" DROP CONSTRAINT "FK_8b1600551063c485554bca74c13"`,
    );
    await queryRunner.query(
      `ALTER TABLE "project_students" DROP CONSTRAINT "FK_d76403fd9ba49368d6775d3437d"`,
    );
    await queryRunner.query(
      `ALTER TABLE "project_students" DROP CONSTRAINT "FK_fca0a44f0dde67e65220bdce620"`,
    );
    await queryRunner.query(
      `ALTER TABLE "activity_log" DROP CONSTRAINT "FK_d19abacc8a508c0429478ad166b"`,
    );
    await queryRunner.query(
      `ALTER TABLE "comments" DROP CONSTRAINT "FK_4548cc4a409b8651ec75f70e280"`,
    );
    await queryRunner.query(
      `ALTER TABLE "comments" DROP CONSTRAINT "FK_9adf2d3106c6dc87d6262ccadfe"`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_evaluations" DROP CONSTRAINT "FK_3cefac0d7d8b63890093b3201fb"`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_evaluations" DROP CONSTRAINT "FK_9a2d170764500a7f08ee232cfc2"`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteproject_evaluations" DROP CONSTRAINT "FK_59db5961da7b36f372fdf281c72"`,
    );
    await queryRunner.query(
      `ALTER TABLE "anteprojects" DROP CONSTRAINT "FK_2d3e0b449bd2d4e70d436d988a7"`,
    );
    await queryRunner.query(
      `ALTER TABLE "files" DROP CONSTRAINT "FK_a525d85f0ac59aa9a971825e1af"`,
    );
    await queryRunner.query(
      `ALTER TABLE "notifications" DROP CONSTRAINT "FK_692a909ee0fa9383e7859f9b406"`,
    );
    await queryRunner.query(
      `ALTER TABLE "system_settings" DROP CONSTRAINT "FK_8ac9d8bf3da43eaf36466c59c12"`,
    );
    await queryRunner.query(
      `ALTER TABLE "tasks" DROP CONSTRAINT "FK_660898d912c6e71107e9ef8f38d"`,
    );
    await queryRunner.query(
      `ALTER TABLE "tasks" DROP CONSTRAINT "FK_6dc5020fc4c6814347816455e7a"`,
    );
    await queryRunner.query(
      `ALTER TABLE "tasks" DROP CONSTRAINT "FK_e08fca67ca8966e6b9914bf2956"`,
    );
    await queryRunner.query(
      `ALTER TABLE "milestones" DROP CONSTRAINT "FK_662a1f9d865fe49768fa369fd0f"`,
    );
    await queryRunner.query(
      `ALTER TABLE "projects" DROP CONSTRAINT "FK_c2ae3496f35fbea6eec253c9aa8"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_8c7f50ad217c76766a926aef97"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_e0eea405d426c567e94e98fc0a"`,
    );
    await queryRunner.query(`DROP TABLE "anteproject_students"`);
    await queryRunner.query(
      `DROP INDEX "public"."IDX_e1f7dbf3fd1b02451882ea7c7b"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_8b1600551063c485554bca74c1"`,
    );
    await queryRunner.query(`DROP TABLE "task_assignees"`);
    await queryRunner.query(
      `DROP INDEX "public"."IDX_d76403fd9ba49368d6775d3437"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_fca0a44f0dde67e65220bdce62"`,
    );
    await queryRunner.query(`DROP TABLE "project_students"`);
    await queryRunner.query(
      `DROP INDEX "public"."IDX_c43e606cb37733ca06222d2064"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_d556d97a2bef84be58cb7f3123"`,
    );
    await queryRunner.query(`DROP TABLE "activity_log"`);
    await queryRunner.query(`DROP TABLE "comments"`);
    await queryRunner.query(`DROP TABLE "anteproject_evaluations"`);
    await queryRunner.query(`DROP TABLE "anteprojects"`);
    await queryRunner.query(`DROP TYPE "public"."anteprojects_status_enum"`);
    await queryRunner.query(
      `DROP TYPE "public"."anteprojects_projecttype_enum"`,
    );
    await queryRunner.query(
      `DROP INDEX "public"."IDX_69c2b98d062f9a8ffefd0d72f3"`,
    );
    await queryRunner.query(`DROP TABLE "files"`);
    await queryRunner.query(`DROP TYPE "public"."files_attachabletype_enum"`);
    await queryRunner.query(`DROP TABLE "anteproject_evaluation_criteria"`);
    await queryRunner.query(
      `DROP INDEX "public"."IDX_eb224d6d3acf40220d84a63720"`,
    );
    await queryRunner.query(`DROP TABLE "notifications"`);
    await queryRunner.query(`DROP TABLE "system_settings"`);
    await queryRunner.query(
      `DROP TYPE "public"."system_settings_settingtype_enum"`,
    );
    await queryRunner.query(`DROP TABLE "tasks"`);
    await queryRunner.query(`DROP TYPE "public"."tasks_complexity_enum"`);
    await queryRunner.query(`DROP TYPE "public"."tasks_priority_enum"`);
    await queryRunner.query(`DROP TYPE "public"."tasks_status_enum"`);
    await queryRunner.query(`DROP TABLE "milestones"`);
    await queryRunner.query(
      `DROP TYPE "public"."milestones_milestonetype_enum"`,
    );
    await queryRunner.query(`DROP TYPE "public"."milestones_status_enum"`);
    await queryRunner.query(`DROP TABLE "projects"`);
    await queryRunner.query(`DROP TYPE "public"."projects_status_enum"`);
    await queryRunner.query(`DROP TABLE "users"`);
    await queryRunner.query(`DROP TYPE "public"."users_status_enum"`);
    await queryRunner.query(`DROP TYPE "public"."users_role_enum"`);
  }
}
