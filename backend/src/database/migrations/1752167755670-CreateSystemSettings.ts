import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateSystemSettings1752167755670 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Crear el tipo enum solo si no existe
        await queryRunner.query(`
            DO $$ BEGIN
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'system_settings_settingtype_enum') THEN
                    CREATE TYPE "public"."system_settings_settingtype_enum" AS ENUM('string', 'integer', 'boolean', 'json');
                END IF;
            END $$;
        `);

        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "system_settings" (
                "id" SERIAL NOT NULL,
                "settingKey" character varying(100) NOT NULL,
                "settingValue" text NOT NULL,
                "settingType" "public"."system_settings_settingtype_enum" NOT NULL DEFAULT 'string',
                "description" text,
                "isEditable" boolean NOT NULL DEFAULT true,
                "updatedById" integer,
                "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
                CONSTRAINT "UQ_system_settings_settingKey" UNIQUE ("settingKey"),
                CONSTRAINT "PK_system_settings_id" PRIMARY KEY ("id"),
                CONSTRAINT "FK_system_settings_updatedById" FOREIGN KEY ("updatedById") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
            )
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE "system_settings"`);
        await queryRunner.query(`DROP TYPE "public"."system_settings_settingtype_enum"`);
    }

}
