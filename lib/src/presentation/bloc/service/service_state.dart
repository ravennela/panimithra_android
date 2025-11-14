import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/fetch_service_model.dart';
import 'package:panimithra/src/data/models/search_service_model.dart';
import 'package:panimithra/src/data/models/service_by_id_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {
  const ServiceInitial();
}

class ServiceLoading extends ServiceState {
  const ServiceLoading();
}

class ServiceError extends ServiceState {
  final String message;

  const ServiceError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServiceLoaded extends ServiceState {
  final int page;
  final int totalRecords;
  final FetchServiceModel fetchServiceModel;
  final List<ServiceItem>? data;

  const ServiceLoaded({
    required this.page,
    required this.totalRecords,
    required this.fetchServiceModel,
    this.data,
  });

  @override
  List<Object?> get props => [page, totalRecords, fetchServiceModel, data];

  ServiceLoaded copyWith({
    int? page,
    int? totalRecords,
    FetchServiceModel? fetchServiceModel,
    List<ServiceItem>? data,
  }) {
    return ServiceLoaded(
      page: page ?? this.page,
      totalRecords: totalRecords ?? this.totalRecords,
      fetchServiceModel: fetchServiceModel ?? this.fetchServiceModel,
      data: data ?? this.data,
    );
  }
}

class CreateServiceLoading extends ServiceState {}

class CreateServiceSuccess extends ServiceState {
  final SuccessModel model;

  const CreateServiceSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class CreateServiceError extends ServiceState {
  final String message;

  const CreateServiceError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchServiceLoadingState extends ServiceState {}

class SearchServiceErrorState extends ServiceState {
  final String error;
  const SearchServiceErrorState({required this.error});
}

class SearchServiceLoadedState extends ServiceState {
  final FetchSearchServiceModel model;
  final int totalRecords;
  final List<SearchServiceItem> items;
  final bool hasMoreRecords;
  const SearchServiceLoadedState(
      {required this.hasMoreRecords,
      required this.items,
      required this.model,
      required this.totalRecords});
}

// 🟠 Loading State (when API call is in progress)
class ServiceByIdLoading extends ServiceState {}

// 🟢 Loaded State (when data is successfully fetched)
class ServiceByIdLoaded extends ServiceState {
  final ServiceByIdModel service;

  const ServiceByIdLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

// 🔴 Error State (when something goes wrong)
class ServiceByIdError extends ServiceState {
  final String message;

  const ServiceByIdError(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateServiceLoading extends ServiceState {}

class UpdateServiceSuccess extends ServiceState {
  final SuccessModel model;

  const UpdateServiceSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class UpdateServiceError extends ServiceState {
  final String message;

  const UpdateServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
