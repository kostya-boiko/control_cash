import 'package:flutter/material.dart';

class StandardInput extends StatelessWidget {
  const StandardInput({
    super.key,
    this.controller,
    this.isObscureText = false,
    required this.labelText,
    this.errorText,
    this.maxLines = 1,
    this.keyboardType,
  });
  final TextEditingController? controller;
  final bool isObscureText;
  final String labelText;
  final String? errorText;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
    );
  }
}
