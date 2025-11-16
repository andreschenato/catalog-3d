import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final num price;

  const ItemCard({super.key, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name),
              Text(
                "R\$price".replaceFirstMapped(
                  'price',
                  (p) => price.toStringAsFixed(2).replaceAll('.', ','),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
