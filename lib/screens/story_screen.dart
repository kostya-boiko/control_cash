import 'package:control_cash/services/auth_service.dart';
import 'package:flutter/material.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  String userEmail = 'noname';
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    print('start');
    final user = authService.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(userEmail),
      ),
    );
  }
}
