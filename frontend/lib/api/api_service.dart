import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/TaskFlow/api';

  // AUTH
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // CATEGORIES
  static Future<Map<String, dynamic>> getCategories() async {
      final response = await http.post(
        Uri.parse('$baseUrl/categories/get_categories.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );
      return jsonDecode(response.body);
    }

  static Future<Map<String, dynamic>> addCategory(int userId, String name, String color) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories/add_category.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'name': name, 'color': color}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> editCategory(int id, int userId, String name, String color) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories/edit_category.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'user_id': userId, 'name': name, 'color': color}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteCategory(int id, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories/delete_category.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'user_id': userId}),
    );
    return jsonDecode(response.body);
  }

  // TASKS
  static Future<Map<String, dynamic>> getTasks(int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/get_tasks.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addTask(int userId, int? categoryId, String title, String description, String priority, String deadline) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/add_task.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'priority': priority,
        'deadline': deadline,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> editTask(int id, int userId, int? categoryId, String title, String description, String priority, String deadline) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/edit_task.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'user_id': userId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'priority': priority,
        'deadline': deadline,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteTask(int id, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/delete_task.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'user_id': userId}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateStatus(int id, int userId, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/update_status.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'user_id': userId, 'status': status}),
    );
    return jsonDecode(response.body);
  }
}