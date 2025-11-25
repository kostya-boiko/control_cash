import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  const StandardButton({
    super.key,
    required this.textInfo,
    this.onClick,
    this.isAccent = false,
    this.isLoading = false,
  });

  final String textInfo;
  final VoidCallback? onClick;
  final bool isAccent;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: onClick,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(width: 1, color: Colors.grey),
          backgroundColor: isAccent
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white, strokeWidth: 4)
            : Text(
                textInfo,
                style: TextStyle(
                  fontSize: 18,
                  color: isAccent
                      ? Colors.white
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
    );
  }
}
