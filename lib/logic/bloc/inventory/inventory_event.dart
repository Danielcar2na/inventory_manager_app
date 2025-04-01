part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadInventories extends InventoryEvent {
  const LoadInventories();
}

class AddInventory extends InventoryEvent {
  final String name;

  const AddInventory(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteInventory extends InventoryEvent {
  final int id;

  const DeleteInventory(this.id);

  @override
  List<Object?> get props => [id];
}
