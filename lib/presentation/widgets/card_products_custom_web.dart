import 'package:flutter/material.dart';

class CardProductCustomWeb extends StatelessWidget {
  const CardProductCustomWeb({
    super.key,
    required this.height,
    required this.width,
    required this.name,
    required this.barcode,
    required this.cant,
    required this.price,
    required this.onEdit,
    required this.onDelete,
  });

  final double height;
  final double width;
  final String name;
  final String barcode;
  final int cant;
  final int price;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.008, horizontal: width * 0.04),
      padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.018),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 1.0)],
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.038,
            height: height * 0.08,
            decoration: BoxDecoration(
            color: Colors.blueAccent.shade100,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Icon(Icons.image, color: Colors.white,)),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(name), Text(barcode), Text('Cantidad: $cant'), Text('Precio: \$${price}')],
          ),
          Spacer(),
          IconButton(onPressed: onEdit, icon: Icon(Icons.edit, color: Colors.blueAccent)),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete_outline, color: Colors.redAccent)),
        ],
      ),
    );
  }
}
