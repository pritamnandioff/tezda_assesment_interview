//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tezda/api_helper.dart';
import 'package:tezda/models/single_product_model.dart';

class FavoriteController extends GetxController {
  var favoriteCount = 0.obs;
  final GetStorage _storage = GetStorage();
  RxSet<String> favoriteItems = <String>{}.obs;
  RxList<SingleProduct> favoriteProducts = <SingleProduct>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavoriteItems();
  }

  void _loadFavoriteItems() {
    // Fix: Ensure reading from local storage correctly and initialize with an empty list if null
    final List<dynamic>? storedItems =
        _storage.read<List<dynamic>>('favoriteItems');
    if (storedItems != null) {
      favoriteItems.addAll(storedItems.map((item) => item.toString()).toSet());
    }
    favoriteCount.value = favoriteItems.length;
    fetchFavoriteProducts();
  }

  bool isFavorite(String productId) {
    return favoriteItems.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (favoriteItems.contains(productId)) {
      favoriteItems.remove(productId);
      favoriteProducts
          .removeWhere((product) => product.id.toString() == productId);
    } else {
      favoriteItems.add(productId);
      fetchProductById(productId);
    }
    _storage.write('favoriteItems', favoriteItems.toList());
    favoriteCount.value = favoriteItems.length;
  }

  Future<void> fetchFavoriteProducts() async {
    isLoading.value = true;
    favoriteProducts.clear();
    for (String id in favoriteItems) {
      await fetchProductById(id);
    }
    isLoading.value = false;
  }

  Future<void> fetchProductById(String id) async {
    try {
      final response = await ApiProvider.request(
        RequestType.GET,
        'products/$id',
        null,
      );

      if (response.statusCode == 200) {
        final productJson = jsonDecode(response.response.body);
        favoriteProducts.add(SingleProduct.fromJson(productJson));
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
      Get.snackbar(
        'Error',
        'An error occurred while fetching product details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
