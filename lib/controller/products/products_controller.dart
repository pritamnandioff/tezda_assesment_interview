// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tezda/const/api_const.dart';
// import 'package:tezda/models/products_model.dart';
// import '../../api_helper.dart';

// class ProductsController extends GetxController {
//   // Observable list of products using Rx and nullable types
//   Rx<List<Product>?> products = Rx<List<Product>?>(null);

//   // Loading state
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     fetchProducts(); // Fetch all products on controller initialization
//     super.onInit();
//   }

//   // Fetch all products
//   Future<void> fetchProducts() async {
//     isLoading.value = true;
//     try {
//       final response = await ApiProvider.request(
//         RequestType.GET,
//         ApiConstants.getProducts,
//         null,
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> productJson = jsonDecode(response.response.body);
//         products.value =
//             productJson.map((json) => Product.fromJson(json)).toList();
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to fetch products',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       catchMatcher(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezda/const/api_const.dart';
import 'package:tezda/models/products_model.dart';
import '../../api_helper.dart';

class ProductsController extends GetxController {
  // Observable list of products using Rx and nullable types
  Rx<List<Product>?> products = Rx<List<Product>?>(null);

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchProducts(); // Fetch all products on controller initialization
    super.onInit();
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      final response = await ApiProvider.request(
        RequestType.GET,
        ApiConstants.getProducts,
        null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> productJson = jsonDecode(response.response.body);
        products.value =
            productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch products',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stree) {
      print(stree);
      catchMatcher(e);
    } finally {
      isLoading.value = false;
    }
  }
}
