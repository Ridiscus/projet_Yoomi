import { Controller, Get, Post, Put, Delete, Param, Body, Query } from '@nestjs/common';
import { ProjectsService } from './projects.service';
import { CreateProjectDto } from './dto/create-project.dto';
import { UpdateProjectDto } from './dto/update-project.dto';
import { ProjectStatusEnum } from './project-status.enum';

@Controller('projects')
export class ProjectsController {
  constructor(private readonly service: ProjectsService) {}

  @Get()
  findAll(
    @Query('status') status?: string,
    @Query('q') q?: string,
    @Query('page') page = 1,
    @Query('pageSize') pageSize = 10,
  ) {
    // Convertit le string en enum si status existe
    const enumStatus = status ? (ProjectStatusEnum as any)[status] : undefined;

    return this.service.findAll(enumStatus, q, Number(page), Number(pageSize));
  }

  @Post()
  create(@Body() dto: CreateProjectDto) {
    return this.service.create(dto);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() dto: UpdateProjectDto) {
    return this.service.update(id, dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.service.remove(id);
  }
}