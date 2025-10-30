import '../../../core/constants/api_constants.dart';

import '../../../core/network/dio_client.dart';

abstract class LoginRemoteDataSource {
  Future<Map<String, dynamic>> createlogin(Map<String, dynamic> data);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> createlogin(Map<String, dynamic> data) async {
    print("api called" + ApiConstants.login);
    try {
      final response = await dioClient.post(ApiConstants.login, data: data);
      print("RES VALUE" + response.toString());
      return response.data;
    } catch (e) {
      print("error " + e.toString());
      rethrow; // Keep it simple, just rethrow the Dio error
    }
  }
}
