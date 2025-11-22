import 'dart:io';

import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:panimithra/src/data/datasource/remote/upload_file_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FetchCategoryRemoteDataSource {
  Future<Map<String, dynamic>> fetchCategories(int page);
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data);
  Future<Map<String, dynamic>> deleteCategory({
    required String categoryId,
  });
  Future<Map<String, dynamic>> updateCategory({
    required Map<String, dynamic> data,
  });
  Future<Map<String, dynamic>> fetchCategoryById({
    required String categoryId,
  });
}

class FetchCategoryRemoteDataSourceImpl
    implements FetchCategoryRemoteDataSource {
  final DioClient dioClient;

  FetchCategoryRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> fetchCategories(int page) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.get(
          "${ApiConstants.fetchCategoryApi}?page=$page",
          options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data) async {
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
        ApiConstants.createCategoryApi,
        data: data,
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> deleteCategory({
    required String categoryId,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.delete(
        "${ApiConstants.deleteCategoryApi}?categoryId=$categoryId",
        options: Options(headers: headers),
      );
      print(response.toString());
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchCategoryById({
    required String categoryId,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.get(
        "${ApiConstants.fetchCategoryByIdApi}?categoryId=$categoryId",
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateCategory({
    required Map<String, dynamic> data,
  }) async {
    try {
      File? photo;
      String? photoUrl = "";
      if (data['iconUrl'] != null) {
        photo = data["iconUrl"];
      }
      if (photo != null) {
        photoUrl =
            await UploadFileRemoteDatasource(client: Dio()).uploadPhoto(photo);
        data['iconUrl'] = photoUrl ?? '';
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};

      final response = await dioClient.put(
        ApiConstants.updateCategoryApi,
        data: data,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
