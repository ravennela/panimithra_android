import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> fetchUsers({
    int? page,
    String? status,
    String? name,
    String? role,
  });
  Future<Map<String, dynamic>> requestOtp({
    required Map<String, dynamic> body,
  });
  Future<Map<String, dynamic>> fetchAdminDashboard();
  Future<Map<String, dynamic>> getUserProfile({required String userId});
  Future<Map<String, dynamic>> fetchEmployeeDashboard({required String userId});
  Future<Map<String, dynamic>> registerFcmToken({
    required String deviceToken,
  });
  Future<Map<String, dynamic>> changeUserStatus({
    required String userId,
    required String status,
  });
  Future<List<dynamic>> fetchFaq();

  Future<Map<String, dynamic>> resetPassword({
    required Map<String, dynamic> body,
  });
  Future<Map<String, dynamic>> verifyOtp({
    required Map<String, dynamic> body,
  });

  Future<Map<String, dynamic>> resetPasswordBeforeAuth({
    required Map<String, dynamic> body,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> fetchUsers({
    int? page,
    String? status,
    String? name,
    String? role,
  }) async {
    print("api called");
    try {
      final queryParams = {
        'page': page ?? 0,
        'size': 10,
        if (status != null && status.isNotEmpty) 'status': status,
        if (name != null && name.isNotEmpty) 'name': name,
        if (role != null && role.isNotEmpty) 'role': role,
      };
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": null};

      final response = await dioClient.get(
        ApiConstants.fetchUsers, // define this in ApiConstants
        queryParameters: queryParams,
        options: Options(headers: headers), // no headers required
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUserProfile({required String userId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      String userid = preferences.getString(ApiConstants.userId) ?? "";
      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.get(
        '${ApiConstants.fetchUserProfile}?userId=$userid', // define this in ApiConstants
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchAdminDashboard() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      final headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.get(
        ApiConstants.fetchAdminDashboardApi, // define in ApiConstants
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchEmployeeDashboard(
      {required String userId}) async {
    try {
      // Retrieve auth token from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      String userid = preferences.getString(ApiConstants.userId) ?? "";

      // Set authorization header
      final headers = {"Authorization": "Bearer $token"};

      // Send GET request with userId as query param
      final response = await dioClient.get(
        '${ApiConstants.fetchEmployeeDashboardApi}?userId=$userid', // ✅ define in ApiConstants
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> registerFcmToken({
    required String deviceToken,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String token = preferences.getString(ApiConstants.token) ?? "";
      String userId = preferences.getString(ApiConstants.userId) ?? "";

      final headers = {"Authorization": "Bearer $token"};

      final queryParams = {
        "userId": userId,
        "token": deviceToken,
      };

      final response = await dioClient.post(
        ApiConstants.registerToken,
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> changeUserStatus({
    required String userId,
    required String status,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      //String id = preferences.getString(ApiConstants.userId) ?? "";

      final headers = {"Authorization": "Bearer $token"};

      final queryParams = {
        "userId": userId,
        "status": status,
      };

      final response = await dioClient.put(
        ApiConstants.changeUserStatusApi, // define this in ApiConstants
        queryParameters: queryParams,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> fetchFaq() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      final headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.get(
        ApiConstants.faqApi,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required Map<String, dynamic> body,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await dioClient.post(
        ApiConstants.restPasswordApi, // 🔥 define this
        data: body, // ✅ REQUEST BODY
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> requestOtp({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.requestOtpApi, // 🔥 define this constant
        data: body, // ✅ BODY from UI
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required Map<String, dynamic> body,
  }) async {
    print(body);
    try {
      final response = await dioClient.post(
        ApiConstants.verifyOtpApi, // 🔥 define this constant
        data: body, // ✅ BODY from UI
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> resetPasswordBeforeAuth({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.resetBeforeAuthApi, // 🔥 define this
        data: body, // ✅ emailId, currentPassword, newPassword
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

Future<Options> _publicOptions() async {
  return Options(
    headers: {
      // Explicitly NO Authorization header
      'Content-Type': 'application/json',
    },
  );
}
