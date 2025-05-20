// 2. Servicio para comunicación con la API
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_api_rest/models/project.dart';

class PorjectService {
  final String baseUrl = 'http://10.0.2.2:8000/api/projects';

  // Obtener todos los proyectos
  Future<List<Project>> getProjects() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Project> projects = body.map((item) => Project.fromJson(item)).toList();
      return projects;
    } else {
      throw Exception('Failed to load projects');
    }
  }


  // Obtener un proyecto específico por ID
  Future<Project> getProject(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load project');
    }
  }

  // Crear un nuevo proyecto
  Future<Project> createProject(Project project) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 201) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  // Actualizar un proyecto existente
  Future<Project> updateProject(int id, Project project) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update project');
    }

  }

  // Eliminar un proyecto
  Future<bool> deleteProject(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 204 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete project');
    }
  }

}