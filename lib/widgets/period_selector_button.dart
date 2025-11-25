import 'package:flutter/material.dart';

class PeriodSelectorButton extends StatelessWidget {
  final Function(String) onSelect;

  const PeriodSelectorButton({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.calendar_month),
      onSelected: onSelect,
      itemBuilder: (_) => [
        PopupMenuItem(value: "all", child: Text("All time")),
        PopupMenuItem(value: "today", child: Text("Today")),
        PopupMenuItem(value: "week", child: Text("Last 7 days")),
        PopupMenuItem(value: "month", child: Text("This month")),
        PopupMenuItem(value: "custom", child: Text("Custom range")),
      ],
    );
  }
}
