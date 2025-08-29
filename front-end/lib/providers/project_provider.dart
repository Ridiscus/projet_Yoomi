import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../services/project_repository.dart';


final projectRepositoryProvider = Provider((ref) => ProjectRepository());

final projectProvider = StateNotifierProvider<ProjectNotifier, AsyncValue<List<Project>>>(
      (ref) => ProjectNotifier(ref.read(projectRepositoryProvider)),
);

class ProjectNotifier extends StateNotifier<AsyncValue<List<Project>>> {
  final ProjectRepository repo;

  ProjectNotifier(this.repo) : super(const AsyncValue.loading()) {
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    try {
      final projects = await repo.fetchProjects();
      state = AsyncValue.data(projects);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addProject(Project p) async {
    try {
      // Appelle l'API pour créer le projet
      final createdProject = await repo.createProject(p);

      // Ajoute le projet créé à la liste actuelle
      final currentProjects = state.value ?? [];
      state = AsyncValue.data([...currentProjects, createdProject]);

    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }


  Future<void> updateProject(Project p) async {
    try {
      final updated = await repo.updateProject(p);

      // mettre à jour juste l'élément concerné
      state.whenData((projects) {
        final updatedList = projects
            .map((proj) => proj.id == updated.id ? updated : proj)
            .toList();
        state = AsyncValue.data(updatedList);
      });

    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await repo.deleteProject(id);
      final currentProjects = state.value ?? [];
      state = AsyncValue.data(currentProjects.where((p) => p.id != id).toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  List<Project> getProjects({String? search, String? status}) {
    final currentProjects = state.value ?? [];
    return currentProjects.where((p) {
      final matchesStatus = status == null || status == 'ALL' || p.status == status;
      final matchesSearch = search == null || p.name.toLowerCase().contains(search.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }


}