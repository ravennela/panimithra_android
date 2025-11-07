import 'package:get_it/get_it.dart';
import 'package:panimithra/src/core/network/dio_client.dart';
import 'package:panimithra/src/data/datasource/remote/booking_remote_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/category_remote_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/review_remote_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/login_remote_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/payments_remote_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/plan_remote_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/provider_registration_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/service_remote_data_source.dart';
import 'package:panimithra/src/data/datasource/remote/subcategory_remote_datasource.dart';
import 'package:panimithra/src/data/datasource/remote/users_remote_datasource.dart';
import 'package:panimithra/src/data/repository/booking_repo_impl.dart';
import 'package:panimithra/src/data/repository/category_repository_impl.dart';
import 'package:panimithra/src/data/repository/login_repository_impl.dart';
import 'package:panimithra/src/data/repository/payments_repository_impl.dart';
import 'package:panimithra/src/data/repository/plan_repository_impl.dart';
import 'package:panimithra/src/data/repository/provider_registration_impl.dart';
import 'package:panimithra/src/data/repository/review_repository_impl.dart';
import 'package:panimithra/src/data/repository/service_repository_impl.dart';
import 'package:panimithra/src/data/repository/subcategory_repository_impl.dart';
import 'package:panimithra/src/data/repository/user_repository_impl.dart';
import 'package:panimithra/src/domain/repositories/booking_repository.dart';
import 'package:panimithra/src/domain/repositories/category_repository.dart';
import 'package:panimithra/src/domain/repositories/login_repository.dart';
import 'package:panimithra/src/domain/repositories/payments_repository.dart';
import 'package:panimithra/src/domain/repositories/plan_repository.dart';
import 'package:panimithra/src/domain/repositories/provider_registration_repository.dart';
import 'package:panimithra/src/domain/repositories/review_repository.dart';
import 'package:panimithra/src/domain/repositories/service_repository.dart';
import 'package:panimithra/src/domain/repositories/subcategory_repository.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';
import 'package:panimithra/src/domain/usecase/add_review_usecase.dart';
import 'package:panimithra/src/domain/usecase/booking_byid_usecase.dart';
import 'package:panimithra/src/domain/usecase/create_booking_usecase.dart';

