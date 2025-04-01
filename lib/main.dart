import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager/data/repositories/inventory_repository_prefs.dart';
import 'package:inventory_manager/data/repositories/product/web/product_repository_sharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_manager/data/database/app_database.dart';
import 'package:inventory_manager/data/repositories/inventory_repository.dart';
import 'package:inventory_manager/data/repositories/product/web/produc_repository.dart';
import 'package:inventory_manager/logic/bloc/inventory/inventory_bloc.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc.dart';
import 'package:inventory_manager/logic/bloc/product/product_bloc_web.dart';
import 'package:inventory_manager/logic/bloc/inventory/inventory_bloc_web.dart';
import 'package:inventory_manager/presentation/screens/inventory/inventory_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final inventoryRepo = InventoryRepositoryPrefs(sharedPreferences: prefs);
  final productRepo = ProductRepositorySharedPref(sharedPreferences: prefs);

  runApp(MyApp(
    inventoryRepository: inventoryRepo,
    productRepository: productRepo,
  ));
}


class MyApp extends StatelessWidget {
  final InventoryRepository inventoryRepository;
  final ProductRepository productRepository;

  const MyApp({
    Key? key,
    required this.inventoryRepository,
    required this.productRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        kIsWeb
            ? BlocProvider(
                create: (_) =>
                    InventoryBlocWeb(repository: inventoryRepository))
            : BlocProvider(
                create: (_) => InventoryBloc(repository: inventoryRepository)),

        kIsWeb
            ? BlocProvider(
                create: (_) => ProductBlocWeb(repository: productRepository))
            : BlocProvider(
                create: (_) => ProductBloc(repository: productRepository)),
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
