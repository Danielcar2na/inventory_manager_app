import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/data/database/app_database.dart';
import 'package:inventory_manager/logic/bloc/inventory/inventory_bloc.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc.dart';
import 'package:inventory_manager/presentation/screens/inventory/inventory_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDatabase = AppDatabase();

  runApp(MyApp(appDatabase: appDatabase));
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;

  const MyApp({Key? key, required this.appDatabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryBloc(database: appDatabase)),
        BlocProvider(create: (_) => ProductBloc(database: appDatabase)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventario',
        theme: ThemeData(primarySwatch: Colors.blue),
        home:  InventoryScreen(),
      ),
    );
  }
}
