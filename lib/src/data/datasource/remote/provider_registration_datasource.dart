import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/error/exceptions.dart';
import 'package:panimithra/src/core/network/dio_client.dart';

abstract class ProviderRegistrationRemoteDataSource {
  Future<Map<String, dynamic>> createProviderRegistration(
      Map<String, dynamic> data);
}

class ProviderRegistrationRemoteDataSourceImpl
    implements ProviderRegistrationRemoteDataSource {
  final DioClient dioClient;

  ProviderRegistrationRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> createProviderRegistration(
      Map<String, dynamic> data) async {
    try {
      final response =
          await dioClient.post(ApiConstants.registration, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
