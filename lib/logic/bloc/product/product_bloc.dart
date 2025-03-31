import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_manager/data/database/app_database.dart';
import 'package:drift/drift.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AppDatabase database;

  ProductBloc({required this.database}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    if (event.inventoryId <= 0) {
      emit(ProductError(message: 'Invalid inventory ID'));
      return;
    }
    emit(ProductLoading());
    try {
      final products = await database.getProductsByInventory(event.inventoryId);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: 'Error loading products: ${e.toString()}'));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<ProductState> emit) async {
  try {
    final productCompanion = ProductsCompanion(
      name: Value(event.name),
      barcode: Value(event.barcode), 
      price: Value(event.price),      
      quantity: Value(event.quantity),
      inventoryId: Value(event.inventoryId),
    );
    await database.insertProduct(productCompanion);
    add(LoadProducts(inventoryId: event.inventoryId));
  } catch (e) {
    emit(ProductError(message: 'Error adding product: ${e.toString()}'));
  }
}

  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await database.deleteProduct(event.productId);
      add(LoadProducts(inventoryId: event.inventoryId));
    } catch (e) {
      emit(ProductError(message: 'Error deleting product: ${e.toString()}'));
    }
  }
}
