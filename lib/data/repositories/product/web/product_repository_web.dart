import 'dart:convert';
import 'package:inventory_manager/data/repositories/product/web/produc_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_manager/data/models/product_model.dart';

class ProductRepositoryWeb implements ProductRepository {
  final SharedPreferences sharedPreferences;
  static const _key = 'products';

  ProductRepositoryWeb({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getProducts(int inventoryId) async {
    final jsonString = sharedPreferences.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    final allProducts = jsonList.map((e) => ProductModel.fromJson(e)).toList();
    return allProducts.where((p) => p.inventoryId == inventoryId).toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    final current = await getProductsForAll();
    final updated = [...current, product];
    await _save(updated);
  }

  @override
  Future<void> deleteProduct(int id) async {
    final current = await getProductsForAll();
    current.removeWhere((p) => p.id == id);
    await _save(current);
  }

  Future<List<ProductModel>> getProductsForAll() async {
    final jsonString = sharedPreferences.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> _save(List<ProductModel> products) async {
    final jsonString = json.encode(products.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_key, jsonString);
  }

  @override
  Future<void> updateProduct(ProductModel updated) async {
    final current = await getProductsForAll();
    final index = current.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      current[index] = updated;
      await _save(current);
    }
  }
}
