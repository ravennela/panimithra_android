import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BookingRemoteDatasource {
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getBookings(int page);
  Future<Map<String, dynamic>> updateBookingStatus({
    required String bookingId,
    required String bookingStatus,
  });
  // ✅ New method
  Future<Map<String, dynamic>> getBookingDetails(String bookingId);
}

class BookingRemoteDatasourceImpl implements BookingRemoteDatasource {
  final DioClient dioClient;
  BookingRemoteDatasourceImpl({required this.dioClient});
  @override
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    try {
      String url = ApiConstants.createBooking;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.post(
        url, // define in ApiConstants
        data: data,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getBookings(int page) async {
    try {
      String url = ApiConstants.fetchBookings;
      SharedPreferences preferences = await SharedPreferences.getInstance();

      String token = preferences.getString(ApiConstants.token) ?? "";
      String role = preferences.getString(ApiConstants.role) ?? "";
      String userId = preferences.getString(ApiConstants.userId) ?? "";

      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.get(
        url,
        queryParameters: {
          "role": role,
          "userId": userId,
          "page": page,
          "size": 10,
        },
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateBookingStatus({
    required String bookingId,
    required String bookingStatus,
  }) async {
    try {
      String url =
          "${ApiConstants.updateBookingStatus}?bookingId=$bookingId&status=$bookingStatus";
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.put(
        url,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getBookingDetails(String bookingId) async {
    try {
      String url = "${ApiConstants.bookingsById}?bookingId=$bookingId";
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.get(
        url,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
