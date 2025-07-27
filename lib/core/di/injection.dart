import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../features/bookfinder/data/data_source/database/database_helper.dart';

import 'injection.config.dart'; // This will be generated

/*
We define Dio and HiveService manually in @module classes because:
--- Dio is from a third-party package
-- HiveService is a singleton with a private constructor and a static instance getter.

GetIt is a service locator. This line creates a singleton instance that will be used throughout
the app to register and retrieve dependencies.

getIt<HiveService>().openBoxes():
After DI is set up, this line fetches the HiveService instance from GetIt and opens Hive boxes
 */
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  await getIt<HiveService>().openBoxes();
}

@module
abstract class CoreModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  HiveService get hiveService => HiveService.instance;
}
