// Görev Modeli
// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  late final String? priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
  });

  // Map'e Dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority,
    };
  }

  // Map'ten Task'e Dönüştürme
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] == 1,
      priority: map['priority'] as String,
    );
  }
}
