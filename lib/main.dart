import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tezda/routes/app_route.dart';
import 'package:tezda/routes/get_routes.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tezda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(),
      ),
      debugShowCheckedModeBanner: false,
      getPages: GetAppRoute().getRouters(),
      initialRoute: AppRoute.initialRoute,
    );
  }
}
