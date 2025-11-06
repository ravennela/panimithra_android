import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class for Review Remote Datasource
abstract class ReviewRemoteDatasource {
  Future<Map<String, dynamic>> addReview({
    required String bookingId,
    required String employeeId,
    required double rating,
    required String serviceId,
    required String review,
  });
}

/// Implementation class
class ReviewRemoteDatasourceImpl implements ReviewRemoteDatasource {
  final DioClient dioClient;
  ReviewRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> addReview({
    required String bookingId,
    required String serviceId,
    required String employeeId,
    required double rating,
    required String review,
  }) async {
    try {
      String url = ApiConstants.addReviewApi; // define in ApiConstants
      SharedPreferences preferences = await SharedPreferences.getInstance();

      // Fetch auth token and user ID from preferences
      String token = preferences.getString(ApiConstants.token) ?? "";
      String userId = preferences.getString(ApiConstants.userId) ?? "";

      var headers = {"Authorization": "Bearer $token"};

      // Prepare the data payload
      final data = {
        "bookingId": bookingId,
        "customerId": userId,
        "employeeid": employeeId,
        "rating": rating,
        "comment": review,
        "serviceId": serviceId
      };

      // POST request
      final response = await dioClient.post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      print("ADD REVIEW RESPONSE: ${response.data}");
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
