import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final int userId;
  const CategoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Categories Screen'));
  }
}