import 'package:boost_solutions/controller/auth_controller.dart';
import 'package:boost_solutions/presentation/coming_soon.dart';
import 'package:boost_solutions/presentation/home/update_password.dart';
import 'package:boost_solutions/presentation/term.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../ProfileUpdate.dart';

class CustomAppBar extends StatelessWidget {

  final AuthController _authController = Get.put(AuthController());

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF0532D),
            Color(0xFF0B3C54),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin:  EdgeInsets.only(left: 5.w),
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.grey[300],
              child:  Icon(Icons.person, size: 22.r, color: Colors.white),
            ),
          ),
          SizedBox(width: 7.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(const ProfileUpdate());
                    },
                      child: _buildProfileButton("Profile Update")
                  ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                      onTap: (){
                        Get.to(()=>const UpdatePassword());
                      },
                      child: _buildProfileButton("Password Update")),
                ],
              ),
              SizedBox(height: 8.h),
              Obx((){
                return  Text(
                  _authController.userModel.value.name ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              })

            ],
          ),
          const Spacer(),
          Container(
            margin: EdgeInsets.only(right: 7.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap:(){
                    Get.to(()=> ComingSoonScreen());
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.notification_important,color: Colors.white,),
                      const SizedBox(width: 5,),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                GestureDetector(
                  onTap: () {
                    Get.to(()=> const TermScreen());
                  },
                  child: Text(
                    'Terms & Condition',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildProfileButton(String text) {
    return Container(
      width: 85.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.blue.shade900),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 8.5.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
