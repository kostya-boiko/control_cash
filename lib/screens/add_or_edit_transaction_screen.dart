import 'package:control_cash/widgets/date_time_picker_field.dart';
import 'package:control_cash/widgets/standard_button.dart';
import 'package:control_cash/widgets/standard_input.dart';
import 'package:flutter/material.dart';

class AddOrEditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic>? transaction;

  const AddOrEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddOrEditTransactionScreen> createState() =>
      _AddOrEditTransactionScreenState();
}

class _AddOrEditTransactionScreenState extends State<AddOrEditTransactionScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final commentController = TextEditingController();

  late DateTime selectedDateTime;
  late bool isEdit;

  @override
  void initState() {
    super.initState();

    isEdit = widget.transaction != null;

    if (isEdit) {
      titleController.text = widget.transaction!["title"];
      amountController.text = widget.transaction!["amount"].toString();
      commentController.text = widget.transaction!["comment"] ?? "";
      selectedDateTime = widget.transaction!["dateTime"];
    } else {
      selectedDateTime = DateTime.now();
    }
  }

  Future<void> pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (pickedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void saveOrUpdate() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final comment = commentController.text.trim();

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid title and amount")),
      );
      return;
    }

    final result = {
      "title": title,
      "amount": amount,
      "comment": comment,
      "dateTime": selectedDateTime,
    };

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Transaction" : "Add Transaction"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StandardInput(
              controller: titleController,
              labelText: "Title",
            ),
            const SizedBox(height: 14),

            StandardInput(
              controller: amountController,
              labelText: "Amount",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),

            StandardInput(
              controller: commentController,
              labelText: "Comment",
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            DateTimePickerField(
              value: selectedDateTime,
              onClick: pickDateTime,
            ),
            const SizedBox(height: 30),

            StandardButton(
              textInfo: 'Save Transaction',
              onClick: saveOrUpdate,
              isAccent: true,
            ),
          ],
        ),
      ),
    );
  }
}
