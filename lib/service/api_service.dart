import 'dart:async';
import 'dart:io';
import 'package:boost_solutions/model/BalanceAndAccountModel.dart';
import 'package:boost_solutions/model/UserModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Transaction.dart';

class ApiService extends GetxController {
  static const String baseUrl = 'https://boost.mohasagorit.solutions/api';

  final GetStorage storage = GetStorage();

  /// Get token for authenticated requests
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${storage.read('token') ?? ''}',
    };
  }

  /// 1. Login Request (POST)
  Future<void> login(String phone, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        storage.write('token', data['token']);

        print("Login Successful!");
      } else {
        print("Login Failed!");
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  /// 2. Fetch Current User (GET)
  Future<UserModel> fetchCurrentUser() async {
    final url = Uri.parse('$baseUrl/user');
    int retryCount = 3; // Number of retry attempts
    int delayInMilliseconds = 2000; // Delay between retries
    const int timeoutInSeconds = 10; // Request timeout duration

    for (int attempt = 1; attempt <= retryCount; attempt++) {
      try {
        final response = await http
            .get(url, headers: _getHeaders())
            .timeout(const Duration(seconds: timeoutInSeconds));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          UserModel userModel = UserModel.fromJson(data);
          print("User Data: $data");
          return userModel;
        } else {
          print("Error: ${response.statusCode}");
        }
      } on TimeoutException {
        print('Request timed out. Attempt $attempt of $retryCount');
      } on SocketException {
        print('No internet connection. Attempt $attempt of $retryCount');
      } catch (e) {
        print('Unexpected error: $e. Attempt $attempt of $retryCount');
      }

      if (attempt < retryCount) {
        await Future.delayed(Duration(milliseconds: delayInMilliseconds));
      }
    }

    if (kDebugMode) {
      print('Failed to fetch user data after $retryCount attempts.');
    }
    return UserModel(); // Return empty user model as fallback
  }


  /// 3. Logout (POST)
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/logout');
    final response = await http.post(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', "");
      storage.remove('token');
      print("Successfully logged out!");
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/profile/update'),
          headers: _getHeaders(),
          body: jsonEncode(data)
    ,);
      print(jsonDecode(response.body));
    return jsonDecode(response.body);
    } catch (e) {
    return {'success': false, 'message': 'Error updating profile. $e'};
    }
  }


  /// 7. Fetch Balance and Add Accounts (GET)
  Future<BalanceAndAccountModel> fetchBalanceAndAccounts() async {
    final url = Uri.parse('$baseUrl/balance/and/add-account/list');
    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      BalanceAndAccountModel balanceAndAccountModel = BalanceAndAccountModel
          .fromJson(data);

      print("Balances and Accounts: ${data['data']}");
      return balanceAndAccountModel;
    } else {
      print("Error: ${response.statusCode}");
      return BalanceAndAccountModel();
    }
  }


  Future<Map<String, dynamic>> updateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/device-token/store'),
        headers: _getHeaders(),
        body: jsonEncode({'device_id': token})
        ,);
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error updating profile. $e'};
    }
  }

}
