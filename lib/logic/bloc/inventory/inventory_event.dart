part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInventories extends InventoryEvent {}

class AddInventory extends InventoryEvent {
  final String name;
  AddInventory(this.name);

  @override
  List<Object?> get props => [name];
}

class DeleteInventory extends InventoryEvent {
  final int id;
  DeleteInventory(this.id);

  @override
  List<Object?> get props => [id];
}