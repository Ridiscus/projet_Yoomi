import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';

class ProjectRepository {
  final String baseUrl = 'http://192.168.1.69:5555/projects';

  Future<List<Project>> fetchProjects() async {
    final res = await http.get(Uri.parse(baseUrl));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch projects');
    }
  }

  Future<Project> createProject(Project p) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': p.name,
        'status': p.status,
        'amount': p.amount,
      }),
    );
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Project.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to create project: ${res.body}');
    }
  }

  Future<Project> updateProject(Project p) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${p.id}'), // ID en int
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': p.name,
        'status': p.status,
        'amount': p.amount,
      }),
    );
    if (res.statusCode == 200) {
      return Project.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to update project: ${res.body}');
    }
  }

  // <-- ici on change String id en int id
  Future<void> deleteProject(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete project: ${res.body}');
    }
  }
}