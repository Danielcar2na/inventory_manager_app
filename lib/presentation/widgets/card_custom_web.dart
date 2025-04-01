import 'package:flutter/material.dart';

class CardCustomWeb extends StatelessWidget {
  const CardCustomWeb({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.id,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final double height;
  final double width;
  final String title;
  final String id;
  final GestureTapCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.005,
        ),
        alignment: Alignment.center,
        height: height * 0.12,
        width: width * 0.99,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1.0)],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.15086,
                height: height * 0.0808,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white70,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.blueAccent,
                ),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.02),
                      Expanded(
                        child: Text(
                          title.length > 16 ? title.substring(0, 16) : title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          id,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.10),

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
        ),
      ),
    );
  }
}
