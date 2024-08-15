// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tezda/api_helper.dart';
// import 'package:tezda/models/single_product_model.dart';

// class ProductController extends GetxController {
//   final int productId;

//   // Constructor to accept the productId
//   ProductController({required this.productId});

//   // Observable single product using Rx and nullable type
//   Rx<SingleProduct?> singleProduct = Rx<SingleProduct?>(null);

//   // Loading state
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProductById(productId); // Fetch product details using the passed ID
//   }

//   // Fetch a single product by ID
//   Future<void> fetchProductById(int id) async {
//     isLoading.value = true;
//     try {
//       final response = await ApiProvider.request(
//         RequestType.GET,
//         'products/$id',
//         null,
//       );

//       if (response.statusCode == 200) {
//         final productJson = jsonDecode(response.response.body);
//         singleProduct.value = SingleProduct.fromJson(productJson);
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to fetch product details',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e, stree) {
//       print(stree);
//       catchMatcher(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezda/api_helper.dart';
import 'package:tezda/models/single_product_model.dart';

class ProductController extends GetxController {
  final int productId;

  ProductController({required this.productId});

  Rx<SingleProduct?> singleProduct = Rx<SingleProduct?>(null);
  var isLoading = false.obs;
  RxBool isFavorite = false.obs;
  RxInt favoriteCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductById(productId);
  }

  Future<void> fetchProductById(int id) async {
    isLoading.value = true;
    try {
      final response = await ApiProvider.request(
        RequestType.GET,
        'products/$id',
        null,
      );

      if (response.statusCode == 200) {
        final productJson = jsonDecode(response.response.body);
        singleProduct.value = SingleProduct.fromJson(productJson);
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch product details',
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
}
