import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezda/controller/onboard&splashController/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Image.asset('assets/icons/splash_icon.png',
            width: 150, height: 150),
      ),
    );
  }
}
