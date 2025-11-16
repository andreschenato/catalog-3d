import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  final List items;
  const CustomList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: List.from(items),
        ),
      ),
    );
  }
}
