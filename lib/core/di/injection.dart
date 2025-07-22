import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../features/bookfinder/data/data_source/database/database_helper.dart';

import 'injection.config.dart'; // This will be generated

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  await getIt<HiveService>().openBoxes();
}

@module
abstract class DioProvider {
  @lazySingleton
  Dio get dio => Dio();
}

@module
abstract class CoreModule {
  @lazySingleton
  HiveService get hiveService => HiveService.instance;
}