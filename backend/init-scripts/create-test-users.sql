-- Script para crear usuarios de prueba en la base de datos FCT
-- Las contraseñas están hasheadas con bcrypt (10 rounds)

-- Insertar usuario administrador
INSERT INTO users (full_name, email, password_hash, role, status, email_verified_at, phone, biography, created_at, updated_at)
VALUES (
    'Administrador del Sistema',
    'admin@fct.local',
    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Admin123!
    'admin',
    'active',
    NOW(),
    '+34 123 456 789',
    'Administrador principal del sistema FCT',
    NOW(),
    NOW()
);

-- Insertar usuario de prueba (estudiante)
INSERT INTO users (full_name, email, password_hash, role, status, email_verified_at, phone, biography, created_at, updated_at)
VALUES (
    'Usuario de Prueba',
    'test@fct.local',
    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Test123!
    'student',
    'active',
    NOW(),
    '+34 987 654 321',
    'Usuario de prueba para desarrollo',
    NOW(),
    NOW()
);

-- Insertar tutor de prueba
INSERT INTO users (full_name, email, password_hash, role, status, email_verified_at, phone, biography, created_at, updated_at)
VALUES (
    'Tutor de Prueba',
    'tutor@fct.local',
    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Tutor123!
    'tutor',
    'active',
    NOW(),
    '+34 555 123 456',
    'Tutor de prueba para proyectos FCT',
    NOW(),
    NOW()
);

-- Insertar configuraciones del sistema
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, is_editable, created_at, updated_at)
VALUES 
    ('allowed_file_types', 'pdf,doc,docx,txt,jpg,jpeg,png,gif,zip,rar', 'string', 'Tipos de archivos permitidos para subida', true, NOW(), NOW()),
    ('max_file_size_mb', '10', 'integer', 'Tamaño máximo de archivo en MB', true, NOW(), NOW()),
    ('system_name', 'Sistema FCT - CIFP Carlos III', 'string', 'Nombre del sistema', true, NOW(), NOW()),
    ('system_version', '1.0.0', 'string', 'Versión del sistema', false, NOW(), NOW()),
    ('maintenance_mode', 'false', 'boolean', 'Modo mantenimiento del sistema', true, NOW(), NOW());

-- Insertar criterios de evaluación
INSERT INTO anteproject_evaluation_criteria (name, description, max_score, display_order, created_at, updated_at)
VALUES 
    ('Claridad y estructura del proyecto', 'El proyecto está bien estructurado y es fácil de entender', 10.0, 1, NOW(), NOW()),
    ('Viabilidad técnica', 'El proyecto es técnicamente viable y realizable', 10.0, 2, NOW(), NOW()),
    ('Innovación y creatividad', 'El proyecto muestra innovación y creatividad', 8.0, 3, NOW(), NOW()),
    ('Planificación y cronograma', 'La planificación es realista y bien definida', 7.0, 4, NOW(), NOW()),
    ('Recursos y presupuesto', 'Los recursos y presupuesto están bien definidos', 5.0, 5, NOW(), NOW());
