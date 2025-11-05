import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class EmployeePaymentRemoteDataSource {
  Future<Map<String, dynamic>> fetchEmployeePayments({
    required String userId,
  });
  Future<Map<String, dynamic>> createOrder({
    required String planId,
  });
}

class EmployeePaymentRemoteDataSourceImpl
    implements EmployeePaymentRemoteDataSource {
  final DioClient dioClient;

  EmployeePaymentRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> fetchEmployeePayments({
    required String userId,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      String userId = preferences.getString(ApiConstants.userId) ?? '';
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.get(
        ApiConstants.fetchEmployeePlans, // define this in ApiConstants
        queryParameters: {
          'userId': userId,
        },
        options: Options(headers: headers), // no headers if not required
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder({
    required String planId,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      String userId = preferences.getString(ApiConstants.userId) ?? '';

      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.post(
        ApiConstants.orderCreationApi, // define in ApiConstants
        queryParameters: {
          "planId": planId,
          "userid": userId,
        },
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
