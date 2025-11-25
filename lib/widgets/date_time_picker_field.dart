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
    final formatted = DateFormat('dd.MM.yyyy – HH:mm').format(value);

    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatted,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.edit_calendar, size: 20),
          ],
        ),
      ),
    );
  }
}
