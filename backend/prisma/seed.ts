import { PrismaClient, ProjectStatus } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  const projects = [
  { id: 1, name: 'Residence A', status: ProjectStatus.PUBLISHED, amount: 120000, createdAt: new Date('2024-01-10T10:00:00Z') },
  { id: 2, name: 'Loft B', status: ProjectStatus.DRAFT, amount: 85000, createdAt: new Date('2024-02-05T12:30:00Z') },
  { id: 3, name: 'Villa C', status: ProjectStatus.ARCHIVED, amount: 240000, createdAt: new Date('2023-11-20T09:15:00Z') },
  { id: 4, name: 'Immeuble D', status: ProjectStatus.PUBLISHED, amount: 410000, createdAt: new Date('2024-03-01T08:00:00Z') },
  { id: 5, name: 'Studio E', status: ProjectStatus.DRAFT, amount: 60000, createdAt: new Date('2024-04-18T14:45:00Z') },
];

  for (const p of projects) {
    await prisma.project.upsert({
      where: { id: p.id },
      update: {},
      create: p,
    });
  }
}

main()
  .catch(e => console.error(e))
  .finally(() => prisma.$disconnect());