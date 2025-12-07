import 'package:flutter/material.dart';
import 'package:control_cash/layout/header.dart';
import 'package:control_cash/screens/transactions_screen.dart';
import 'package:control_cash/screens/add_or_edit_transaction_screen.dart';
import 'package:control_cash/screens/stats_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;

  final List<Widget> screens = [
    TransactionsScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: Header(),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddOrEditTransactionScreen(),
            ),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: theme.colorScheme.secondary,
        unselectedItemColor: theme.brightness == Brightness.light
            ? Colors.grey.shade600
            : Colors.grey.shade400,
        backgroundColor: theme.scaffoldBackgroundColor,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: "Transactions",
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
