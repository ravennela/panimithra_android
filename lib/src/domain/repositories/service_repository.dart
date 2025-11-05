import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_service_model.dart';
import 'package:panimithra/src/data/models/search_service_model.dart';
import 'package:panimithra/src/data/models/service_by_id_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class ServiceRepository {
  Future<Either<String, FetchServiceModel>> fetchServices(int page);
  Future<Either<String, SuccessModel>> createService({
    required Map<String, dynamic> serviceData,
    required String categoryId,
    required String subCategoryId,
  });

  Future<Either<String, FetchSearchServiceModel>> fetchSearchService(
      {int? page,
      String? serviceName,
      String? categoryName,
      String? subCategoryName,
      double? minPrice,
      double? maxPrice,
      double? price,
      String? priceSort});

  Future<Either<String, ServiceByIdModel>> fetchServiceById({required String serviceId});
}
