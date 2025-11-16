class Printer {
  String id;
  String name;
  num power;
  num kwhCost;
  num? price;
  num? lifeTime;
  num? failPercentage;

  Printer({
    required this.id,
    required this.name,
    required this.power,
    required this.kwhCost,
    this.price,
    this.lifeTime,
    this.failPercentage,
  });
}
