import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  final Color backgroundColor;
  final String label;
  final VoidCallback onPressed;

  const GenericButton({
    super.key,
    required this.backgroundColor,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}