import 'package:panimithra/src/domain/usecase/create_category_usecase.dart';
import 'package:panimithra/src/domain/usecase/create_order_usecase.dart';
import 'package:panimithra/src/domain/usecase/create_plan_usecase.dart';
import 'package:panimithra/src/domain/usecase/create_service_usecase.dart';
import 'package:panimithra/src/domain/usecase/create_subcategory_usecase.dart';
import 'package:panimithra/src/domain/usecase/employee_plans_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_booking_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_categories_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_plan_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_service_by_id_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_service_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_subcategory_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_users_usecase.dart';
import 'package:panimithra/src/domain/usecase/login/createlogin_login_usecase.dart';
import 'package:panimithra/src/domain/usecase/provider_registration_usecase.dart';
import 'package:panimithra/src/domain/usecase/search_service_usecase.dart';
import 'package:panimithra/src/domain/usecase/top_five_review_usecase.dart';
import 'package:panimithra/src/domain/usecase/update_booking_status_usecase.dart';
import 'package:panimithra/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/login/login_bloc.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_bloc.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_bloc.dart';
import 'package:panimithra/src/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/cubit/provider_registration/provider_registration_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => DioClient());
  // Bloc
  sl.registerFactory(
    () => LoginBloc(createloginLogin: sl()),
  );
  sl.registerFactory(() => ProviderRegistrationCubit());
  sl.registerFactory(() => AuthenticatorWatcherBloc());
  sl.registerFactory(
      () => PlanBloc(createPlanUseCase: sl(), fetchPlansUseCase: sl()));
  sl.registerFactory(() => ServiceBloc(
      fetchServicesUseCase: sl(),
      createServiceUseCase: sl(),
      searchServiSeceUsecase: sl(),
      fetchServiceByIdUseCase: sl()));
  sl.registerFactory(
    () => ProviderRegistrationBloc(providerRegistrationUseCase: sl()),
  );
  sl.registerFactory(
    () => CategoriesBloc(
        fetchCategoriesUseCase: sl(), createCategoryUseCase: sl()),
  );
  sl.registerFactory(
    () => SubcategoryBloc(
      fetchSubcategoriesUseCase: sl(),
      createSubcategoryUseCase: sl(),
    ),
  );
  sl.registerFactory(() => FetchUsersBloc(fetchUsersUseCase: sl()));
  sl.registerFactory(() => EmployeePaymentBloc(
      fetchEmployeePaymentsUseCase: sl(), createOrderUseCase: sl()));
  sl.registerFactory(() => BookingBloc(
      createBookingUsecase: sl(),
      getBookingsUseCase: sl(),
      updateBookingStatusUsecase: sl(),
      getBookingDetailsUsecase: sl()));
  sl.registerFactory(
      () => ReviewBloc(addReviewUseCase: sl(), getTopFiveRatingsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => CreateloginLogin(sl()));
  sl.registerLazySingleton(() => FetchServicesUseCase(repository: sl()));
  sl.registerLazySingleton<ProviderRegistrationUsecase>(
    () => ProviderRegistrationUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => CreatePlanUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateCategoryUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => FetchCategoriesUseCase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => FetchSubcategoriesUseCase(repository: sl()),
  );

  sl.registerLazySingleton(
    () => CreateSubcategoryUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => CreateServiceUseCase(sl()));
  sl.registerLazySingleton(
      () => SearchServiSeceUsecase(serviceRepository: sl()));
  sl.registerLazySingleton(() => FetchPlansUseCase(repository: sl()));
  sl.registerLazySingleton(() => FetchUsersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetEmployeePaymentsUseCase(repository: sl()));
  sl.registerLazySingleton(() => FetchServiceByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookingUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBookingsUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateBookingStatusUsecase(repository: sl()));
  sl.registerLazySingleton(() => AddReviewUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetTopFiveRatingsUseCase(reviewRepository: sl()));
  sl.registerLazySingleton(() => GetBookingDetailsUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ServiceRepository>(
      () => ServiceRepositoryImpl(serviceDataSource: sl()));
  sl.registerLazySingleton<ProviderRegistrationRepository>(
    () => ProviderRegistrationImpl(
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ProviderRegistrationRemoteDataSourceImpl>(
    () => ProviderRegistrationRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<SubcategoryRepository>(
    () => SubcategoryRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<PlanRepository>(
      () => PlanRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<EmployeePaymentRepository>(
      () => EmployeePaymentRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepoImpl(remoteDatasource: sl()));

  sl.registerLazySingleton<ReviewRepository>(
      () => ReviewRepositoryImpl(reviewRemoteDatasource: sl()));

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ServiceDataSource>(
      () => ServiceDataSourceImpl(dioClient: sl()));

  sl.registerLazySingleton<ProviderRegistrationRemoteDataSource>(
    () => ProviderRegistrationRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<FetchCategoryRemoteDataSource>(
    () => FetchCategoryRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<FetchCategoryRemoteDataSourceImpl>(
      () => FetchCategoryRemoteDataSourceImpl(dioClient: sl()));

  sl.registerLazySingleton<SubcategoryRemoteDataSourceImpl>(
      () => SubcategoryRemoteDataSourceImpl(dioClient: sl()));

  sl.registerLazySingleton<SubcategoryRemoteDataSource>(
    () => SubcategoryRemoteDataSourceImpl(
      dioClient: sl(),
    ),
  );
  sl.registerLazySingleton<CreatePlanRemoteDataSource>(
      () => CreatePlanRemoteDataSourceImpl(dioClient: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(dioClient: sl()));
  sl.registerLazySingleton<EmployeePaymentRemoteDataSource>(
      () => EmployeePaymentRemoteDataSourceImpl(dioClient: sl()));
  sl.registerLazySingleton<BookingRemoteDatasource>(
      () => BookingRemoteDatasourceImpl(dioClient: sl()));
  sl.registerLazySingleton<ReviewRemoteDatasource>(
      () => ReviewRemoteDatasourceImpl(dioClient: sl()));

  // External
}
