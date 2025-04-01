import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';


class Inventories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}


class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get quantity => integer().withDefault(Constant(0))();
  IntColumn get inventoryId => integer().references(Inventories, #id, onDelete: KeyAction.cascade)();
  TextColumn get barcode => text().nullable()();
  RealColumn get price => real()(); 
}



@DriftDatabase(tables: [Inventories, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;


  Future<int> insertInventory(InventoriesCompanion inventory) => into(inventories).insert(inventory);
  Future<List<Inventory>> getAllInventories() => select(inventories).get();
  Future<int> deleteInventory(int id) => (delete(inventories)..where((tbl) => tbl.id.equals(id))).go();


  Future<int> insertProduct(ProductsCompanion product) => into(products).insert(product);
  Future<List<Product>> getProductsByInventory(int inventoryId) =>
      (select(products)..where((tbl) => tbl.inventoryId.equals(inventoryId))).get();
  Future<int> deleteProduct(int id) => (delete(products)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}
