import 'package:flutter/material.dart';

class StandardInput extends StatelessWidget {
  const StandardInput({
    super.key,
    this.controller,
    required this.isObscureText,
    required this.labelText,
    this.errorText,
  });

  final TextEditingController? controller;
  final bool isObscureText;
  final String labelText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
    );
  }
}
