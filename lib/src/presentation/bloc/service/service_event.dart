// Service Events
import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchServicesEvent extends ServiceEvent {
  final int page;

  const FetchServicesEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class CreateServiceEvent extends ServiceEvent {
  final Map<String, dynamic> serviceData;
  final String categoryId;
  final String subCategoryId;

  const CreateServiceEvent({
    required this.serviceData,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  List<Object?> get props => [serviceData, categoryId, subCategoryId];
}

class SearchServiceEvent extends ServiceEvent {
  final int? page;
  final String? serviceName;
  final String? categoryName;
  final String? subCategoryName;
  final double? minPrice;
  final double? maxPrice;
  final double? price;
  final String? priceSort;
  const SearchServiceEvent(
      {this.categoryName,
      this.page,
      this.maxPrice,
      this.minPrice,
      this.price,
      this.priceSort,
      this.serviceName,
      this.subCategoryName});
}

class GetServiceByIdEvent extends ServiceEvent {
  final String serviceId;

  const GetServiceByIdEvent(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

class UpdateServiceEvent extends ServiceEvent {
  final String serviceId;
  final Map<String, dynamic> serviceData;
  final String categoryId;
  final String subCategoryId;

  const UpdateServiceEvent({
    required this.serviceId,
    required this.serviceData,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  List<Object?> get props =>
      [serviceId, serviceData, categoryId, subCategoryId];
}
