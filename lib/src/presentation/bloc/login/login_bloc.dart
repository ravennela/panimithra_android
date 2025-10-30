import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecase/login/createlogin_login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CreateloginLogin createloginLogin;

  LoginBloc({required this.createloginLogin}) : super(LoginInitial()) {
    on<CreateloginLoginEvent>((event, emit) async {
      emit(LoginLoading());
      final result = await createloginLogin(event.data);
      result.fold(
        (failure) => emit(LoginError(failure.toString())),
        (data) => emit(LoginSuccess(data)),
      );
    });
  }
}
