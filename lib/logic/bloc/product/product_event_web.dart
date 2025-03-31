part of 'product_bloc_web.dart';

abstract class ProductEventWeb extends Equatable {
  const ProductEventWeb();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEventWeb {
  final int inventoryId;

  const LoadProducts({required this.inventoryId});

  @override
  List<Object> get props => [inventoryId];
}

class AddProduct extends ProductEventWeb {
  final int? id; // ← opcional para edición (web)
  final String name;
  final String barcode;
  final double price;
  final int quantity;
  final int inventoryId;

  const AddProduct({
    this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.quantity,
    required this.inventoryId,
  });

  @override
  List<Object> get props => [
        if (id != null) id!,
        name,
        barcode,
        price,
        quantity,
        inventoryId,
      ];
}

class DeleteProduct extends ProductEventWeb {
  final int productId;
  final int inventoryId;

  const DeleteProduct({
    required this.productId,
    required this.inventoryId,
  });

  @override
  List<Object> get props => [productId, inventoryId];
}

class UpdateProduct extends ProductEventWeb {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final int quantity;
  final int inventoryId;

  const UpdateProduct({
    required this.id,
    required this.name,
    required this.barcode,
    required this.price,
    required this.quantity,
    required this.inventoryId,
  });

  @override
  List<Object> get props => [id, name, barcode, price, quantity, inventoryId];
}
