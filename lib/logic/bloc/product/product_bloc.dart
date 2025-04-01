import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_manager/data/models/product_model.dart';
import 'package:inventory_manager/data/repositories/product/web/produc_repository.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<UpdateProduct>(_onUpdateProduct);

  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    if (event.inventoryId <= 0) {
      emit(ProductError(message: 'Invalid inventory ID'));
      return;
    }
    emit(ProductLoading());
    try {
      final products = await repository.getProducts(event.inventoryId);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: 'Error loading products: ${e.toString()}'));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
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
      emit(ProductError(message: 'Error adding product: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await repository.deleteProduct(event.productId);
      add(LoadProducts(inventoryId: event.inventoryId));
    } catch (e) {
      emit(ProductError(message: 'Error deleting product: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
  try {
    final updatedProduct = ProductModel(
      id: event.id,
      name: event.name,
      barcode: event.barcode,
      price: event.price,
      quantity: event.quantity,
      inventoryId: event.inventoryId,
    );

    await repository.updateProduct(updatedProduct);
    add(LoadProducts(inventoryId: event.inventoryId));
  } catch (e) {
    emit(ProductError(message: 'Error al actualizar producto: $e'));
  }
}

}
