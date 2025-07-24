import 'package:flutter/material.dart';
import 'config/route/route.dart';
import 'config/theme/theme.dart';
import 'core/di/injection.dart';
import 'features/bookfinder/data/data_source/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Book Finder',
      theme: AppTheme.themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}