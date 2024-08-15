import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezda/controller/favourite/favourite_controller.dart';
import 'package:tezda/controller/products/product_controller.dart';
import 'package:tezda/routes/app_route.dart';
import 'package:tezda/screens/product/widgets/product_details_loader.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int productId = Get.arguments;

    final ProductController productController =
        Get.put(ProductController(productId: productId));
    final FavoriteController _favouriteController =
        Get.put(FavoriteController());

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Obx(
          () => Text(
            productController.singleProduct.value?.title ?? 'Product Details',
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Get.toNamed(AppRoute.favoriteProductsRoute),
            child: Obx(
              () => badges.Badge(
                badgeContent: Text(
                  _favouriteController.favoriteCount.value.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Icon(Icons.favorite_outline),
              ),
            ),
          ),
          SizedBox(width: 30),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return build_product_details_loading();
        }

        final product = productController.singleProduct.value;

        if (product == null) {
          return Center(
            child: Text(
              'Product not found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => productController.fetchProductById(productId),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageCarousel(product.images),
                  SizedBox(height: 20),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: _favouriteController
                                      .isFavorite(product.id.toString())
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => _favouriteController
                                .toggleFavorite(product.id.toString()),
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        product.category.capitalizeFirst!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImageCarousel(List<String> images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: images.map((imageUrl) {
        return GestureDetector(
          onTap: () {
            _showImagePopup(imageUrl);
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showImagePopup(String imageUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
