class ProductModel {
  final int id; 
  final int inventoryId;  
  final String name;
  final String barcode;
  final double price;
  final int quantity;

  ProductModel({
    required this.id,
    required this.inventoryId,
    required this.name,
    required this.barcode,
    required this.price,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,  
      inventoryId: json['inventoryId'] as int, 
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      price: (json['price'] as num).toDouble(), 
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inventoryId': inventoryId,
      'name': name,
      'barcode': barcode,
      'price': price,
      'quantity': quantity,
    };
  }
}
