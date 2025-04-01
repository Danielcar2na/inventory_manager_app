import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc.dart';
import 'package:inventory_manager/presentation/screens/products/products_mobile_screen.dart';
import '../../../logic/bloc/inventory/inventory_bloc.dart';
import '../../widgets/card_custom.dart'; // Importa la pantalla de productos

class InventoryMobileScreen extends StatefulWidget {
  const InventoryMobileScreen({Key? key}) : super(key: key);

  @override
  _InventoryMobileScreenState createState() => _InventoryMobileScreenState();
}

class _InventoryMobileScreenState extends State<InventoryMobileScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(LoadInventories());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario'),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body:
          _currentIndex == 0
              ? BlocBuilder<InventoryBloc, InventoryState>(
                builder: (context, state) {
                  if (state is InventoryLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is InventoryLoaded) {
                    return Container(
                      width: width,
                      height: height,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.02,
                          horizontal: width * 0.02,
                        ),
                        child: SingleChildScrollView(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children:
                                state.inventories.map((inventory) {
                                  return CardCustom(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => BlocProvider.value(
                                                value:
                                                    context.read<ProductBloc>(),
                                                child: ProductsMobile(
                                                  inventoryId: inventory.id,
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      context.read<InventoryBloc>().add(
                                        DeleteInventory(inventory.id),
                                      );
                                    },
                                    onEdit: () {
                                      _showEditDialog(
                                        context,
                                        inventory.id,
                                        inventory.name,
                                      );
                                    },
                                    height: height,
                                    width: width * 0.45,
                                    title: inventory.name,
                                    cant: 'ID: ${inventory.id}',
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: Text('Error al cargar inventario'));
                  }
                },
              )
              : Center(
                child: Text('Pantalla de perfil (en desarrollo)'),
              ), // Vista 2

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),  
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(color: Colors.white),
          backgroundColor: Colors.blueAccent.shade100,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory, color: Colors.white),
              label: 'Inventario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.white),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Agregar Inventario'),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Nombre'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    context.read<InventoryBloc>().add(
                      AddInventory(nameController.text),
                    );
                    context.read<InventoryBloc>().add(LoadInventories());
                  }
                  Navigator.pop(context);
                },
                child: Text('Agregar'),
              ),
            ],
          ),
    );
  }

  void _showEditDialog(BuildContext context, int id, String currentName) {
  TextEditingController nameController = TextEditingController(
    text: currentName,
  );
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Editar Inventario'),
      content: TextField(
        controller: nameController,
        decoration: InputDecoration(hintText: 'Nuevo Nombre'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty) {
              context.read<InventoryBloc>().add(
                UpdateInventory(id: id, newName: nameController.text),
              );
              Navigator.pop(context);
            }
          },
          child: Text('Guardar'),
        ),
      ],
    ),
  );
}

}
