import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerField extends StatelessWidget {
  final DateTime value;
  final VoidCallback onClick;

  const DateTimePickerField({
    super.key,
    required this.value,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = DateFormat('dd.MM.yyyy – HH:mm').format(value);

    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
          color: theme.inputDecorationTheme.fillColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatted,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Icon(Icons.edit_calendar, size: 20, color: theme.iconTheme.color),
          ],
        ),
      ),
    );
  }
}
