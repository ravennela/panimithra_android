part of 'authenticator_watcher_bloc.dart';

abstract class AuthenticatorWatcherState {
  const AuthenticatorWatcherState();
  bool get isAuthenticated => this is AuthenticatorWatcherAuthenticated;
  bool get isSessionExpired => this is AuthenticatorWatcherSessionExpired;
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

class AuthenticatorWatcherSessionExpired extends AuthenticatorWatcherState {
  const AuthenticatorWatcherSessionExpired();
}
