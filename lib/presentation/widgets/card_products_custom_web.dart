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
      margin: EdgeInsets.symmetric(
        vertical: height * 0.008,
        horizontal: width * 0.04,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.08,
        vertical: height * 0.018,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 1.0)],
      ),
      child: Row(
        spacing: width * 0.2,
        children: [
          Container(
            width: width * 0.18,
            height: height * 0.08,
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.image, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600), ),
                Text('codigo: $barcode', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                  ],
                ),
                SizedBox(width: width * 0.6,),
                Column(
                  children: [
                    Text('Cantidad: $cant',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                Text('Precio: \$${price}',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit, color: Colors.blueAccent),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
