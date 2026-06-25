class Task {
  final int id;
  final int userId;
  final int? categoryId;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String deadline;
  final String createdAt;

  Task({
    required this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.deadline,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      categoryId: json['category_id'] != null ? int.parse(json['category_id'].toString()) : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Pending',
      priority: json['priority'] ?? 'Medium',
      deadline: json['deadline'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}