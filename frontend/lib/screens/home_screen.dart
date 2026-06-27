import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/task.dart';
import '../models/category.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'profile_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _userId = 0;
  List<Task> _tasks = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  String _filterStatus = 'All';
  String _filterPriority = 'All';
  String _filterCategory = 'All';

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
    _loadCategories();
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

  void _loadCategories() async {
    Map<String, dynamic> result = await ApiService.getCategories();
    if (result['success']) {
      List data = result['data'];
      setState(() {
        _categories = data.map((item) => Category.fromJson(item)).toList();
      });
    }
  }

  void _toggleStatus(Task task) async {
    String newStatus = task.status == 'Pending'
        ? 'In Progress'
        : task.status == 'In Progress'
            ? 'Completed'
            : 'Pending';
    await ApiService.updateStatus(task.id, _userId, newStatus);
    _loadTasks();
  }

  void _deleteTask(int taskId) async {
    await ApiService.deleteTask(taskId, _userId);
    _loadTasks();
  }

  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      bool statusMatch =
          _filterStatus == 'All' || task.status == _filterStatus;
      bool priorityMatch =
          _filterPriority == 'All' || task.priority == _filterPriority;
      bool categoryMatch = _filterCategory == 'All' ||
          (_categories.any((cat) =>
              cat.id == task.categoryId && cat.name == _filterCategory));
      return statusMatch && priorityMatch && categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userId: _userId),
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            const Text('TaskFlow'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _buildTaskList(),

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
    );
  }

  Widget _buildTaskList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
    Center(
      child: SizedBox(
        width: 600,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(
                        value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(
                        value: 'In Progress', child: Text('In Progress')),
                    DropdownMenuItem(
                        value: 'Completed', child: Text('Completed')),
                  ],
                  onChanged: (value) =>
                      setState(() => _filterStatus = value!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                    DropdownMenuItem(
                        value: 'Medium', child: Text('Medium')),
                    DropdownMenuItem(
                        value: 'Urgent', child: Text('Urgent')),
                  ],
                  onChanged: (value) =>
                      setState(() => _filterPriority = value!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filterCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem(value: 'All', child: Text('All')),
                    ..._categories.map((cat) => DropdownMenuItem(
                          value: cat.name,
                          child: Text(cat.name),
                        )),
                  ],
                  onChanged: (value) =>
                      setState(() => _filterCategory = value!),
                ),
              ),
            ],
          ),
          ),
          ),
        ),
        Expanded(
          child: _filteredTasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks found.',
                    style:
                        TextStyle(color: Color(0xFFC4908A), fontSize: 16),
                  ),
                )
          : Center(
              child: SizedBox(
                width: 600,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    Task task = _filteredTasks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              task: task,
                              categories: _categories,
                            ),
                          ),
                        );
                      },
                      child: Card(
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
                            Text(
                              task.status,
                              style: TextStyle(
                                fontSize: 12,
                                color: task.status == 'Completed'
                                    ? Colors.green
                                    : task.status == 'In Progress'
                                        ? Colors.orange
                                        : Colors.grey,
                              ),
                            ),
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
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFF9E6068)),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditTaskScreen(
                                        userId: _userId, task: task),
                                  ),
                                );
                                _loadTasks();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Color(0xFF9E6068)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Task'),
                                    content: const Text('Are you sure you want to delete this task?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF9E6068))),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteTask(task.id);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    );
                  },
                ),
                ),
                ),
        ),
      ],
    );
  }
}