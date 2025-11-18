import 'package:catalog_3d/core/widgets/custom_list.dart';
import 'package:catalog_3d/core/widgets/item_card.dart';
import 'package:catalog_3d/features/item/data/source/firebase_item_source.dart';
import 'package:catalog_3d/features/item/data/model/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  FirebaseItemSource source = FirebaseItemSource();

  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = source.listItems();
  }

  void _refreshItems() {
    setState(() {
      _itemsFuture = source.listItems();
    });
  }

  void _deleteItem(String itemId) async {
    await source.deleteItem(itemId);
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Items"))),
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
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
                    (item) => Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              await context.push("/edit/${item.id}");
                              _refreshItems();
                            },
                            backgroundColor: const Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) async {
                              _deleteItem(item.id!);
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),

                      child: ItemCard(
                        name: item.name,
                        price: item.finalPrice,
                        onPressed: () async {
                          await context.push("/details/${item.id}");
                        },
                      ),
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
        onPressed: () async {
          await context.push('/create_item');
          _refreshItems();
        },
      ),
    );
  }
}
