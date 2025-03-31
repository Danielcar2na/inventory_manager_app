part of 'inventory_bloc_web.dart';

abstract class InventoryStateWeb extends Equatable {
  const InventoryStateWeb();

  @override
  List<Object?> get props => [];
}

class InventoryInitialWeb extends InventoryStateWeb {}

class InventoryLoadingWeb extends InventoryStateWeb {}

class InventoryLoadedWeb extends InventoryStateWeb {
  final List<InventoryModel> items;

  const InventoryLoadedWeb({required this.items});

  @override
  List<Object?> get props => [items];
}

class InventoryErrorWeb extends InventoryStateWeb {
  final String message;

  const InventoryErrorWeb({required this.message});

  @override
  List<Object?> get props => [message];
}
