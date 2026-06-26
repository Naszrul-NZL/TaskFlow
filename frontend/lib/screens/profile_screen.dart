import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Screen'));
  }
}