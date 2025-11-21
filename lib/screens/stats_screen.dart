import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistics")),
      body: Center(
        child: Text(
          "Statistics will be here",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
