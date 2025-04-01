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

  if (kIsWeb) {
    final prefs = await SharedPreferences.getInstance();
    final inventoryRepo = InventoryRepositoryPrefs(sharedPreferences: prefs);
    final productRepo = ProductRepositorySharedPref(sharedPreferences: prefs);

    runApp(MyApp.web(
      inventoryRepository: inventoryRepo,
      productRepository: productRepo,
    ));
  } else {
    final database = AppDatabase();
    runApp(MyApp.mobile(appDatabase: database));
  }
}

class MyApp extends StatelessWidget {
  final AppDatabase? appDatabase;
  final InventoryRepository? inventoryRepository;
  final ProductRepository? productRepository;

  const MyApp.mobile({Key? key, required this.appDatabase})
      : inventoryRepository = null,
        productRepository = null,
        super(key: key);

  const MyApp.web({
    Key? key,
    required this.inventoryRepository,
    required this.productRepository,
  })  : appDatabase = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        if (kIsWeb)
          BlocProvider(
              create: (_) => InventoryBlocWeb(repository: inventoryRepository!))
        else
        //   BlocProvider(
        //       create: (_) => InventoryBloc(database: appDatabase!)),

        // if (kIsWeb)
          BlocProvider(
              create: (_) => ProductBlocWeb(repository: productRepository!))
        // else
        //   BlocProvider(create: (_) => ProductBloc(database: appDatabase!)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventario',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: InventoryScreen(),
      ),
    );
  }
}
