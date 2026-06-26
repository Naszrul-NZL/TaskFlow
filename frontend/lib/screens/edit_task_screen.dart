import 'package:flutter/material.dart';
import '../models/task.dart';

class EditTaskScreen extends StatelessWidget {
  final int userId;
  final Task task;
  const EditTaskScreen({super.key, required this.userId, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: const Center(child: Text('Edit Task Screen')),
    );
  }
}