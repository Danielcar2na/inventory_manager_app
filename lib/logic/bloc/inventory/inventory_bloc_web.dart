import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_manager/data/models/inventory_model.dart';
import 'package:inventory_manager/data/repositories/inventory_repository.dart';

part 'inventory_event_web.dart';
part 'inventory_state_web.dart';

class InventoryBlocWeb extends Bloc<InventoryEventWeb, InventoryStateWeb> {
  final InventoryRepository repository;

  InventoryBlocWeb({required this.repository}) : super(InventoryInitialWeb()) {
    on<LoadInventoriesWeb>(_onLoadInventories);
    on<AddInventoryWeb>(_onAddInventory);
    on<DeleteInventoryWeb>(_onDeleteInventory);
  }

  Future<void> _onLoadInventories(
      LoadInventoriesWeb event, Emitter<InventoryStateWeb> emit) async {
    emit(InventoryLoadingWeb());
    try {
      final inventories = await repository.getInventories();
      emit(InventoryLoadedWeb(items: inventories));
    } catch (e) {
      emit(InventoryErrorWeb(message: 'Error loading inventories: $e'));
    }
  }

  Future<void> _onAddInventory(
      AddInventoryWeb event, Emitter<InventoryStateWeb> emit) async {
    try {
      final newInventory = InventoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: event.name,
        quantity: 0,
        price: 0.0,
      );
      await repository.addInventory(newInventory);
      add(LoadInventoriesWeb());
    } catch (e) {
      emit(InventoryErrorWeb(message: 'Error adding inventory: $e'));
    }
  }

  Future<void> _onDeleteInventory(
      DeleteInventoryWeb event, Emitter<InventoryStateWeb> emit) async {
    try {
      await repository.deleteInventory(event.id);
      add(LoadInventoriesWeb());
    } catch (e) {
      emit(InventoryErrorWeb(message: 'Error deleting inventory: $e'));
    }
  }
}
