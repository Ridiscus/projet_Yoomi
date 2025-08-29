import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Permet à l'app d'accepter les requêtes depuis ton Flutter
  app.enableCors();

  await app.listen(5555); // le port que tu utilises
  console.log("Backend is running on http://localhost:5555");
}

bootstrap();