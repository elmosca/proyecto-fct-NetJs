// Script de datos de prueba para el backend FCT
// Este archivo se genera automáticamente por create-test-data.ps1

import * as bcrypt from 'bcrypt';
import { DataSource } from 'typeorm';
import { AnteprojectEvaluationCriteria } from '../anteproject-evaluation-criteria/entities/anteproject-evaluation-criteria.entity';
import { SystemSettings } from '../system-settings/entities/system-settings.entity';
import { User } from '../users/entities/user.entity';

export async function createTestData(dataSource: DataSource) {
  console.log('🌱 Creando datos de prueba...');

  // Crear usuarios de prueba
  await createTestUsers(dataSource);
  
  // Crear configuraciones del sistema
  await createSystemSettings(dataSource);
  
  // Crear criterios de evaluación
  await createEvaluationCriteria(dataSource);
  
  console.log('✅ Datos de prueba creados correctamente');
}

async function createTestUsers(dataSource: DataSource) {
  const userRepository = dataSource.getRepository(User);
  
  // Verificar si ya existen usuarios
  const existingUsers = await userRepository.find();
  if (existingUsers.length > 0) {
    console.log('⚠️  Ya existen usuarios en la base de datos, saltando creación...');
    return;
  }
  
  // Crear usuario administrador
  const adminPasswordHash = await bcrypt.hash('Admin123!', 10);
  const adminUser = userRepository.create({
    fullName: 'Administrador del Sistema',
    email: 'admin@fct.local',
    passwordHash: adminPasswordHash,
    role: 'admin',
    status: 'active',
    emailVerifiedAt: new Date(),
    phone: '+34 123 456 789',
    biography: 'Administrador principal del sistema FCT'
  });
  
  // Crear usuario de prueba
  const testPasswordHash = await bcrypt.hash('Test123!', 10);
  const testUser = userRepository.create({
    fullName: 'Usuario de Prueba',
    email: 'test@fct.local',
    passwordHash: testPasswordHash,
    role: 'student',
    status: 'active',
    emailVerifiedAt: new Date(),
    phone: '+34 987 654 321',
    biography: 'Usuario de prueba para desarrollo'
  });
  
  // Crear tutor de prueba
  const tutorPasswordHash = await bcrypt.hash('Tutor123!', 10);
  const tutorUser = userRepository.create({
    fullName: 'Tutor de Prueba',
    email: 'tutor@fct.local',
    passwordHash: tutorPasswordHash,
    role: 'tutor',
    status: 'active',
    emailVerifiedAt: new Date(),
    phone: '+34 555 123 456',
    biography: 'Tutor de prueba para proyectos FCT'
  });
  
  await userRepository.save([adminUser, testUser, tutorUser]);
  console.log('✅ Usuarios de prueba creados');
}

async function createSystemSettings(dataSource: DataSource) {
  const settingsRepository = dataSource.getRepository(SystemSettings);
  
  // Verificar si ya existen configuraciones
  const existingSettings = await settingsRepository.find();
  if (existingSettings.length > 0) {
    console.log('⚠️  Ya existen configuraciones del sistema, saltando creación...');
    return;
  }
  
  const settings = [
    {
      settingKey: 'allowed_file_types',
      settingValue: 'pdf,doc,docx,txt,jpg,jpeg,png,gif,zip,rar',
      settingType: 'string',
      description: 'Tipos de archivos permitidos para subida',
      isEditable: true
    },
    {
      settingKey: 'max_file_size_mb',
      settingValue: '10',
      settingType: 'integer',
      description: 'Tamaño máximo de archivo en MB',
      isEditable: true
    },
    {
      settingKey: 'system_name',
      settingValue: 'Sistema FCT - CIFP Carlos III',
      settingType: 'string',
      description: 'Nombre del sistema',
      isEditable: true
    },
    {
      settingKey: 'system_version',
      settingValue: '1.0.0',
      settingType: 'string',
      description: 'Versión del sistema',
      isEditable: false
    },
    {
      settingKey: 'maintenance_mode',
      settingValue: 'false',
      settingType: 'boolean',
      description: 'Modo mantenimiento del sistema',
      isEditable: true
    }
  ];
  
  for (const setting of settings) {
    const systemSetting = settingsRepository.create(setting);
    await settingsRepository.save(systemSetting);
  }
  
  console.log('✅ Configuraciones del sistema creadas');
}

async function createEvaluationCriteria(dataSource: DataSource) {
  const criteriaRepository = dataSource.getRepository(AnteprojectEvaluationCriteria);
  
  // Verificar si ya existen criterios
  const existingCriteria = await criteriaRepository.find();
  if (existingCriteria.length > 0) {
    console.log('⚠️  Ya existen criterios de evaluación, saltando creación...');
    return;
  }
  
  const criteria = [
    {
      name: 'Claridad y estructura del proyecto',
      description: 'El proyecto está bien estructurado y es fácil de entender',
      maxScore: 10.0,
      displayOrder: 1
    },
    {
      name: 'Viabilidad técnica',
      description: 'El proyecto es técnicamente viable y realizable',
      maxScore: 10.0,
      displayOrder: 2
    },
    {
      name: 'Innovación y creatividad',
      description: 'El proyecto muestra innovación y creatividad',
      maxScore: 8.0,
      displayOrder: 3
    },
    {
      name: 'Planificación y cronograma',
      description: 'La planificación es realista y bien definida',
      maxScore: 7.0,
      displayOrder: 4
    },
    {
      name: 'Recursos y presupuesto',
      description: 'Los recursos y presupuesto están bien definidos',
      maxScore: 5.0,
      displayOrder: 5
    }
  ];
  
  for (const criterion of criteria) {
    const evaluationCriterion = criteriaRepository.create(criterion);
    await criteriaRepository.save(evaluationCriterion);
  }
  
  console.log('✅ Criterios de evaluación creados');
}
