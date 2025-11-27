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
    final theme = Theme.of(context);

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
                color: active
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                p,
                style: TextStyle(
                  color: active
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
