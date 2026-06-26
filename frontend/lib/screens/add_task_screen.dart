import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/category.dart';

class AddTaskScreen extends StatefulWidget {
  final int userId;
  const AddTaskScreen({super.key, required this.userId});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  String _priority = 'Medium';
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    Map<String, dynamic> result = await ApiService.getCategories();
    if (result['success']) {
      List data = result['data'];
      setState(() {
        _categories = data.map((item) => Category.fromJson(item)).toList();
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

  void _addTask() async {
    String title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> result = await ApiService.addTask(
      widget.userId,
      _selectedCategory?.id,
      title,
      _descriptionController.text.trim(),
      _priority,
      _deadlineController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
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
                onPressed: _isLoading ? null : _addTask,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Task', style: TextStyle(fontSize: 16)),
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