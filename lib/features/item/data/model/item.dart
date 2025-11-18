class Item {
  String? id;
  String name;
  num printingTime;
  num weight;
  num kgCost;
  num markup;
  num finalPrice;
  num totalCost;
  num printerPower;
  num kwhCost;
  num? printerPrice;
  num? lifeTime;
  num? failPercentage;

  Item({
    this.id,
    required this.name,
    required this.printingTime,
    required this.weight,
    required this.kgCost,
    required this.markup,
    required this.finalPrice,
    required this.totalCost,
    required this.printerPower,
    required this.kwhCost,
    this.printerPrice,
    this.lifeTime,
    this.failPercentage,
  });

  factory Item.fromJson(Map<dynamic, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      printingTime: json['printingTime'],
      weight: json['weight'],
      kgCost: json['kgCost'],
      markup: json['markup'],
      finalPrice: json['finalPrice'],
      totalCost: json['totalCost'],
      printerPower: json['printerPower'],
      kwhCost: json['kwhCost'],
      printerPrice: json['printerPrice'],
      lifeTime: json['lifeTime'],
      failPercentage: json['failPercentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'printingTime': printingTime,
      'weight': weight,
      'kgCost': kgCost,
      'markup': markup,
      'finalPrice': finalPrice,
      'totalCost': totalCost,
      'printerPower': printerPower,
      'kwhCost': kwhCost,
      'printerPrice': printerPrice,
      'lifeTime': lifeTime,
      'failPercentage': failPercentage,
    };
  }
}
