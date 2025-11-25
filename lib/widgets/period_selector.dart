import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const PeriodSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final List<String> periods = const [
    "Today",
    "Week",
    "Month",
    "Year",
    "Custom",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final p = periods[i];
          final bool active = selected == p;

          return GestureDetector(
            onTap: () => onSelect(p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: active ? Colors.blue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                p,
                style: TextStyle(
                  color: active ? Colors.white : Colors.black87,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
