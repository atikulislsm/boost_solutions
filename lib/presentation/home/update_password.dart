import 'package:boost_solutions/presentation/auth/login.dart';
import 'package:boost_solutions/presentation/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _LogInState();
}

class _LogInState extends State<UpdatePassword> {

  final GetStorage storage = GetStorage();
  final AuthController authController = Get.put(AuthController());

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController verifyPasswordController = TextEditingController();

  // Function to update the password
  Future<void> updatePassword(String oldPassword, String newPassword, String confirmPassword) async {
    const String baseUrl = "https://boost.mohasagorit.solutions/api/password/update"; // Replace with your actual base URL
    String  token= await storage.read('token');
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',

        },
        body: jsonEncode({
          'old_password': oldPassword,
          'password': newPassword,
          'c_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status']) {
          Get.snackbar("Success", "Password updated successfully.");
          storage.remove('token');
          Get.offAll(const LogIn());
        } else {
          Get.snackbar("Error", responseData['message'] ?? "Failed to update password.");
        }
      } else {
        Get.snackbar("Error", "Server error. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(240.h),
          child: Container(
            height: 240.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF0532D), Color(0xFF0B3C54)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(120 * 3.141592653589793 / 180),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
                 Positioned(
                  left: 25,
                    top: 50,
                    child: GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back,color: Colors.white,))
                )
              ],
            )
          ),
      ),
      body: ListView(
        children: [
          
          SizedBox(height: 30.h),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Old Password',
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
                String oldPassword = passwordController.text.trim();
                String newPass = newPasswordController.text.trim();
                String verifyPass = verifyPasswordController.text.trim();

                if (oldPassword.isEmpty || newPass.isEmpty || verifyPass.isEmpty) {
                  Get.snackbar("Error", "Please fill in all fields.");
                  return;
                }

                if (newPass != verifyPass) {
                  Get.snackbar("Error", "New Password and Confirm Password do not match.");
                  return;
                }

                await updatePassword(oldPassword, newPass, verifyPass);
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
