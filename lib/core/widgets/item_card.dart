import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final num price;
  final VoidCallback onPressed;

  const ItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        margin: EdgeInsetsGeometry.all(0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        child: InkWell(
          onTap: onPressed,
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
      ),
    );
  }
}
