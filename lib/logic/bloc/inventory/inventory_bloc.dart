import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_manager/data/models/inventory_model.dart';
import 'package:inventory_manager/data/repositories/inventory_repository.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository repository;

  InventoryBloc({required this.repository}) : super(InventoryInitial()) {
    on<LoadInventories>(_onLoadInventories);
    on<AddInventory>(_onAddInventory);
    on<DeleteInventory>(_onDeleteInventory);
  }

  Future<void> _onLoadInventories(
      LoadInventories event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());
    try {
      final inventories = await repository.getInventories();
      emit(InventoryLoaded(inventories));
    } catch (e) {
      emit(InventoryError('Error al cargar inventarios: ${e.toString()}'));
    }
  }

  Future<void> _onAddInventory(
      AddInventory event, Emitter<InventoryState> emit) async {
    try {
      final newInventory = InventoryModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: event.name,
        quantity: 0,
        price: 0.0,
      );
      await repository.addInventory(newInventory);
      add(LoadInventories());
    } catch (e) {
      emit(InventoryError('Error al agregar inventario: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteInventory(
      DeleteInventory event, Emitter<InventoryState> emit) async {
    try {
      await repository.deleteInventory(event.id);
      add(LoadInventories());
    } catch (e) {
      emit(InventoryError('Error al eliminar inventario: ${e.toString()}'));
    }
  }
}
