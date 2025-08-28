import 'package:boost_solutions/presentation/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load user data into the text fields
    if (authController.userModel.value != null) {
      setUserData();
    } else {
      // Fetch user data if not available
      authController.fetchUser().then((_) => setUserData());
    }
  }

  // Set user data into the text fields
  void setUserData() {
    final user = authController.userModel.value;
    if (user != null) {
      nameController.text = user.name ?? '';
      companyNameController.text = user.companyName ?? '';
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
    }
  }

  // Function to update the profile
  Future<void> updateProfile(String name, String companyName, String phone, String address) async {
    final result = await authController.apiService.updateProfile({
      'name': name,
      'company_name': companyName,
      'phone': phone,
      'address': address,
    });
    print(result);
    if (result['status']) {
      Get.snackbar("Success", "Profile updated successfully.");
      await authController.fetchUser(); // Refresh user data after updating
      Get.off(const HomeScreen());
    } else {
      Get.snackbar("Error", result['message'] ?? "Failed to update profile.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor:  Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Name Field
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Company Name Field
          TextField(
            controller: companyNameController,
            decoration: InputDecoration(
              hintText: 'Company Name',
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Phone Field
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone',
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Address Field
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              hintText: 'Address',
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Update Button
          ElevatedButton(
            onPressed: () async {
              String name = nameController.text.trim();
              String companyName = companyNameController.text.trim();
              String phone = phoneController.text.trim();
              String address = addressController.text.trim();

              if (name.isEmpty || companyName.isEmpty || phone.isEmpty || address.isEmpty) {
                Get.snackbar("Error", "Please fill in all fields.");
                return;
              }

              await updateProfile(name, companyName, phone, address);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B3C54),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Update Profile', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
