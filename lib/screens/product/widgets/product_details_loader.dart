import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget build_product_details_loading() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 24,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              width: 100,
              height: 24,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Container(
                  width: 100,
                  height: 24,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Container(
                  width: 150,
                  height: 24,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 24,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.white,
            ),
            SizedBox(height: 30),
            Center(
              child: Container(
                width: 200,
                height: 50,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
