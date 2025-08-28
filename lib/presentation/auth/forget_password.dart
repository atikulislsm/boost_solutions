import 'package:boost_solutions/presentation/auth/verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> sendResetCode(String phone) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://boost.mohasagorit.solutions/api/reset/code'), // Replace with your base URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': phone}),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == true) {
        Get.snackbar("Success", responseData['message'] ?? "OTP sent successfully.");
        Get.off(() => VerifyScreen(phone: phone)); // Pass phone to VerifyScreen
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Failed to send OTP.");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
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
          SizedBox(height: 30.h),
          // Mobile Number Field
          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: phoneController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Go Ahead Button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  sendResetCode(phoneController.text.trim());
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
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Go Ahead', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
