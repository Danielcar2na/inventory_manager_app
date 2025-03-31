import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_manager/data/models/product_model.dart';
import 'package:inventory_manager/data/repositories/product/web/produc_repository.dart';
part 'product_event_web.dart';
part 'product_state_web.dart';

class ProductBlocWeb extends Bloc<ProductEventWeb, ProductStateWeb> {
  final ProductRepository repository;

  ProductBlocWeb({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<UpdateProduct>(_onUpdateProduct);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductStateWeb> emit) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts(event.inventoryId);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: 'Error al cargar productos: ${e.toString()}'));
    }
  }

  Future<void> _onAddProduct(
      AddProduct event, Emitter<ProductStateWeb> emit) async {
    try {
      final newProduct = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: event.name,
        barcode: event.barcode,
        price: event.price,
        quantity: event.quantity,
        inventoryId: event.inventoryId,
      );
      await repository.addProduct(newProduct);
      add(LoadProducts(inventoryId: event.inventoryId));
    } catch (e) {
      emit(ProductError(message: 'Error al agregar producto: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProduct event, Emitter<ProductStateWeb> emit) async {
    try {
      await repository.deleteProduct(event.productId);
      add(LoadProducts(inventoryId: event.inventoryId));
    } catch (e) {
      emit(ProductError(message: 'Error al eliminar producto: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProduct event, Emitter<ProductStateWeb> emit) async {
    try {
      final updatedProduct = ProductModel(
        id: event.id,
        inventoryId: event.inventoryId,
        name: event.name,
        barcode: event.barcode,
        price: event.price,
        quantity: event.quantity,
      );
      await repository.updateProduct(updatedProduct);
      add(LoadProducts(inventoryId: event.inventoryId));
    } catch (e) {
      emit(ProductError(message: 'Error al actualizar producto: $e'));
    }
  }
}
