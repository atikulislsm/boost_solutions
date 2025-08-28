import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class AppController extends GetxController {
  final GetStorage storage = GetStorage();

  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var dollarRequests = [].obs;
  var dollarPendingRequests = [].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var totalPending = 0.obs;
  var startDate = "".obs;
  var endDate = "".obs;
  var lifeTime = "yes".obs;
  var status = "".obs;

  final Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    String? token = await Future.value(storage.read('token'));
    if (token != null && token.isNotEmpty) {
      // Proceed with API calls only if the token exists
      await fetchApiResponse();
      await totalPendingRequest();
    } else {
      Get.snackbar("Authentication Error", "Token not found, please log in.");
    }
  }

  Future<void> fetchApiResponse({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing.value = true;
      currentPage.value = 1;
      dollarRequests.clear();
    } else {
      isLoading.value = true;
    }

    try {
      String bearerToken = storage.read('token') ?? '';

      if (bearerToken.isEmpty) {
        throw Exception("Token not found.");
      }

      var response = await dio.get(
        'https://boost.mohasagorit.solutions/api/dollar-request/list',
        queryParameters: {
          'page': currentPage.value,
          'start_date': startDate.value,
          'end_date': endDate.value,
          'life_time': lifeTime.value,
          'status':status.value == "" ? "":"0"
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        if (jsonData['status'] == true) {
          var requests = jsonData['data']['data'];
          var paginationInfo = jsonData['data'];

          totalPages.value = paginationInfo['last_page'] ?? 1;
          currentPage.value = paginationInfo['current_page'] ?? 1;

          dollarRequests.addAll(requests);
        } else {
          Get.snackbar("Error", "Failed to load data");
        }
      } else {
        Get.snackbar("Error", "Server returned error code: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load data: $e");
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> loadMoreData() async {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      currentPage.value++;
      await fetchApiResponse();
    }
  }

  Future<void> refreshData() async {
    await fetchApiResponse(isRefresh: true);
  }

  void updateDateRange(String timeRange) {
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    switch (timeRange) {
      case "Maximum Time":
        startDate.value = "";
        endDate.value = "";
        lifeTime.value = "yes";
        break;

      case "Today":
        startDate.value = dateFormat.format(now);
        endDate.value = dateFormat.format(now);
        lifeTime.value = "no";
        break;

      case "Yesterday":
        DateTime yesterday = now.subtract(const Duration(days: 1));
        startDate.value = dateFormat.format(yesterday);
        endDate.value = dateFormat.format(yesterday);
        lifeTime.value = "no";
        break;

      case "Last 7 days":
        DateTime last7Days = now.subtract(Duration(days: 7));
        startDate.value = dateFormat.format(last7Days);
        endDate.value = dateFormat.format(now);
        lifeTime.value = "no";
        break;

      case "Last 30 days":
        DateTime last30Days = now.subtract(const Duration(days: 30));
        startDate.value = dateFormat.format(last30Days);
        endDate.value = dateFormat.format(now);
        lifeTime.value = "no";
        break;

      case "This month":
        DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
        startDate.value = dateFormat.format(firstDayOfMonth);
        endDate.value = dateFormat.format(now);
        lifeTime.value = "no";
        break;

      case "This Year":
        DateTime firstDayOfYear = DateTime(now.year, 1, 1);
        startDate.value = dateFormat.format(firstDayOfYear);
        endDate.value = dateFormat.format(now);
        lifeTime.value = "no";
        break;

      case "Last Year":
        DateTime firstDayOfLastYear = DateTime(now.year - 1, 1, 1);
        DateTime lastDayOfLastYear = DateTime(now.year - 1, 12, 31);
        startDate.value = dateFormat.format(firstDayOfLastYear);
        endDate.value = dateFormat.format(lastDayOfLastYear);
        lifeTime.value = "no";
        break;
      case "status":
        if(status.value=="0") {
          status.value = "";
        } else {
          status.value = "0";
        }
        break;
      default:
        startDate.value = "";
        endDate.value = "";
        lifeTime.value = "yes";
        status.value ="";
        break;
    }

    fetchApiResponse(isRefresh: true);
  }

  Future<void> totalPendingRequest() async {
    try {
      String bearerToken = storage.read('token') ?? '';

      if (bearerToken.isEmpty) {
        throw Exception("Token not found.");
      }

      var response = await dio.get(
        'https://boost.mohasagorit.solutions/api/dollar-request/list',
        queryParameters: {
          'page': currentPage.value,
          'start_date': startDate.value,
          'end_date': endDate.value,
          'life_time': lifeTime.value,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var jsonData = response.data;
        dollarPendingRequests.clear();
        if (jsonData['status'] == true) {
          var requests = jsonData['data']['data'];
          dollarPendingRequests.addAll(requests);
          totalPending.value = dollarPendingRequests
              .where((transaction) => transaction['status'] == "0")
              .length;
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch pending requests: $e");
    }
  }
}


