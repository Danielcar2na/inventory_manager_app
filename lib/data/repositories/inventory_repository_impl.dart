import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/inventory_model.dart';
import 'inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final SharedPreferences sharedPreferences;

  InventoryRepositoryImpl({required this.sharedPreferences});

  static const String _key = 'inventories';

  @override
  Future<List<InventoryModel>> getInventories() async {
    final data = sharedPreferences.getString(_key) ?? '[]';
    List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => InventoryModel.fromJson(json)).toList();
  }

  @override
  Future<void> addInventory(InventoryModel inventory) async {
    final inventories = await getInventories();

    if (inventories.any((inv) => inv.id == inventory.id)) {
      throw Exception('El inventario con ID ${inventory.id} ya existe');
    }

    inventories.add(inventory);
    await _saveInventories(inventories);
  }

  @override
  Future<void> deleteInventory(int id) async {
    final inventories = await getInventories();
    inventories.removeWhere((inv) => inv.id == id);
    await _saveInventories(inventories);
  }

 @override
Future<void> updateInventory(int id, String newName) async {
  final inventories = await getInventories();
  final updatedInventories = inventories.map((inv) {
    if (inv.id == id) {
      return InventoryModel(
        id: inv.id,
        name: newName,
        quantity: inv.quantity,
        price: inv.price,
      );
    }
    return inv;
  }).toList();
  await _saveInventories(updatedInventories);
}


  Future<void> _saveInventories(List<InventoryModel> inventories) async {
    final jsonString = jsonEncode(inventories.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_key, jsonString);
  }
}
