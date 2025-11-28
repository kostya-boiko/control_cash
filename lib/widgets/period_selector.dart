import 'package:flutter/material.dart';
import 'package:control_cash/utils/getDateTimeRangeFromName.dart';

class PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final DateTimeRange selectedRange;
  final void Function(String period, DateTimeRange range) onSelect; // callback з назвою і датами

  const PeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.selectedRange,
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
          final period = periods[i];
          final bool active = selectedPeriod == period;

          return GestureDetector(
            onTap: () async {
              final range = await getDateTimeRangeFromName(context, period);
              if (range != null) {
                onSelect(period, range);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: active
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                period,
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
