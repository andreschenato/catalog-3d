import 'package:catalog_3d/core/widgets/custom_list.dart';
import 'package:catalog_3d/core/widgets/item_card.dart';
import 'package:catalog_3d/features/item/data/source/firebase_item_source.dart';
import 'package:catalog_3d/features/item/data/model/item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseItemSource source = FirebaseItemSource();

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Items"))),
      body: FutureBuilder<List<Item>>(
        future: source.listItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load models: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Item> items = snapshot.data!;

            return CustomList(
              items: items
                  .map(
                    (item) => ItemCard(
                      name: item.name,
                      price: item.finalPrice,
                      onPressed: () {
                        context.go("/details/${item.id}");
                      },
                    ),
                  )
                  .toList(),
            );
          }

          return const Center(child: Text('No model found!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.go('/create_item');
        },
      ),
    );
  }
}
