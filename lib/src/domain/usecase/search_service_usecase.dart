import 'package:dartz/dartz.dart';
import 'package:panimithra/src/common/failure.dart';
import 'package:panimithra/src/data/models/search_service_model.dart';
import 'package:panimithra/src/domain/repositories/service_repository.dart';

class SearchServiSeceUsecase {
  ServiceRepository serviceRepository;
  SearchServiSeceUsecase({required this.serviceRepository});
  Future<Either<String, FetchSearchServiceModel>> fetchSearchServiceusecase(
      {int? page,
      String? serviceName,
      String? categoryName,
      String? subCategoryName,
      double? minPrice,
      double? maxPrice,
      double? price,
      String? priceSort}) {
    return serviceRepository.fetchSearchService(
        categoryName: categoryName,
        maxPrice: maxPrice,
        minPrice: minPrice,
        page: page,
        price: price,
        priceSort: priceSort,
        serviceName: serviceName,
        subCategoryName: subCategoryName);
  }
}
