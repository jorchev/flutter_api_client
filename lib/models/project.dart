// 1. Modelo de datos para Project
class Project {
  final int? id;
  final String name;
  final String description;
  final String? createdAt;
  final String? updatedAt;

  Project({
    this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description
    };
  }
}