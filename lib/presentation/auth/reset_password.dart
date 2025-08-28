import 'package:boost_solutions/presentation/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatefulWidget {
  final String phone;
  const ResetPassword({super.key, required this.phone});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController verifyPasswordController = TextEditingController();

  // Function to reset the password
  Future<void> resetPassword(String phone, String newPassword, String confirmPassword) async {
    const String baseUrl = "https://boost.mohasagorit.solutions/api/reset/password"; // Replace with your actual base URL

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == true) {
        Get.snackbar("Success", responseData['message'] ?? "Password updated successfully.");
        // Redirect to the login screen
        Get.offAll(() => const LogIn());
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Failed to reset password.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 240.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF0532D), Color(0xFF0B3C54)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(120 * 3.141592653589793 / 180),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          SizedBox(height: 30.h),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'New Password',
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: verifyPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () async {
                String newPass = newPasswordController.text.trim();
                String verifyPass = verifyPasswordController.text.trim();

                if (newPass.isEmpty || verifyPass.isEmpty) {
                  Get.snackbar("Error", "Please fill in all fields.");
                  return;
                }

                if (newPass != verifyPass) {
                  Get.snackbar("Error", "New Password and Confirm Password do not match.");
                  return;
                }

                await resetPassword(widget.phone, newPass, verifyPass);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B3C54),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Update Password', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
