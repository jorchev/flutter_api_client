import 'package:flutter/material.dart';
import 'package:flutter_api_rest/models/project.dart';
import 'package:flutter_api_rest/services/project_service.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;

  const ProjectFormScreen({super.key, required this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectService = ProjectService();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name);
    _descriptionController = TextEditingController(text: widget.project?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project == null ? 'Nuevo Proyecto' : 'Editar Proyecto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24,),
              ElevatedButton(
                onPressed: () {
                  _isLoading ? null : _saveProject();
                }, 
                child: _isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2,),
                )
                : Text(widget.project == null ? 'Crear Proyecto' : 'Actualizar Proyecto'),
              )
            ],
          ),
        ),
      )
    );
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      setState() {
        _isLoading = true;
      }
    }

    try {
      final newProject = Project(
        name: _nameController.text,
        description: _descriptionController.text,
      );

      if (widget.project == null) {
        // Crear nuevo proyecto
        await _projectService.createProject(newProject);
      } else {
        // Actualizar proyecto existente
        await _projectService.updateProject(widget.project!.id!, newProject);
      }

      if(mounted) {
        Navigator.pop(context, true);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'),)
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}