import 'package:flutter/material.dart';

class DoubleInput extends StatelessWidget {
  final Widget left;
  final Widget right;
  const DoubleInput(this.left, this.right, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(child: left),
        Expanded(child: right),
      ],
    );
  }
}
