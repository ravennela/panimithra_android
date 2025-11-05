import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/fetch_service_model.dart';
import 'package:panimithra/src/data/models/search_service_model.dart';
import 'package:panimithra/src/domain/usecase/create_service_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_service_by_id_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_service_usecase.dart';
import 'package:panimithra/src/domain/usecase/search_service_usecase.dart';
import 'package:panimithra/src/presentation/bloc/service/service_event.dart';
import 'package:panimithra/src/presentation/bloc/service/service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final FetchServicesUseCase fetchServicesUseCase;
  final CreateServiceUseCase createServiceUseCase;
  final SearchServiSeceUsecase searchServiSeceUsecase;
  final FetchServiceByIdUseCase fetchServiceByIdUseCase;

  ServiceBloc({
    required this.fetchServicesUseCase,
    required this.createServiceUseCase,
    required this.searchServiSeceUsecase,
    required this.fetchServiceByIdUseCase,
  }) : super(const ServiceInitial()) {
    on<FetchServicesEvent>(_onFetchServices);
    on<CreateServiceEvent>(_onCreateServiceUsecase);
    on<SearchServiceEvent>(_onSearchserviceEvent);
    on<GetServiceByIdEvent>(_onGetServiceByEvent);
  }

  Future<void> _onFetchServices(
    FetchServicesEvent event,
    Emitter<ServiceState> emit,
  ) async {
    // Show loading only for first page
    if (event.page == 1) {
      emit(const ServiceLoading());
    }

    final result = await fetchServicesUseCase(event.page);

    result.fold(
      (error) {
        emit(ServiceError(message: error));
      },
      (fetchServiceModel) {
        List<ServiceItem> newData = fetchServiceModel.data ?? [];
        // Handle pagination: append data if not first page
        if (event.page > 1 && state is ServiceLoaded) {
          final currentState = state as ServiceLoaded;
          final existingData = currentState.data ?? [];
          newData = [...existingData, ...newData];
        }

        emit(ServiceLoaded(
          page: event.page,
          totalRecords: fetchServiceModel.totalItems ?? 0,
          fetchServiceModel: fetchServiceModel,
          data: newData,
        ));
      },
    );
  }

  FutureOr<void> _onCreateServiceUsecase(
      CreateServiceEvent event, Emitter<ServiceState> emit) async {
    emit(CreateServiceLoading());

    final result = await createServiceUseCase(
      serviceData: event.serviceData,
      categoryId: event.categoryId,
      subCategoryId: event.subCategoryId,
    );

    result.fold(
      (error) => emit(CreateServiceError(error)),
      (data) => emit(CreateServiceSuccess(data)),
    );
  }

  FutureOr<void> _onSearchserviceEvent(
      SearchServiceEvent event, Emitter<ServiceState> emit) async {
    if (event.page == 0) {
      emit(SearchServiceLoadingState());
    }
    final result = await searchServiSeceUsecase.fetchSearchServiceusecase(
        page: event.page,
        categoryName: event.categoryName,
        maxPrice: event.maxPrice,
        minPrice: event.minPrice,
        price: event.price,
        priceSort: event.priceSort,
        serviceName: event.serviceName,
        subCategoryName: event.subCategoryName);
    result.fold((f) {
      emit(SearchServiceErrorState(error: f.toString()));
    }, (fetchServiceModel) {
      int totalRecords = fetchServiceModel.totalItems ?? 0;
      List<SearchServiceItem> newData = fetchServiceModel.data ?? [];

      if (event.page! > 1 && state is SearchServiceLoadedState) {
        final currentState = state as SearchServiceLoadedState;
        final existingData = currentState.items ?? [];
        newData = [...existingData, ...newData];
      }
      emit(SearchServiceLoadedState(
          hasMoreRecords: false,
          items: newData,
          model: fetchServiceModel,
          totalRecords: totalRecords));
    });
  }

  FutureOr<void> _onGetServiceByEvent(
      GetServiceByIdEvent event, Emitter<ServiceState> emit) async {
    emit(ServiceByIdLoading());
    final result = await fetchServiceByIdUseCase(event.serviceId);
    result.fold(
      (error) => emit(ServiceByIdError(error)),
      (data) => emit(ServiceByIdLoaded(data)),
    );
  }
}
