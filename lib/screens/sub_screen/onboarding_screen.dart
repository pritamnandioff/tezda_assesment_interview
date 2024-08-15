import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezda/controller/onboard&splashController/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Lorem Ipsum 1",
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      "image": "assets/icons/placeholder1.png",
    },
    {
      "title": "Lorem Ipsum 2",
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry..",
      "image": "assets/icons/placeholder2.png",
    },
    {
      "title": "Lorem Ipsum 3",
      "description":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
      "image": "assets/icons/placeholder3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: (int page) {
                  controller.currentPage.value = page;
                },
                itemCount: controller.numPages,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        onboardingData[index]["image"]!,
                        height: 300.0,
                        width: 300.0,
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        onboardingData[index]["title"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        onboardingData[index]["description"]!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Obx(
                    () =>
                        controller.currentPage.value != controller.numPages - 1
                            ? TextButton(
                                onPressed: controller.nextPage,
                                child: const Text(
                                  "NEXT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: controller.nextPage,
                                child: const Text(
                                  "GET STARTED",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                  ),
                  Row(
                    children: List.generate(controller.numPages, (index) {
                      return Obx(() => controller.buildPageIndicator(
                          index == controller.currentPage.value));
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
