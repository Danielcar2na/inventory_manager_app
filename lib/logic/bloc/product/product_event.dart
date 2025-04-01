part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final int inventoryId;

  const LoadProducts({required this.inventoryId});

  @override
  List<Object> get props => [inventoryId];
}

class AddProduct extends ProductEvent {
  final String name;
  final String barcode;  
  final double price;    
  final int quantity;
  final int inventoryId;

  const AddProduct({
    required this.name,
    required this.barcode,  
    required this.price,    
    required this.quantity,
    required this.inventoryId,
  });

  @override
  List<Object> get props => [name, barcode, price, quantity, inventoryId];
}

class DeleteProduct extends ProductEvent {
  final int productId;
  final int inventoryId;

  const DeleteProduct({required this.productId, required this.inventoryId});

  @override
  List<Object> get props => [productId, inventoryId];
}
class UpdateProduct extends ProductEvent {
  final int id;
  final String name;
  final String barcode;
  final double price;
  final int quantity;
  final int inventoryId;

  UpdateProduct({
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



