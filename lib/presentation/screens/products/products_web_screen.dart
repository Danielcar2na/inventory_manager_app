import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc_web.dart';
import 'package:inventory_manager/presentation/widgets/card_products_custom_web.dart';

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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('P R O D U C T S', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 40,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.04),
              const Text(
                'P R O D U C T S   L I S T',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: height * 0.04),
              BlocBuilder<ProductBlocWeb, ProductStateWeb>(
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

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: products.map((product) {
                        return CardProductCustomWeb(
                          height: height,
                          width: width * 0.3,
                          name: product.name,
                          barcode: product.barcode ?? '',
                          cant: product.quantity,
                          price: product.price.toInt(),
                          onEdit: () => _showEditProductDialog(context, product),
                          onDelete: () => _deleteProduct(product.id),
                        );
                      }).toList(),
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text('Cargando...'));
                },
              ),
            ],
          ),
        ),
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
