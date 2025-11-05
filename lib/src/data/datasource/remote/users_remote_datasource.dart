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
      var headers = {"Authorization": "Bearer $token"};

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
}
