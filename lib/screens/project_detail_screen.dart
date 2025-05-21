import 'package:flutter/material.dart';
import 'package:flutter_api_rest/models/project.dart';
import 'package:flutter_api_rest/screens/project_form_screen.dart';
import 'package:flutter_api_rest/services/project_service.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final ProjectService _projectService = ProjectService();
  late Future<Project> _futureProject;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  void _loadProject() {
    _futureProject = _projectService.getProject(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Proyecto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProject(),
          )
        ],
      ),
      body: FutureBuilder<Project>(
        future: _futureProject,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"),);
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró el proyecto.'),);
          } else {
            final project = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const SizedBox(height: 16,),
                  Text('Creado el: ${project.createdAt ?? "No disponible"}'),
                  Text('Última actualización: ${project.updatedAt ?? "No disponible"}'),
                ],
              ),
            );
          }
        },
      )
    );
  }

  Future<void> _editProject() async {
    final project = await _projectService.getProject(widget.projectId);
    if (mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectFormScreen(project: project),
        )
      );

      if (result == true) {
        setState(() {
          _loadProject();
        });
      }
    }
  }
}