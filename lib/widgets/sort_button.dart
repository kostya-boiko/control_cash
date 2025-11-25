import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final Function(String) onChanged;

  const SortButton({super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.sort),
      onSelected: onChanged,
      itemBuilder: (_) => [
        PopupMenuItem(value: "date_desc", child: Text("Newest first")),
        PopupMenuItem(value: "date_asc", child: Text("Oldest first")),
        PopupMenuItem(value: "amount_desc", child: Text("Amount ↓")),
        PopupMenuItem(value: "amount_asc", child: Text("Amount ↑")),
      ],
    );
  }
}
