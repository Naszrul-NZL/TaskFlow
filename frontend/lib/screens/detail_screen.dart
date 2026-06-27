import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/category.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final List<Category> categories;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.categories,
  });

  String _getCategoryName() {
    if (task.categoryId == null) return 'No Category';
    final category = categories.where((cat) => cat.id == task.categoryId).toList();
    if (category.isEmpty) return 'No Category';
    return category.first.name;
  }

  Color _getStatusColor() {
    if (task.status == 'Completed') return Colors.green;
    if (task.status == 'In Progress') return Colors.orange;
    return Colors.grey;
  }

  Color _getPriorityColor() {
    if (task.priority == 'Urgent') return Colors.red;
    if (task.priority == 'Medium') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D1A1F),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.check_circle_outline,
                      label: 'Status',
                      value: task.status,
                      valueColor: _getStatusColor(),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      icon: Icons.flag,
                      label: 'Priority',
                      value: task.priority,
                      valueColor: _getPriorityColor(),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      icon: Icons.category,
                      label: 'Category',
                      value: _getCategoryName(),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: 'Deadline',
                      value: task.deadline.isEmpty ? 'No deadline' : task.deadline,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'Created',
                      value: task.createdAt,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (task.description.isNotEmpty) ...[
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9E6068),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF3D1A1F),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9E6068), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFC4908A),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF3D1A1F),
            ),
          ),
        ],
      ),
    );
  }
}