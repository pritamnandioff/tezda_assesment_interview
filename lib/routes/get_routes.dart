import 'package:get/get.dart';
import 'package:tezda/routes/app_route.dart';
import 'package:tezda/screens/authScreens/login_screeen.dart';
import 'package:tezda/screens/authScreens/signup_screen.dart';
import 'package:tezda/screens/dashboard/home_screen.dart';
import 'package:tezda/screens/favourite/favourite_screen.dart';
import 'package:tezda/screens/product/product_details_screen.dart';
import 'package:tezda/screens/sub_screen/onboarding_screen.dart';
import 'package:tezda/screens/sub_screen/splash_screen.dart';

class GetAppRoute {
  List<GetPage> getRouters() {
    return [
      GetPage(
        name: AppRoute.initialRoute,
        page: () => SplashScreen(),
        transition: Transition.leftToRightWithFade,
      ),
      GetPage(
        name: AppRoute.onBoardScreen,
        page: () => OnboardingScreen(),
        transition: Transition.leftToRightWithFade,
      ),
      //Auth Screen
      GetPage(
        name: AppRoute.loginRoute,
        page: () => LoginScreen(),
        transition: Transition.leftToRightWithFade,
      ),
      GetPage(
        name: AppRoute.signUpRoute,
        page: () => SignUpScreen(),
        transition: Transition.leftToRightWithFade,
      ),
      //dashboard
      GetPage(
        name: AppRoute.homeRoute,
        page: () => HomeScreen(),
        transition: Transition.leftToRightWithFade,
      ),
      GetPage(
        name: AppRoute.productDetailRoute,
        page: () => ProductDetailsScreen(),
        transition: Transition.leftToRightWithFade,
      ),
      GetPage(
        name: AppRoute.favoriteProductsRoute,
        page: () => FavoriteScreen(),
        transition: Transition.leftToRightWithFade,
      ),
    ];
  }
}
