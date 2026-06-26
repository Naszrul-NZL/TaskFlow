import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _userId = 0;
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;
    });
    _loadTasks();
  }

  void _loadTasks() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> result = await ApiService.getTasks(_userId);
    if (result['success']) {
      List data = result['data'];
      setState(() {
        _tasks = data.map((item) => Task.fromJson(item)).toList();
      });
    }
    setState(() => _isLoading = false);
  }

  void _toggleStatus(Task task) async {
    String newStatus = task.status == 'Pending' ? 'Completed' : 'Pending';
    await ApiService.updateStatus(task.id, _userId, newStatus);
    _loadTasks();
  }

  void _deleteTask(int taskId) async {
    await ApiService.deleteTask(taskId, _userId);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        automaticallyImplyLeading: false,
      ),
    body: IndexedStack(
      index: _currentIndex,
      children: [
        _buildTaskList(),
        ProfileScreen(userId: _userId),
      ],
    ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(userId: _userId),
                  ),
                );
                _loadTasks();
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks yet. Tap + to add one!',
          style: TextStyle(color: Color(0xFFC4908A), fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        Task task = _tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Checkbox(
              value: task.status == 'Completed',
              onChanged: (value) => _toggleStatus(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.status == 'Completed'
                    ? TextDecoration.lineThrough
                    : null,
                color: task.status == 'Completed'
                    ? Colors.grey
                    : const Color(0xFF3D1A1F),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.deadline.isNotEmpty)
                  Text('Due: ${task.deadline}',
                      style: const TextStyle(fontSize: 12)),
                Text(
                  task.priority,
                  style: TextStyle(
                    fontSize: 12,
                    color: task.priority == 'Urgent'
                        ? Colors.red
                        : task.priority == 'Medium'
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF9E6068)),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditTaskScreen(userId: _userId, task: task),
                      ),
                    );
                    _loadTasks();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFF9E6068)),
                  onPressed: () => _deleteTask(task.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}