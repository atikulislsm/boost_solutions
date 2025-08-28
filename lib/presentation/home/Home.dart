import 'package:boost_solutions/controller/auth_controller.dart';
import 'package:boost_solutions/presentation/home/widgets/CustomBottomNavigationBar.dart';
import 'package:boost_solutions/service/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../AddDollarRequestPage.dart';
import 'widgets/CustomAppBar.dart';
import 'widgets/DollarRequestCard.dart';
import '../../controller/AppController.dart';
import 'package:marquee/marquee.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:avatar_glow/avatar_glow.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppController controller = Get.put(AppController());
  final AuthController authController = Get.put(AuthController());
  String selectedTimeRange = "Maximum Time";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    authController.fetchUser();
    authController.fetchBalanceAndAccount();

    // Get device token
    _firebaseMessaging.getToken().then((token) async {
      if (kDebugMode) {
        print("FCM Token: $token");
      }
      try{
        ApiService apiService = ApiService();
        await apiService.updateToken(token!);
      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }

    });

  }

  final RefreshController refreshController = RefreshController();



  void onRefresh() async {
    await controller.refreshData();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    if (controller.currentPage.value < controller.totalPages.value) {
      await controller.loadMoreData();
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: CustomAppBar(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap:(){
                  showAccount();
                },
                child: Container(
                  width: 110.w,
                  height: 110.h,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: const Icon(Icons.account_balance,
                                  size: 30, color: Colors.blue),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(() {
                                  return Text(
                                    authController.balanceAndAccount.value.data !=
                                        null
                                        ? authController.balanceAndAccount.value
                                        .data!.addAccounts!.length
                                        .toString()
                                        : "",
                                    style:  TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.r,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Total Ad account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  controller.updateDateRange("status");
                },
                child: Container(
                  width: 110.w,
                  height: 110.h,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: const Icon(Icons.pending_actions,
                                  size: 30, color: Colors.blue),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Obx(() {
                                  return Text(
                                    controller.totalPending.value.toString(),
                                    style:  TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.r,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Pending request",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const AddDollarRequestPage());
                },
                child: _buildInfoCard(
                  icon: Icons.monetization_on,
                  label: 'Balance top up',
                  count: 3,
                  iconColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          SizedBox(
            width: 350.w,
            height: 30.h,
            child: Marquee(
              text:
              'Regular dollar top-up time 11:00 AM - 8:00 PM (7 days available ) |',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 100.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 3.0,
              accelerationDuration: const Duration(seconds: 3),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 1500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              child: DropdownButton<String>(
                value: selectedTimeRange,
                items: <String>[
                  "Maximum Time",
                  "Today",
                  "Yesterday",
                  "Last 7 days",
                  "Last 30 days",
                  "This month",
                  "This Year",
                  "Last Year"
                ]
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTimeRange = value!;
                  });
                  controller.updateDateRange(selectedTimeRange);
                },
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value &&
                controller.dollarRequests.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: SmartRefresher(
                controller: refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: onRefresh,
                onLoading: onLoading,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.dollarRequests.length,
                  itemBuilder: (context, index) {
                    var request = controller.dollarRequests[index];
                    return DollarRequestCard(request: request);
                  },
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required int count,
    required Color iconColor,
  }) {
    return Container(
      width: 110.w,
      height: 110.h,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarGlow(
              glowColor: iconColor.withOpacity(0.5),
              endRadius: 25.0,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              child: CircleAvatar(
                radius: 25, // Avatar size
                backgroundColor: iconColor.withOpacity(0.1),
                child: Icon(
                  icon,
                  size: 30,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style:  TextStyle(
                fontSize: 12.r,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAccount() {
    final accounts = authController.balanceAndAccount.value.data?.addAccounts;
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Advertise Accounts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            children: accounts?.map((account) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${account.name ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Dollar Rate: ${account.dollarRate ?? 'N/A'} Taka',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                  ],
                ),
              );
            }).toList() ??
                [
                  const Text(
                    'No accounts available',
                    style: TextStyle(fontSize: 16, color: Colors.redAccent),
                  ),
                ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close the dialog
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
