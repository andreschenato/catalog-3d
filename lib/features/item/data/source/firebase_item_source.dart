import 'package:catalog_3d/features/item/data/model/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseItemSource {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createItem(Item item) async {
    await _firestore.collection('items').add(item.toJson());
  }
}
