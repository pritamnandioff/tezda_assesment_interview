import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tezda/controller/authController/user_controller.dart';
import 'package:tezda/routes/app_route.dart';
import 'package:tezda/utils/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _userController.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome'.tr.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Good to see you!'.tr,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Lottie.asset("assets/animations/login.json"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _userController.usernameController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_userController.passwordFocusNode);
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        errorStyle: const TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                      ),
                      validator: _userController.validateUsername,
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => TextFormField(
                        controller: _userController.passwordController,
                        focusNode: _userController.passwordFocusNode,
                        obscureText: _userController.isObscureText.value,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _userController.login(),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          errorStyle: const TextStyle(color: Colors.yellow),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 16.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _userController.isObscureText.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: _userController.toggleObscureText,
                          ),
                        ),
                        validator: _userController.validatePassword,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => CustomElevatedButton(
                        text: "Login",
                        isLoading: _userController.isLoading.value,
                        onPressed: _userController.login,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.toNamed(AppRoute.signUpRoute),
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Don\'t have a account  ',
                                style: TextStyle(
                                  color: Colors.yellow,
                                )),
                            TextSpan(
                                text: 'SignUp',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
