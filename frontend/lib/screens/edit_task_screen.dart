import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/task.dart';
import '../models/category.dart';

class EditTaskScreen extends StatefulWidget {
  final int userId;
  final Task task;
  const EditTaskScreen({super.key, required this.userId, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  String _priority = 'Medium';
  String _status = 'Pending';
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _deadlineController.text = widget.task.deadline;
    _priority = widget.task.priority;
    _status = widget.task.status;
    _loadCategories();
  }

  void _loadCategories() async {
    Map<String, dynamic> result = await ApiService.getCategories();
    if (result['success']) {
      List data = result['data'];
      setState(() {
        _categories = data.map((item) => Category.fromJson(item)).toList();
        if (widget.task.categoryId != null) {
          _selectedCategory = _categories.firstWhere(
            (cat) => cat.id == widget.task.categoryId,
            orElse: () => _categories.first,
          );
        }
      });
    }
  }

  void _pickDeadline() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _deadlineController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _editTask() async {
    String title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await ApiService.editTask(
      widget.task.id,
      widget.userId,
      _selectedCategory?.id,
      title,
      _descriptionController.text.trim(),
      _priority,
      _deadlineController.text.trim(),
    );

    await ApiService.updateStatus(widget.task.id, widget.userId, _status);

    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
  body: Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Task Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Description (optional)',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.flag),
                hintText: 'Priority',
              ),
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
              ],
              onChanged: (value) => setState(() => _priority = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.check_circle_outline),
                hintText: 'Status',
              ),
            items: const [
              DropdownMenuItem(value: 'Pending', child: Text('Pending')),
              DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
              DropdownMenuItem(value: 'Completed', child: Text('Completed')),
            ],
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                hintText: 'Category (optional)',
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deadlineController,
              readOnly: true,
              onTap: _pickDeadline,
              decoration: const InputDecoration(
                hintText: 'Deadline (optional)',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _editTask,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
        ),
        ),
      ),
    );
  }
}