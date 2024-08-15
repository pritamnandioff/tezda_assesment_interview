import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tezda/api_helper.dart';
import 'package:tezda/const/api_const.dart';
import 'package:tezda/routes/app_route.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GetStorage _getStorage = GetStorage();
  final String userId = "TezdaUserId";

  // Controllers and Focus Nodes
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  var isLoading = false.obs;
  var isPasswordObscure = true.obs;
  var isConfirmPasswordObscure = true.obs;

  // Static Avatar URL
  final String avatarUrl = "https://api.lorem.space/image/face?w=640&h=480";

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordObscure.value = !isPasswordObscure.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscure.value = !isConfirmPasswordObscure.value;
  }

  // Sign Up Method
  void signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final Map<String, dynamic> body = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "avatar": avatarUrl,
      "role": "customer", // Assuming role is required and set to "customer"
    };

    try {
      final response = await ApiProvider.request(
        RequestType.POST,
        ApiConstants.signUp,
        body,
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.response.body);

        // Save the user ID in GetStorage
        _getStorage.write(userId, responseData['id']);

        Get.snackbar(
          'Success',
          'Account created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoute.loginRoute);
      } else {
        Get.snackbar(
          'Error',
          'Failed to create account',
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
  }

  @override
  void onClose() {
    // Dispose of controllers and focus nodes to avoid memory leaks
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    nameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}
