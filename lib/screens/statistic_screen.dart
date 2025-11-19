import 'package:control_cash/main.dart';
import 'package:control_cash/services/auth_service.dart';
import 'package:flutter/material.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
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
        child: Column(
          children: [
            Text(userEmail),
            Text('Statistic'),
            ElevatedButton(onPressed: () {
              authService.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            }, child: Text('Logout')),
          ],
        ),
      ),
    );
  }
}
