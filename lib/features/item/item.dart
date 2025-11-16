import 'package:catalog_3d/features/printer/printer.dart';

class Item {
  String id;
  String name;
  num printingTime;
  num weight;
  num kgCost;
  num finalPrice;
  num totalCost;
  Printer? printer;

  Item({
    required this.id,
    required this.name,
    required this.printingTime,
    required this.weight,
    required this.kgCost,
    required this.finalPrice,
    required this.totalCost,
    this.printer,
  });
}
