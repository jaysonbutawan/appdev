class CoffeeHouse {
  final String id;
  final String name;
  final String address;
  final String prepTime;

  CoffeeHouse({
    required this.id,
    required this.name,
    required this.address,
    required this.prepTime,
  });

  factory CoffeeHouse.fromJson(Map<String, dynamic> json) {
    return CoffeeHouse(
      id: json['id']?.toString() ?? "",
      name: json['name'] ?? "Unknown",
      address: json['address'] ?? "No address",
      prepTime: json['prep_time_minutes']?.toString() ?? "0",
    );
  }
}
