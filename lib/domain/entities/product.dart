class Product {
  final int id; 
  final int inventoryId;  
  final String name;
  final String barcode;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.inventoryId,
    required this.name,
    required this.barcode,
    required this.price,
    required this.quantity,
  });
}
