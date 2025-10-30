// Abstract Data Source
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ServiceDataSource {
  Future<Map<String, dynamic>> fetchServices({
    required int page,
  });
  Future<Map<String, dynamic>> createService({
    required Map<String, dynamic> serviceData,
    required String categoryId,
    required String subCategoryId,
  });

  Future<Map<String, dynamic>> searchService({
    int? page,
    String? serviceName,
    String? categoryName,
    String? subCategoryName,
    double? minPrice,
    double? maxPrice,
    double? price,
    String? priceSort,
  });
}

// Implementation
class ServiceDataSourceImpl implements ServiceDataSource {
  final DioClient dioClient;

  ServiceDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> fetchServices({
    required int page,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.get(
        ApiConstants.fetchService,
        queryParameters: {
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
  Future<Map<String, dynamic>> createService({
    required Map<String, dynamic> serviceData,
    required String categoryId,
    required String subCategoryId,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      String userid = preferences.getString(ApiConstants.userId) ?? "";
      var headers = {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json'
      };

      final response = await dioClient.post(
          ApiConstants
              .createService, // Make sure you define this endpoint in ApiConstants
          data: jsonEncode(serviceData),
          options: Options(headers: headers),
          queryParameters: {
            "catId": categoryId,
            "subCatId": subCategoryId,
            "employeeId": userid
          });

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> searchService(
      {int? page,
      String? serviceName,
      String? categoryName,
      String? subCategoryName,
      double? minPrice,
      double? maxPrice,
      double? price,
      String? priceSort}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";
      var headers = {
        "Authorization": "Bearer $token",
        'Content-Type': 'application/json'
      };
      String url = ApiConstants.searchService;

      final response = await dioClient.get(
          queryParameters: {
            'page': page ?? 0,
            'size': '10',
            if (serviceName != null && serviceName!.isNotEmpty)
              'serviceName': serviceName,
            if (categoryName != null && categoryName!.isNotEmpty)
              'categoryName': categoryName,
            if (subCategoryName != null && subCategoryName!.isNotEmpty)
              'subCategoryName': subCategoryName,
            if (priceSort != null) 'sort': "price,${priceSort.toLowerCase()}"
          },
          url, // Make sure you define this endpoint in ApiConstants
          options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
