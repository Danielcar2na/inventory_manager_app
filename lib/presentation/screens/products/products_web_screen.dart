import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc_web.dart';
import 'package:inventory_manager/presentation/widgets/card_products_custom.dart';

class ProductsWebScreen extends StatefulWidget {
  final int inventoryId;

  const ProductsWebScreen({Key? key, required this.inventoryId}) : super(key: key);

  @override
  State<ProductsWebScreen> createState() => _ProductsWebScreenState();
}

class _ProductsWebScreenState extends State<ProductsWebScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBlocWeb>().add(LoadProducts(inventoryId: widget.inventoryId));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Productos del Inventario (Web)')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<ProductBlocWeb, ProductStateWeb>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products
                .where((p) => p.inventoryId == widget.inventoryId)
                .toList();

            if (products.isEmpty) {
              return const Center(child: Text('No hay productos en este inventario'));
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.2,
                children: products.map((product) {
                  return CardProductCustom(
                    height: screenSize.height,
                    width: screenSize.width,
                    name: product.name,
                    barcode: product.barcode ?? '',
                    cant: product.quantity,
                    price: product.price.toInt(),
                    onEdit: () => _showEditProductDialog(context, product),
                    onDelete: () => _deleteProduct(product.id),
                  );
                }).toList(),
              ),
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('Cargando...'));
        },
      ),
    );
  }

  void _deleteProduct(int productId) {
    context.read<ProductBlocWeb>().add(
      DeleteProduct(productId: productId, inventoryId: widget.inventoryId),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final barcodeController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Producto'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: barcodeController, decoration: const InputDecoration(labelText: 'Código de barras')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Cantidad'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final barcode = barcodeController.text;
              final price = double.tryParse(priceController.text) ?? 0;
              final quantity = int.tryParse(quantityController.text) ?? 0;

              if (name.isNotEmpty && barcode.isNotEmpty && price > 0 && quantity > 0) {
                context.read<ProductBlocWeb>().add(
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
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, dynamic product) {
    final nameController = TextEditingController(text: product.name);
    final barcodeController = TextEditingController(text: product.barcode);
    final priceController = TextEditingController(text: product.price.toString());
    final quantityController = TextEditingController(text: product.quantity.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Producto'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: barcodeController, decoration: const InputDecoration(labelText: 'Código de barras')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Cantidad'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final barcode = barcodeController.text;
              final price = double.tryParse(priceController.text) ?? 0;
              final quantity = int.tryParse(quantityController.text) ?? 0;

              if (name.isNotEmpty && barcode.isNotEmpty && price > 0 && quantity > 0) {
                context.read<ProductBlocWeb>().add(
                  DeleteProduct(productId: product.id, inventoryId: widget.inventoryId),
                );
                context.read<ProductBlocWeb>().add(
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
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
