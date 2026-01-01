import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/employee_dashboard_model.dart';
import 'package:panimithra/src/data/models/fetch_users_model.dart';
import 'package:panimithra/src/data/models/user_profile_model.dart';
import 'package:panimithra/src/data/models/admin_dashboard_model.dart';
import 'package:panimithra/src/domain/usecase/change_user_status_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_employee_dashboard_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_users_usecase.dart';
import 'package:panimithra/src/domain/usecase/register_fcm_usecase.dart';
import 'package:panimithra/src/domain/usecase/request_otp_usecase.dart'
    show RequestOtpUseCase;
import 'package:panimithra/src/domain/usecase/reset_before_auth_usecase.dart';
import 'package:panimithra/src/domain/usecase/reset_password_usecase.dart';
import 'package:panimithra/src/domain/usecase/user_profile_usecase.dart';
import 'package:panimithra/src/domain/usecase/admin_dashboard_usecase.dart';
import 'package:panimithra/src/domain/usecase/verify_otp_usecase.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
import 'package:panimithra/src/domain/usecase/fetch_faq_usecase.dart';
import 'package:panimithra/src/data/models/faq_model.dart';

class FetchUsersBloc extends Bloc<FetchUsersEvent, FetchUsersState> {
  final FetchUsersUseCase fetchUsersUseCase;
  final GetUserProfileUsecase getUserProfileUsecase;
  final FetchAdminDashboardUseCase getAdminDashboardUsecase;
  final FetchEmployeeDashboardUseCase getEmployeeDashboardUsecase;
  final RegisterFcmTokenUseCase registerFcmTokenUseCase;
  final ChangeUserStatusUseCase changeUserStatusUseCase;
  final FetchFaqUseCase fetchFaqUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordBeforeAuthUseCase resetPasswordBeforeAuthUseCase;

  FetchUsersBloc({
    required this.fetchUsersUseCase,
    required this.getUserProfileUsecase,
    required this.getAdminDashboardUsecase,
    required this.resetPasswordBeforeAuthUseCase,
    required this.getEmployeeDashboardUsecase,
    required this.registerFcmTokenUseCase,
    required this.changeUserStatusUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
    required this.fetchFaqUseCase,
    required this.requestOtpUseCase,
  }) : super(FetchUsersInitial()) {
    on<GetUsersEvent>(_onFetchUsers);
    on<GetUserProfileEvent>(_onGetUserProfile);
    on<GetAdminDashboardEvent>(_onGetAdminDashboard);
    on<GetEmployeeDashboardEvent>(_onGetEmployeeDashboard);
    on<RegisterFcmTokenEvent>(_onRegisterFcmToken);
    on<ChangeUserStatusEvent>(_onChangeUserStatus);
    on<FetchFaqEvent>(_onFetchFaq);
    on<ResetPasswordEvent>(_onResetPassword);
    on<RequestOtpEvent>(_onRequestOtp);
    on<ResetPasswordBeforeAuthEvent>(_onResetPasswordBeforeAuth);
    on<VerifyOtpEvent>(_onVerifyOtp);
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

  Future<void> _onRegisterFcmToken(
    RegisterFcmTokenEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(RegisterFcmTokenLoading());
    final result = await registerFcmTokenUseCase.call(
      deviceToken: event.deviceToken,
    );

    result.fold(
      (failure) => emit(RegisterFcmTokenError(failure.toString())),
      (success) {
        emit(RegisterFcmTokenSuccess(message: success.message.toString()));
      },
    );
  }

  Future<void> _onChangeUserStatus(
    ChangeUserStatusEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(ChangeUserStatusLoading());

    final result = await changeUserStatusUseCase.call(
      userId: event.userId,
      status: event.status,
    );

    result.fold(
      (failure) => emit(ChangeUserStatusError(failure.toString())),
      (success) {
        emit(ChangeUserStatusSuccess(message: success.message.toString()));
      },
    );
  }

  Future<void> _onFetchFaq(
    FetchFaqEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(FaqLoading());
    final result = await fetchFaqUseCase.call();
    result.fold(
      (failure) => emit(FaqError(failure)),
      (faqList) => emit(FaqLoaded(faqList: faqList)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(ResetPasswordLoading());

    final result = await resetPasswordUseCase.call(
      body: event.body,
    );

    result.fold(
      (failure) => emit(ResetPasswordError(failure.toString())),
      (success) {
        emit(
          ResetPasswordSuccess(
            message: success.message.toString(),
          ),
        );
      },
    );
  }

  Future<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(RequestOtpLoading());

    final result = await requestOtpUseCase.call(
      body: event.body,
    );

    result.fold(
      (failure) => emit(RequestOtpError(failure.toString())),
      (success) {
        emit(
          RequestOtpSuccess(
            message: success.message.toString(),
          ),
        );
      },
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(VerifyOtpLoading());

    final result = await verifyOtpUseCase.call(
      body: event.body,
    );

    result.fold(
      (failure) => emit(VerifyOtpError(failure.toString())),
      (success) {
        emit(
          VerifyOtpSuccess(
            message: success.message.toString(),
          ),
        );
      },
    );
  }

  Future<void> _onResetPasswordBeforeAuth(
    ResetPasswordBeforeAuthEvent event,
    Emitter<FetchUsersState> emit,
  ) async {
    emit(ResetPasswordBeforeAuthLoading());

    final result = await resetPasswordBeforeAuthUseCase.call(
      body: event.body,
    );

    result.fold(
      (failure) => emit(ResetPasswordBeforeAuthError(failure.toString())),
      (success) {
        emit(
          ResetPasswordBeforeAuthSuccess(
            message: success.message.toString(),
          ),
        );
      },
    );
  }
}
