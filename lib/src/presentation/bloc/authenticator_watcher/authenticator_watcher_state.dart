part of 'authenticator_watcher_bloc.dart';

abstract class AuthenticatorWatcherState {
  const AuthenticatorWatcherState();
}

class AuthenticatorWatcherInitial extends AuthenticatorWatcherState {
  const AuthenticatorWatcherInitial();
}

class AuthenticatorWatcherAuthenticating extends AuthenticatorWatcherState {
  const AuthenticatorWatcherAuthenticating();
}

class AuthenticatorWatcherAuthenticated extends AuthenticatorWatcherState {
  const AuthenticatorWatcherAuthenticated();
}

class AuthenticatorWatcherUnauthenticated extends AuthenticatorWatcherState {
  const AuthenticatorWatcherUnauthenticated();
}

class AuthenticatorWatcherIsFirstTime extends AuthenticatorWatcherState {
  const AuthenticatorWatcherIsFirstTime();
}
