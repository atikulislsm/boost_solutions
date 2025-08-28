import 'package:boost_solutions/presentation/auth/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyScreen extends StatefulWidget {
  final String phone;
  const VerifyScreen({super.key, required this.phone});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String otpCode = '';
  bool isLoading = false;

  Future<void> verifyOtp(String phone, String code) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://boost.mohasagorit.solutions/api/verify/code'), // Replace with your base URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': phone, 'code': code}),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == true) {
        Get.snackbar("Success", responseData['message'] ?? "OTP verified successfully.");
        // Navigate to the next screen or dashboard
        Get.off(ResetPassword(phone: phone,));
      } else {
        Get.snackbar("Error", responseData['message'] ?? "Invalid OTP. Please try again.");
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
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(48, 136, 205, 1.0)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

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
            child: Image.asset("assets/images/logo.png"),
          ),
          SizedBox(height: 30.h),

          const SizedBox(height: 16),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Pinput(
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              length: 6,
              onCompleted: (pin) {
                otpCode = pin;
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,

            ),
          ),
          const SizedBox(height: 16),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                if (otpCode.isNotEmpty) {
                  verifyOtp(widget.phone, otpCode);
                } else {
                  Get.snackbar("Error", "Please enter the OTP code.");
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
                  : const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
