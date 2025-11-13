// Abstract Data Source
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:panimithra/src/data/datasource/remote/upload_file_remote_datasource.dart';
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

  Future<Map<String, dynamic>> fetchServiceById(String serviceId);
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
      String employeeId = preferences.getString(ApiConstants.userId) ?? "";
      var headers = {"Authorization": "Bearer $token"};
      final response = await dioClient.get(
        "${ApiConstants.fetchService}?employeeId=$employeeId",
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
    File? photo;
    String? photoUrl = "";
    if (serviceData['iconUrl'] != null) {
      photo = serviceData["iconUrl"];
    }
    if (photo != null) {
      photoUrl =
          await UploadFileRemoteDatasource(client: Dio()).uploadPhoto(photo);
    }
    serviceData['iconUrl'] = photoUrl ?? '';
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
      print("sort value" + priceSort.toString());
      final response = await dioClient.get(
          queryParameters: {
            'page': page ?? 0,
            'size': 10,
            if (serviceName != null && serviceName!.isNotEmpty)
              'serviceName': serviceName,
            if (categoryName != null && categoryName!.isNotEmpty)
              'categoryName': categoryName,
            if (subCategoryName != null && subCategoryName!.isNotEmpty)
              'subCategoryName': subCategoryName,
            if (priceSort?.toLowerCase() == 'asc' ||
                priceSort?.toLowerCase() == 'desc')
              'sort': 'price,${priceSort!.toLowerCase()}',
            if (minPrice != null) 'minPrice': minPrice,
            if (maxPrice != null) 'maxPrice': maxPrice
          },
          url, // Make sure you define this endpoint in ApiConstants
          options: Options(headers: headers));
      final Map<String, dynamic> jsonResponse = response.data;
      print(jsonResponse["totalItems"]);
      final List<dynamic> services = jsonResponse['data'];
      print(services.length);

      return response.data;
    } catch (e) {
      print("res" + e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchServiceById(String serviceId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString(ApiConstants.token) ?? "";

      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      // Construct URL with serviceId param
      String url = "${ApiConstants.getServiceById}?serviceId=$serviceId";

      final response = await dioClient.get(
        url,
        options: Options(headers: headers),
      );

      print("GET: $url");
      print("Response Status: ${response.statusCode}");
      return response.data;
    } catch (e) {
      print("Error fetching service by ID: $e");
      rethrow;
    }
  }
}
