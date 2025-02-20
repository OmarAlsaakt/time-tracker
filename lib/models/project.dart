class Project {
  final String id;
  final String name;
  final bool isDefault;

  Project({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  // Convert a JSON object to a Project instance
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      isDefault: json['isDefault'] ?? false, 
    );
  }

  // Convert a Project instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault,
    };
  }
}
