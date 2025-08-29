import { IsString, IsNotEmpty, IsNumber, IsEnum } from 'class-validator';
import { ProjectStatusEnum } from '../project-status.enum'; // le fichier où tu as créé l'enum

export class CreateProjectDto {
  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsEnum(ProjectStatusEnum)
  status!: ProjectStatusEnum;

  @IsNumber()
  amount!: number;
}

