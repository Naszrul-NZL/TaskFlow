import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  final int userId;
  const CategoryScreen({super.key, required this.userId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    setState(() => _isLoading = true);
    Map<String, dynamic> result = await ApiService.getCategories(widget.userId);
    if (result['success']) {
      List data = result['data'];
      setState(() {
        _categories = data.map((item) => Category.fromJson(item)).toList();
      });
    }
    setState(() => _isLoading = false);
  }

  void _showAddDialog() {
    final TextEditingController _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Category Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF9E6068))),
          ),
          ElevatedButton(
            onPressed: () async {
              String name = _nameController.text.trim();
              if (name.isEmpty) return;
              await ApiService.addCategory(widget.userId, name, '');
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadCategories();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Category category) {
    final TextEditingController _nameController =
        TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Category Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF9E6068))),
          ),
          ElevatedButton(
            onPressed: () async {
              String name = _nameController.text.trim();
              if (name.isEmpty) return;
              await ApiService.editCategory(
                  category.id, widget.userId, name, category.color);
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadCategories();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(int categoryId) async {
    await ApiService.deleteCategory(categoryId, widget.userId);
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(
                  child: Text(
                    'No categories yet. Tap + to add one!',
                    style:
                        TextStyle(color: Color(0xFFC4908A), fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    Category category = _categories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.folder,
                            color: Color(0xFF9E6068)),
                        title: Text(
                          category.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D1A1F),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFF9E6068)),
                              onPressed: () => _showEditDialog(category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color(0xFF9E6068)),
                              onPressed: () =>
                                  _deleteCategory(category.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}