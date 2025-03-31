// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:inventory_manager/data/models/inventory_model.dart';
// import 'package:inventory_manager/data/models/product_model.dart';

// class AppDatabaseWeb {
//   final SharedPreferences sharedPreferences;
//   static const String _inventoryKey = 'inventories';
//   static const String _productKey = 'products';

//   AppDatabaseWeb({required this.sharedPreferences});

//   // Corrección obligatoria aquí ↓↓↓↓
//   Future<List<ProductModel>> getAllProducts() async {
//     final jsonString = sharedPreferences.getString(_productKey);
//     if (jsonString == null) return [];
//     final List<dynamic> jsonList = json.decode(jsonString);
//     return jsonList.map((e) => ProductModel.fromJson(e)).toList();
//   }

//   Future<List<ProductModel>> getProductsByInventory(int inventoryId) async {
//     final allProducts = await getAllProducts();
//     return allProducts.where((p) => p.inventoryId == inventoryId).toList();
//   }

//   Future<void> insertProduct(ProductModel product) async {
//     final allProducts = await getAllProducts();
//     allProducts.add(product);
//     await _saveProducts(allProducts);
//   }

//   Future<void> deleteProduct(int id) async {
//     final allProducts = await getAllProducts();
//     allProducts.removeWhere((p) => p.id == id);
//     await _saveProducts(allProducts);
//   }

//   Future<void> _saveProducts(List<ProductModel> products) async {
//     final jsonString = jsonEncode(products.map((e) => e.toJson()).toList());
//     await sharedPreferences.setString(_productKey, jsonString);
//   }

//   // Inventarios (correcto)
//   Future<List<InventoryModel>> getAllInventories() async {
//     final jsonString = sharedPreferences.getString(_inventoryKey);
//     if (jsonString == null) return [];
//     final List<dynamic> jsonList = json.decode(jsonString);
//     return jsonList.map((e) => InventoryModel.fromJson(e)).toList();
//   }

//   Future<void> insertInventory(InventoryModel inventory) async {
//     final inventories = await getAllInventories();
//     inventories.add(inventory);
//     await _saveInventories(inventories);
//   }

//   Future<void> deleteInventory(int id) async {
//     final inventories = await getAllInventories();
//     inventories.removeWhere((inventory) => inventory.id == id);
//     await _saveInventories(inventories);
//   }

//   Future<void> _saveInventories(List<InventoryModel> inventories) async {
//     final jsonString = jsonEncode(inventories.map((e) => e.toJson()).toList());
//     await sharedPreferences.setString(_inventoryKey, jsonString);
//   }
// }
