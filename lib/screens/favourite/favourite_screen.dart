import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tezda/controller/favourite/favourite_controller.dart';
import 'package:tezda/routes/app_route.dart';
import 'package:tezda/screens/dashboard/widgets/image_popup_view.dart';

class FavoriteScreen extends StatelessWidget {
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Products"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (favoriteController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (favoriteController.favoriteProducts.isEmpty) {
          return Center(
            child: Text(
              'No favorite products found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: favoriteController.favoriteProducts.length,
          itemBuilder: (context, index) {
            final product = favoriteController.favoriteProducts[index];
            return InkWell(
              onTap: () => Get.toNamed(AppRoute.productDetailRoute,
                  arguments: product.id),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showImagePopup(
                              context, product.images[0]); // Show first image
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              product.images[0], // Display the first image
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 8,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "\$${product.price}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                      Obx(() => IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: favoriteController
                                      .isFavorite(product.id.toString())
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              favoriteController
                                  .toggleFavorite(product.id.toString());
                            },
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
