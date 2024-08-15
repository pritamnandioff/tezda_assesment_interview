import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tezda/api_helper.dart';
import 'package:tezda/const/api_const.dart';
import 'package:tezda/routes/app_route.dart';

class UserController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode passwordFocusNode = FocusNode();
  final GetStorage _getStorage = GetStorage();
  static String accessTokenKey = "accessToken";
  static String refreshTokenKey = "RefreshToken";
  var userData = {}.obs;
  var isLoading = false.obs;
  var isObscureText = true.obs;

  void toggleObscureText() {
    isObscureText.value = !isObscureText.value;
  }

  // Function to validate the username field
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty'.tr;
    } else if (value.length < 3) {
      return 'Username must be at least 3 characters'.tr;
    }
    return null;
  }

  // Function to validate the password field
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty'.tr;
    } else if (value.length < 4) {
      return 'Password must be at least 6 characters'.tr;
    }
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    final Map<String, dynamic> body = {
      "email": usernameController.text.trim(),
      "password": passwordController.text.trim(),
    };
    try {
      final response = await ApiProvider.request(
        RequestType.POST,
        ApiConstants.logIn,
        body,
      );

      if (response.statusCode == 201) {
        userData.value = jsonDecode(response.response.body);
        Get.offAllNamed(AppRoute.homeRoute);
        print(jsonDecode(response.response.body)["access_token"]);
        print(jsonDecode(response.response.body)["refresh_token"]);

        _getStorage.write(
            accessTokenKey, jsonDecode(response.response.body)["access_token"]);
        _getStorage.write(refreshTokenKey,
            jsonDecode(response.response.body)["refresh_token"]);

        Get.snackbar(
          'Success',
          'Logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch user data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      catchMatcher(e);
    } finally {
      isLoading.value = false;
    }
    // Get.offAllNamed(AppRoute.homeRoute);
  }
}
