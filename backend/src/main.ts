// Polyfill INMEDIATO para crypto.randomUUID
require('./polyfill');

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);

    // Configurar CORS
    app.enableCors();

    // Configurar prefijo global para APIs
    app.setGlobalPrefix('api');

    const port = process.env.PORT ?? 3000;
    await app.listen(port);

    console.log(`Application is running on: http://localhost:${port}/api`);
}
bootstrap();
