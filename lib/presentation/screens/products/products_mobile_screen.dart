import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/presentation/widgets/card_products_custom.dart';
import '../../../logic/bloc/product/product_bloc.dart';

class ProductsMobile extends StatefulWidget {
  final int inventoryId;

  const ProductsMobile({Key? key, required this.inventoryId}) : super(key: key);

  @override
  _ProductsMobileState createState() => _ProductsMobileState();
}

class _ProductsMobileState extends State<ProductsMobile> {
  @override
  void initState() {
    super.initState();
    // Cargar productos cuando se entra a la pantalla
    context.read<ProductBloc>().add(LoadProducts(inventoryId: widget.inventoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos del Inventario')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductPopup(context),
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products.where((p) => p.inventoryId == widget.inventoryId).toList();

            if (products.isEmpty) {
              return Center(child: Text('No hay productos en este inventario'));
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return CardProductCustom(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  name: product.name,
                  barcode: product.barcode.toString(),
                  cant: product.quantity,
                  price: product.price.toInt(),
                  onEdit: () => _showEditProductPopup(context, product),
                  onDelete: () => _deleteProduct(product.id),
                );
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Cargando...'));
        },
      ),
    );
  }

  void _deleteProduct(int productId) {
    context.read<ProductBloc>().add(DeleteProduct(productId: productId, inventoryId: widget.inventoryId));
  }

  void _showAddProductPopup(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController barcodeController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: barcodeController, decoration: InputDecoration(labelText: 'Código de barras')),
              TextField(controller: priceController, decoration: InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              TextField(controller: quantityController, decoration: InputDecoration(labelText: 'Cantidad'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final barcode = barcodeController.text;
                final price = double.tryParse(priceController.text) ?? 0;
                final quantity = int.tryParse(quantityController.text) ?? 0;

                if (name.isNotEmpty && barcode.isNotEmpty && price > 0 && quantity > 0) {
                  context.read<ProductBloc>().add(
                    AddProduct(
                      name: name,
                      barcode: barcode,
                      price: price,
                      quantity: quantity,
                      inventoryId: widget.inventoryId,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductPopup(BuildContext context, dynamic product) {
    final TextEditingController nameController = TextEditingController(text: product.name);
    final TextEditingController barcodeController = TextEditingController(text: product.barcode);
    final TextEditingController priceController = TextEditingController(text: product.price.toString());
    final TextEditingController quantityController = TextEditingController(text: product.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: barcodeController, decoration: InputDecoration(labelText: 'Código de barras')),
              TextField(controller: priceController, decoration: InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              TextField(controller: quantityController, decoration: InputDecoration(labelText: 'Cantidad'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final updatedName = nameController.text;
                final updatedBarcode = barcodeController.text;
                final updatedPrice = double.tryParse(priceController.text) ?? 0;
                final updatedQuantity = int.tryParse(quantityController.text) ?? 0;

                if (updatedName.isNotEmpty && updatedBarcode.isNotEmpty && updatedPrice > 0 && updatedQuantity > 0) {
                  context.read<ProductBloc>().add(DeleteProduct(productId: product.id, inventoryId: widget.inventoryId));
                  context.read<ProductBloc>().add(
                    AddProduct(
                      name: updatedName,
                      barcode: updatedBarcode,
                      price: updatedPrice,
                      quantity: updatedQuantity,
                      inventoryId: widget.inventoryId,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
