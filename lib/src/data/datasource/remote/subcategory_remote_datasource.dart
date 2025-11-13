import 'dart:io';

import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:panimithra/src/data/datasource/remote/upload_file_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SubcategoryRemoteDataSource {
  Future<Map<String, dynamic>> fetchSubcategories({
    required String categoryId,
    required int page,
  });

  Future<Map<String, dynamic>> createSubCategory(
      {required String categoryId, required Map<String, dynamic> data});
}

class SubcategoryRemoteDataSourceImpl implements SubcategoryRemoteDataSource {
  final DioClient dioClient;

  SubcategoryRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> fetchSubcategories({
    required String categoryId,
    required int page,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.get(
        "${ApiConstants.fetchSubCategories}?categoryId=$categoryId",
        queryParameters: {
          'category_id': categoryId,
          'page': page,
        },
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createSubCategory(
      {required String categoryId, required Map<String, dynamic> data}) async {
    try {
      File? photo;
      String? photoUrl = "";
      if (data['iconUrl'] != null) {
        photo = data["iconUrl"];
      }
      if (photo != null) {
        photoUrl =
            await UploadFileRemoteDatasource(client: Dio()).uploadPhoto(photo);
      }
      data['iconUrl'] = photoUrl ?? '';
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.post(
        "${ApiConstants.createSubCategoryApi}?categoryId=$categoryId",
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
