import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tezda/routes/app_route.dart';

class SplashController extends GetxController {
  final GetStorage _storage = GetStorage();
  final String _onboardingKey = 'onboardingShown';
  static String accessTokenKey = "accessToken";
  static String refreshTokenKey = "RefreshToken";

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {
      bool hasSeenOnboarding = _storage.read(_onboardingKey) ?? false;

      print(hasSeenOnboarding);

      if (hasSeenOnboarding) {
        print("hi");
        final String? access_token = _storage.read(accessTokenKey);
        final String? refresh_token = _storage.read(refreshTokenKey);
        if (access_token == null ||
            access_token.isEmpty ||
            refresh_token == null ||
            refresh_token.isEmpty) {
          print("h1");
          print(access_token);
          print(refresh_token);

          Get.offAllNamed(AppRoute.loginRoute);
        } // Replace with your home route
        else {
          print("hi2");

          Get.offAndToNamed(AppRoute.homeRoute);
        }
      } else {
        print("hi3");

        // _storage.write(_onboardingKey, true);
        Get.offAllNamed(AppRoute.onBoardScreen);
      }
    });
  }
}
