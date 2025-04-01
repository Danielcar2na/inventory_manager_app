import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/logic/bloc/inventory/inventory_bloc_web.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc_web.dart';
import 'package:inventory_manager/presentation/screens/products/products_web_screen.dart';
import 'package:inventory_manager/presentation/widgets/card_custom_web.dart';

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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 40,
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'I N V E N T A R Y',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.04),
            const Text(
              'I N V E N T A R Y  L I S T',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: height * 0.04),
            Expanded(
              child: BlocBuilder<InventoryBlocWeb, InventoryStateWeb>(
                builder: (context, state) {
                  if (state is InventoryLoadingWeb) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is InventoryLoadedWeb) {
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: state.items.map((inventory) {
                          return CardCustomWeb(
                            height: height,
                            width: width * 0.3,
                            title: inventory.name,
                            cant: 'ID: ${inventory.id}',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<ProductBlocWeb>(),
                                    child: ProductsWebScreen(
                                        inventoryId: inventory.id),
                                  ),
                                ),
                              );
                            },
                            onEdit: () {
                              _showEditDialog(context, inventory.id, inventory.name);
                            },
                            onDelete: () {
                              context.read<InventoryBlocWeb>().add(
                                  DeleteInventoryWeb(inventory.id));
                            },
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return const Center(child: Text('Error al cargar inventario'));
                  }
                },
              ),
            ),
          ],
        ),
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
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context
                    .read<InventoryBlocWeb>()
                    .add(AddInventoryWeb(nameController.text));
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
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<InventoryBlocWeb>().add(DeleteInventoryWeb(id));
                context
                    .read<InventoryBlocWeb>()
                    .add(AddInventoryWeb(nameController.text));
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
