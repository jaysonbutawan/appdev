class CoffeeHouse {
  final String name;
  final String address;
  final String prepTime;

  CoffeeHouse({required this.name, required this.address, required this.prepTime});

  factory CoffeeHouse.fromJson(Map<String, dynamic> json) {
    return CoffeeHouse(
      name: json['name'],
      address: json['address'],
      prepTime: json['prepTime'],
    );
  }
}
