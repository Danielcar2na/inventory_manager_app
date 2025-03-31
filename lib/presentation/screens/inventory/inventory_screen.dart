import 'package:flutter/material.dart';
import 'package:inventory_manager/core/responsive_layout.dart';
import 'package:inventory_manager/presentation/screens/inventory/inventory_mobile_screen.dart';

class InventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: MobileInventoryScreen(),
      webBody: WebInventoryScreen(),
    );
  }
}

class MobileInventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InventoryMobileScreen();
  }
}

class WebInventoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventario Web")),
      body: Row(
        children: [
          Expanded(child: Text("Menú lateral")),
          Expanded(flex: 3, child: Center(child: Text("Lista de productos (Web)"))),
        ],
      ),
    );
  }
}
