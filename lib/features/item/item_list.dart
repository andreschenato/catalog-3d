import 'package:catalog_3d/core/widgets/custom_list.dart';
import 'package:catalog_3d/core/widgets/item_card.dart';
import 'package:catalog_3d/features/item/mock_items.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Items"))),
      body: CustomList(
        items: items
            .map((item) => ItemCard(name: item.name, price: item.finalPrice))
            .toList(),
      ),
    );
  }
}
