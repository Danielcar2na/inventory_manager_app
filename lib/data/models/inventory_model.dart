class InventoryModel {
  final int id;
  final String name;
  final int quantity;
  final double price;

  InventoryModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'quantity': quantity, 'price': price};
  }

  @override
  String toString() =>
      'InventoryModel(id: $id, name: $name, quantity: $quantity, price: $price)';
}
