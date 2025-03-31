import 'package:inventory_manager/data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts(int inventoryId);
  Future<void> addProduct(ProductModel product);
  Future<void> deleteProduct(int id);
  Future<void> updateProduct(ProductModel product);
}
