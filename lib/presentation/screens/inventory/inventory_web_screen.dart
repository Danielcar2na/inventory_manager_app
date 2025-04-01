import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/logic/bloc/inventory/inventory_bloc_web.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc_web.dart';
import 'package:inventory_manager/presentation/screens/products/products_web_screen.dart';
import 'package:inventory_manager/presentation/widgets/card_custom.dart';

class InventoryWebScreen extends StatefulWidget {
  const InventoryWebScreen({Key? key}) : super(key: key);

  @override
  State<InventoryWebScreen> createState() => _InventoryWebScreenState();
}

class _InventoryWebScreenState extends State<InventoryWebScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InventoryBlocWeb>().add(LoadInventoriesWeb());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario Web')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<InventoryBlocWeb, InventoryStateWeb>(
        builder: (context, state) {
          if (state is InventoryLoadingWeb) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InventoryLoadedWeb) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.6,
                children: state.items.map((inventory) {
                  return CardCustom(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<ProductBlocWeb>(),
                            child: ProductsWebScreen(inventoryId: inventory.id),
                          ),
                        ),
                      );
                    },
                    onDelete: () {
                      context.read<InventoryBlocWeb>().add(DeleteInventoryWeb(inventory.id));
                    },
                    onEdit: () {
                      _showEditDialog(context, inventory.id, inventory.name);
                    },
                    width: 400,
                    height: 150,
                    title: inventory.name,
                    cant: 'ID: ${inventory.id}',
                  );
                }).toList(),
              ),
            );
          } else {
            return const Center(child: Text('Error al cargar inventario'));
          }
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Inventario'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<InventoryBlocWeb>().add(AddInventoryWeb(nameController.text));
                context.read<InventoryBlocWeb>().add(LoadInventoriesWeb());
              }
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int id, String currentName) {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Inventario'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Nuevo Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<InventoryBlocWeb>().add(DeleteInventoryWeb(id));
                context.read<InventoryBlocWeb>().add(AddInventoryWeb(nameController.text));
                context.read<InventoryBlocWeb>().add(LoadInventoriesWeb());
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
