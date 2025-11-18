import 'package:catalog_3d/features/item/data/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseItemSource {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createItem(Item item) async {
    await _firestore.collection('items').add(item.toJson());
  }

  Future<void> updateItem(Item item) async {
    await _firestore.collection('items').doc(item.id).update(item.toJson());
  }

  Future<List<Item>> listItems() async {
    var items = await _firestore.collection('items').get();

    return items.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Item.fromJson(data);
    }).toList();
  }

  Future<Item?> getItem(String id) async {
    var item = await _firestore.collection('items').doc(id).get();
    if (!item.exists || item.data() == null) {
      return null;
    }

    Item itemData = Item.fromJson(item.data()!);
    itemData.id = item.id;

    return itemData;
  }

  Future<void> deleteItem(String id) async {
    await _firestore.collection('items').doc(id).delete();
  }
}
