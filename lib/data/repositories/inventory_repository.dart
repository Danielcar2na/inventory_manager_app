import 'package:inventory_manager/data/models/inventory_model.dart';

abstract class InventoryRepository {
  Future<List<InventoryModel>> getInventories();
  Future<void> addInventory(InventoryModel inventory);
  Future<void> deleteInventory(int id);
}
