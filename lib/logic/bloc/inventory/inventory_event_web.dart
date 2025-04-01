part of 'inventory_bloc_web.dart';

abstract class InventoryEventWeb extends Equatable {
  const InventoryEventWeb();

  @override
  List<Object?> get props => [];
}

class LoadInventoriesWeb extends InventoryEventWeb {}

class AddInventoryWeb extends InventoryEventWeb {
  final String name;
  const AddInventoryWeb(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteInventoryWeb extends InventoryEventWeb {
  final int id;
  const DeleteInventoryWeb(this.id);

  @override
  List<Object?> get props => [id];
}
class UpdateInventoryWeb extends InventoryEventWeb {
  final int id;
  final String newName;

  const UpdateInventoryWeb({required this.id, required this.newName});

  @override
  List<Object?> get props => [id, newName];
}
