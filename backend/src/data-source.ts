import 'dotenv/config';
import { DataSource, DataSourceOptions } from 'typeorm';
import { SystemSetting } from './system-settings/entities/system_setting.entity';

export const dataSourceOptions: DataSourceOptions = {
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432', 10),
  username: process.env.DB_USERNAME || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
  database: process.env.DB_DATABASE || 'nestjs',
  entities: [
    __dirname + '/**/*.entity{.ts,.js}',
    SystemSetting, // Importación explícita para asegurar que se registre
  ],
  migrations: [__dirname + '/database/migrations/*{.ts,.js}'],
  synchronize: false, // ¡Muy importante para producción!
};

const dataSource = new DataSource(dataSourceOptions);
export default dataSource;
