import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authenticator_watcher_event.dart';
part 'authenticator_watcher_state.dart';

class AuthenticatorWatcherBloc
    extends Bloc<AuthenticatorWatcherEvent, AuthenticatorWatcherState> {
  AuthenticatorWatcherBloc() : super(AuthenticatorWatcherInitial()) {
    on<AuthenticatorWatcherAuthCheckRequest>(_onAuthCheckRequest);
    on<AuthenticatorWatcherSignOut>(_onSignOut);
  }

  Future<void> _onAuthCheckRequest(
    AuthenticatorWatcherAuthCheckRequest event,
    Emitter<AuthenticatorWatcherState> emit,
  ) async {
    emit(AuthenticatorWatcherAuthenticating());
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    print("is logged in value" + isLoggedIn.toString());

    if (isLoggedIn) {
      emit(AuthenticatorWatcherAuthenticated());
    } else {
      emit(AuthenticatorWatcherUnauthenticated());
    }
  }

  Future<void> _onSignOut(
    AuthenticatorWatcherSignOut event,
    Emitter<AuthenticatorWatcherState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    emit(AuthenticatorWatcherUnauthenticated());
  }
}
