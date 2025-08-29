import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';

class ProjectsListPage extends ConsumerStatefulWidget {
  const ProjectsListPage({super.key});

  @override
  ConsumerState<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends ConsumerState<ProjectsListPage> {
  String selectedStatus = 'ALL';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectProvider);

    // ----------------
    // ADD DIALOG
    // ----------------
    void _showAddDialog(BuildContext context, WidgetRef ref) {
      final nameController = TextEditingController();
      final statusController = TextEditingController();
      final amountController = TextEditingController();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add Project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newProject = Project(
                  id: 0, // backend génère l’ID
                  name: nameController.text,
                  status: statusController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  createdAt: DateTime.now(),
                );

                await ref.read(projectProvider.notifier).addProject(newProject);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    }

    // ----------------
    // EDIT DIALOG
    // ----------------
    void _showEditDialog(BuildContext context, WidgetRef ref, Project project) {
      final nameController = TextEditingController(text: project.name);
      final statusController = TextEditingController(text: project.status);
      final amountController =
      TextEditingController(text: project.amount.toString());

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Edit Project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedProject = Project(
                  id: project.id,
                  name: nameController.text,
                  status: statusController.text,
                  amount:
                  double.tryParse(amountController.text) ?? project.amount,
                  createdAt: project.createdAt,
                );

                await ref
                    .read(projectProvider.notifier)
                    .updateProject(updatedProject);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    // ----------------
    // UI
    // ----------------
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Filtre status
          DropdownButton<String>(
            value: selectedStatus,
            dropdownColor: Colors.white,
            underline: const SizedBox(),
            items: ['ALL', 'PUBLISHED', 'DRAFT', 'ARCHIVED']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) {
              setState(() {
                selectedStatus = v!;
              });
            },
          ),
          const SizedBox(width: 10),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par nom',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),
        ),
      ),
      body: projectsAsync.when(
        data: (projects) {
          final displayed = ref.read(projectProvider.notifier).getProjects(
            search: searchQuery,
            status: selectedStatus,
          );

          if (displayed.isEmpty) {
            return const Center(child: Text('Aucun projet trouvé'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: displayed.length,
            itemBuilder: (context, index) {
              final Project p = displayed[index];
              final formattedDate =
              DateFormat('dd/MM/yyyy – HH:mm').format(p.createdAt.toLocal());

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '$formattedDate\n${p.status} • ${p.amount.toStringAsFixed(2)} CFA',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          _showEditDialog(context, ref, p);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Project'),
                              content: Text(
                                  'Are you sure you want to delete ${p.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref
                                .read(projectProvider.notifier)
                                .deleteProject(p.id); // id int
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}