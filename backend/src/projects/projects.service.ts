import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
import { ProjectStatusEnum } from './project-status.enum';
import { ProjectStatus } from '@prisma/client';


@Injectable()
export class ProjectsService {
  private prisma = new PrismaClient();

  // Récupérer tous les projets avec filtrage et pagination
  async findAll(
    status?: ProjectStatusEnum, 
    q?: string, 
    page = 1, 
    pageSize = 10
  ) {
    const skip = (page - 1) * pageSize;

    const where: any = {};
    if (status) where.status = status;
    if (q) where.name = { contains: q, mode: 'insensitive' };

    return this.prisma.project.findMany({ where, skip, take: pageSize });
  }


  async create(data: CreateProjectDto) {
  // Conversion du status si fourni
  const status = data.status 
    ? ProjectStatus[data.status as keyof typeof ProjectStatus] 
    : ProjectStatus.DRAFT; // par défaut

  return this.prisma.project.create({
    data: {
      ...data,
      status,
      // pas besoin d'id si c'est auto-increment
    },
  });
}

  // Récupérer un projet par son id
  async findOne(id: string) {
  const project = await this.prisma.project.findUnique({ where: { id: Number(id) } });
  if (!project) throw new NotFoundException(`Project ${id} not found`);
  return project;
}

async update(id: string, data: UpdateProjectDto) {
  await this.findOne(id);

  const updatedData: any = { ...data };
  if (data.status) {
    updatedData.status = ProjectStatus[data.status as keyof typeof ProjectStatus];
  }

  return this.prisma.project.update({
    where: { id: Number(id) },
    data: updatedData,
  });
}

async remove(id: string) {
  await this.findOne(id);
  await this.prisma.project.delete({ where: { id: Number(id) } });
}
}