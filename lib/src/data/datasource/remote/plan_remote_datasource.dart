import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CreatePlanRemoteDataSource {
  Future<Map<String, dynamic>> createPlan({
    required String planName,
    required String description,
    required double price,
    required int duration,
    required double originalPrice,
    required String discount,
  });
  Future<Map<String, dynamic>> updatePlan({
    required String planId,
    required Map<String, dynamic> body,
  });
  Future<Map<String, dynamic>> deletePlan(String planId);
  Future<Map<String, dynamic>> fetchPlans();
  Future<Map<String, dynamic>> fetchPlanById(String planId);
}

/// Implementation
class CreatePlanRemoteDataSourceImpl implements CreatePlanRemoteDataSource {
  final DioClient dioClient;

  CreatePlanRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> createPlan(
      {required String planName,
      required String description,
      required double price,
      required int duration,
      required String discount,
      required double originalPrice}) async {
    try {
      // Get token from SharedPreferences

      // Prepare request body
      final data = {
        "planName": planName,
        "description": description,
        "price": price,
        "durationInDays": duration,
        "discount": discount,
        "originalPrice": originalPrice
      };

      // Send POST request
      final response = await dioClient.post(
        ApiConstants.createSubscriptionPlanApi,
        data: data,
        options: Options(),
      );
      print(response.toString());

      // Return API response
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPlans() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String role = preferences.getString(ApiConstants.role) ?? "";
      // Send GET request (no headers required)
      final response = await dioClient.get(
        ApiConstants.fetchPlanApi + "?role=$role",
        options: Options(),
      );

      // Print for debugging
      print(response.toString());

      // Return the entire response data as a map
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> deletePlan(String planId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.delete(
          "${ApiConstants.deletePlanApi}?planId=$planId",
          options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPlanById(String planId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      var headers = {"Authorization": "Bearer $token"};
      // No token needed unless API requires it
      final response = await dioClient.get(
        "${ApiConstants.fetchPlanById}?planId=$planId",
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updatePlan({
    required String planId,
    required Map<String, dynamic> body,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.put(
        "${ApiConstants.updatePlan}?planId=$planId",
        data: body,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
