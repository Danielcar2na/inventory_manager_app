import 'package:get_it/get_it.dart';
import 'package:inventory_manager/data/repositories/inventory_repository_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(sharedPreferences);
  locator.registerLazySingleton<InventoryRepositoryPrefs>(
    () => InventoryRepositoryPrefs(sharedPreferences: locator()),
  );
}
