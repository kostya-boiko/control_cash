import 'package:control_cash/layout/header.dart';
import 'package:control_cash/screens/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:control_cash/screens/transactions_screen.dart';
import 'package:control_cash/screens/add_transaction_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  final List<Widget> screens = [
    TransactionsScreen(),
    AddTransactionScreen(),
    StatsScreen(),
  ];

  final List<String> titles = [
    "Transactions",
    "Add Transaction",
    "Statistics",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: "Stats",
          ),
        ],
      ),
    );
  }
}
