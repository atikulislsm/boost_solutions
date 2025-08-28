import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../model/BalanceAndAccountModel.dart';
import '../model/UserModel.dart';
import '../service/api_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController extends GetxController {
  final ApiService apiService = Get.put(ApiService());
  var userModel = UserModel().obs;
  var balanceAndAccount = BalanceAndAccountModel().obs;
  final GetStorage storage = GetStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  void _subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic).then((_) {
      print("Subscribed to topic: $topic");
    }).catchError((error) {
      print("Error subscribing to topic: $error");
    });
  }

  Future<void> _initializeAuth() async {
    // Wait for token to be fully retrieved
    String? token = await Future.value(storage.read('token'));
    if (token != null) {
      if (kDebugMode) {
        print("Token retrieved: $token");
      }
      await fetchUser();
      await fetchBalanceAndAccount();
    }
  }

  Future<void> login(String phone, String password) async {
    await apiService.login(phone, password);
  }

  Future<void> fetchUser() async {
    try {
      userModel.value = await apiService.fetchCurrentUser();
      _subscribeToTopic(userModel.value.phone!);
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  Future<void> fetchBalanceAndAccount() async {
    try {
      balanceAndAccount.value = await apiService.fetchBalanceAndAccounts();
    } catch (e) {
      print("Error fetching balance and account: $e");
    }
  }

  Future<void> logout() async {
    await apiService.logout();
    storage.remove('token');
  }

  bool isLoggedIn() {
    return storage.read('token') != null; // Check if token exists
  }
}
