class Category {
  final int id;
  final int userId;
  final String name;
  final String color;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      name: json['name'] ?? '',
      color: json['color'] ?? '#000000',
    );
  }
}