import 'package:boost_solutions/controller/AppController.dart';
import 'package:boost_solutions/controller/auth_controller.dart';
import 'package:boost_solutions/presentation/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
   CustomBottomNavigationBar({super.key});

  AppController appController = Get.find();
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home_outlined, size: 30),
              onPressed: () {

              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 30),
              onPressed: () {
                // Refresh action
                appController.dollarRequests.clear();
                appController.fetchApiResponse();
              },
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new, size: 30),
              onPressed: () {
                // Handle logout
                authController.logout();
                Get.offAll(const LogIn());
              },
            ),
          ],
        ),
      ),
    );
  }
}
