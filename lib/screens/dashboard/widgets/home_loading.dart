import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect() {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return SizedBox(
        height: 150,
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.white,
              ),
              title: Container(
                height: 10,
                width: double.infinity,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 10,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    },
  );
}
