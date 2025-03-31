// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:inventory_manager/logic/bloc/inventory/inventory_bloc.dart';
// import 'package:inventory_manager/logic/bloc/inventory/inventory_state.dart';

// class InventoryWebScreen extends StatelessWidget {
//   const InventoryWebScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Inventario Web')),
//       body: BlocBuilder<InventoryBloc, InventoryState>(
//         builder: (context, state) {
//           if (state is InventoryLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is InventoryLoaded) {
//             return DataTable(
//               columns: const [
//                 DataColumn(label: Text('ID')),
//                 DataColumn(label: Text('Nombre')),
//                 DataColumn(label: Text('Cantidad')),
//               ],
//               rows: state.inventories.map((inventory) {
//                 return DataRow(cells: [
//                   DataCell(Text(inventory.id)),
//                   DataCell(Text(inventory.name)),
//                   DataCell(Text(inventory.quantity.toString())),
//                 ]);
//               }).toList(),
//             );
//           } else {
//             return const Center(child: Text('Error al cargar inventario'));
//           }
//         },
//       ),
//     );
//   }
// }
