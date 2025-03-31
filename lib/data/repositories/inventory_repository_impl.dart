import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/inventory_model.dart';
import 'inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final SharedPreferences sharedPreferences;
  
  InventoryRepositoryImpl({required this.sharedPreferences});

  @override
  Future<List<InventoryModel>> getInventories() async {
    final data = sharedPreferences.getString('inventories') ?? '[]';
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
    await sharedPreferences.setString(
      'inventories',
      jsonEncode(inventories.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteInventory(int id) async {  
    final inventories = await getInventories();
    inventories.removeWhere((inv) => inv.id == id);
    await sharedPreferences.setString(
      'inventories',
      jsonEncode(inventories.map((e) => e.toJson()).toList()),
    );
  }
}
