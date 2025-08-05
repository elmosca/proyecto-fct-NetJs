export default () => ({
    port: parseInt(process.env.PORT || '3000', 10),
    database: {
        host: process.env.DB_HOST || 'localhost',
        port: parseInt(process.env.DB_PORT || '5432', 10),
        username: process.env.DB_USERNAME || 'postgres',
        password: process.env.DB_PASSWORD || 'postgres',
        database: process.env.DB_DATABASE || 'fct_backend_db',
    },
    jwt: {
        secret: process.env.JWT_SECRET || 'your-super-secret-key',
        expiresIn: process.env.JWT_EXPIRATION || '1h',
    },
});
