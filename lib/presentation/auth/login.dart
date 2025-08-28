import 'package:boost_solutions/presentation/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import 'forget_password.dart';



class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthController authController = Get.put(AuthController()); // Initialize AuthController
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(240.h),
          child: Container(
            height: 240.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF0532D),
                  Color(0xFF0B3C54),
                ],
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
      ),
      body: ListView(
        children: [

          SizedBox(height: 30.h),
          // Mobile Number Field
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: phoneController, // Capture phone number
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '01*********',
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Password Field
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: passwordController, // Capture password
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
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
          // Login Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () async {
                String phone = phoneController.text.trim();
                String password = passwordController.text.trim();

                if (phone.isEmpty || password.isEmpty) {
                  Get.snackbar("Error", "Please fill in both fields.");
                  return;
                }

                // Perform login
                await authController.login(phone, password);

                // Check login status
                if (authController.isLoggedIn()) {
                  Get.snackbar("Success", "Login Successful!");
                  authController.fetchUser();
                  Get.offAll(() => const HomeScreen()); // Navigate to HomeScreen
                } else {
                  Get.snackbar("Error", "Invalid phone number or password.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B3C54),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          // Forgot Password Link
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const ForgetPassword());
              },
              child: Center(
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
