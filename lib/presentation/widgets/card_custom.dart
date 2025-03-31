import 'package:flutter/material.dart';

class CardCustom extends StatelessWidget {
  const CardCustom({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.cant,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final double height;
  final double width;
  final String title;
  final String cant;
  final GestureTapCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.035, vertical: height * 0.005),
        alignment: Alignment.center,
        height: height * 0.12,
        width: width * 0.99,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          //border: Border.all(width: 1, color: Colors.blueAccent),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0)]
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.2086,
                height: height * 0.0508,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white70,
                ),
                child: Icon(Icons.inventory_2_outlined, color: Colors.blueAccent),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  Text(cant, style: TextStyle(color: Colors.black)),
                  Row(
                    children: [
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
