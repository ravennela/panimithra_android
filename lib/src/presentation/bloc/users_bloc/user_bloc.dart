import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/employee_dashboard_model.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/data/models/user_profile_model.dart';
import 'package:panimithra/src/data/models/admin_dashboard_model.dart';
import 'package:panimithra/src/domain/usecase/fetch_employee_dashboard_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_users_usecase.dart';
import 'package:panimithra/src/domain/usecase/user_profile_usecase.dart';
import 'package:panimithra/src/domain/usecase/admin_dashboard_usecase.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';

class FetchUsersBloc extends Bloc<FetchUsersEvent, FetchUsersState> {
  final FetchUsersUseCase fetchUsersUseCase;
  final GetUserProfileUsecase getUserProfileUsecase;
  final FetchAdminDashboardUseCase getAdminDashboardUsecase;
  final FetchEmployeeDashboardUseCase getEmployeeDashboardUsecase;
  FetchUsersBloc({
    required this.fetchUsersUseCase,
    required this.getUserProfileUsecase,
    required this.getAdminDashboardUsecase,
    required this.getEmployeeDashboardUsecase,
  }) : super(FetchUsersInitial()) {
    on<GetUsersEvent>(_onFetchUsers);
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<GetAdminDashboardEvent>(_onGetAdminDashboard);
    on<GetEmployeeDashboardEvent>(_onGetEmployeeDashboard);
  }

  /// 🧩 Fetch all users
  Future<void> _onFetchUsers(
    GetUsersEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    List<UserItem> currentUsers = [];

    // retain previously loaded users for pagination
    if (state is FetchUsersLoaded) {
      if (event.page != null && event.page! > 0) {
        currentUsers =
            List.from((state as FetchUsersLoaded).fetchUsersModel.data);
      }
    }

    emit(FetchUsersLoading());
    final result = await fetchUsersUseCase.call(
      page: event.page,
      name: event.name,
      status: event.status,
      role: event.role,
    );

    result.fold(
      (failure) => emit(FetchUsersError(failure.toString())),
      (FetchUsersModel usersModel) {
        final updatedUsers = [...currentUsers, ...usersModel.data];
        emit(FetchUsersLoaded(
          fetchUsersModel: usersModel,
          item: updatedUsers,
          totalRecords: usersModel.totalItems,
        ));
      },
    );
  }

  /// 👤 Fetch user profile
  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(UserProfileLoading());
    final result = await getUserProfileUsecase.call(userId: event.userId);

    result.fold(
      (failure) => emit(UserProfileError(failure.toString())),
      (UserProfileModel profile) {
        emit(UserProfileLoaded(userProfileModel: profile));
      },
    );
  }

  /// 📊 Fetch admin dashboard data
  Future<void> _onGetAdminDashboard(
    GetAdminDashboardEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(AdminDashboardLoading());

    final result = await getAdminDashboardUsecase.call();

    result.fold(
      (failure) => emit(AdminDashboardError(failure.toString())),
      (AdminDashboardModel dashboardData) {
        emit(AdminDashboardLoaded(dashboardModel: dashboardData));
      },
    );
  }

  Future<void> _onGetEmployeeDashboard(
    GetEmployeeDashboardEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(EmployeeDashboardLoading());

    final result = await getEmployeeDashboardUsecase.call(userId: event.userId);

    result.fold(
      (failure) => emit(EmployeeDashboardError(failure.toString())),
      (EmployeeDashboardModel dashboardData) {
        emit(EmployeeDashboardLoaded(employeeDashboardModel: dashboardData));
      },
    );
  }
}
