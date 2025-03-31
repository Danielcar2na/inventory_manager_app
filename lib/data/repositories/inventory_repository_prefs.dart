import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_manager/data/models/inventory_model.dart';
import 'package:inventory_manager/data/repositories/inventory_repository.dart';

class InventoryRepositoryPrefs implements InventoryRepository {
  final SharedPreferences sharedPreferences;
  static const String _inventoryKey = 'inventories';

  InventoryRepositoryPrefs({required this.sharedPreferences});

  @override
  Future<List<InventoryModel>> getInventories() async {
    final jsonString = sharedPreferences.getString(_inventoryKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => InventoryModel.fromJson(e)).toList();
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

  Future<void> _saveInventories(List<InventoryModel> inventories) async {
    final jsonString =
        json.encode(inventories.map((e) => e.toJson()).toList());
    await sharedPreferences.setString(_inventoryKey, jsonString);
  }
}
