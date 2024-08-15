import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tezda/routes/app_route.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;
  final String _onboardingKey = 'onboardingShown';
  final GetStorage _storage = GetStorage();

  final int numPages = 3;

  void nextPage() {
    if (currentPage.value < numPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      _storage.write(_onboardingKey, true);

      Get.offAllNamed(AppRoute.loginRoute); // Navigate to the login route
    }
  }

  Widget buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isCurrentPage ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
