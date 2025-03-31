import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_manager/data/models/product_model.dart';
import 'package:inventory_manager/data/repositories/product/web/produc_repository.dart';

class ProductRepositorySharedPref implements ProductRepository {
  final SharedPreferences sharedPreferences;
  static const String _productKey = 'products';

  ProductRepositorySharedPref({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getProducts(int inventoryId) async {
    try {
      final jsonString = sharedPreferences.getString(_productKey);
      if (jsonString == null || jsonString.isEmpty) return [];
      
      final List<dynamic> jsonList = json.decode(jsonString);
      final allProducts = jsonList.map((e) => ProductModel.fromJson(e)).toList();

      return allProducts.where((p) => p.inventoryId == inventoryId).toList();
    } catch (e) {
      throw Exception('Error retrieving products: $e');
    }
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    try {
      final allProducts = await _getAllProducts();

      if (allProducts.any((p) => p.id == product.id)) {
        throw Exception('Producto con ID ${product.id} ya existe');
      }

      allProducts.add(product);
      await _saveProducts(allProducts);
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final allProducts = await _getAllProducts();
      allProducts.removeWhere((p) => p.id == id);
      await _saveProducts(allProducts);
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel updatedProduct) async {
    try {
      final allProducts = await _getAllProducts();
      final index = allProducts.indexWhere((p) => p.id == updatedProduct.id);

      if (index != -1) {
        allProducts[index] = updatedProduct;
        await _saveProducts(allProducts);
      } else {
        throw Exception('Producto no encontrado');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<List<ProductModel>> _getAllProducts() async {
    try {
      final jsonString = sharedPreferences.getString(_productKey);
      if (jsonString == null || jsonString.isEmpty) return [];
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error fetching all products: $e');
    }
  }

  Future<void> _saveProducts(List<ProductModel> products) async {
    try {
      final jsonString = jsonEncode(products.map((e) => e.toJson()).toList());
      await sharedPreferences.setString(_productKey, jsonString);
    } catch (e) {
      throw Exception('Error saving products: $e');
    }
  }
}
