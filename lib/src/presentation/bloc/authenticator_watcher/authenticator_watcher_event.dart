part of 'authenticator_watcher_bloc.dart';

abstract class AuthenticatorWatcherEvent {
  const AuthenticatorWatcherEvent();
}

class AuthenticatorWatcherAuthCheckRequest extends AuthenticatorWatcherEvent {
  const AuthenticatorWatcherAuthCheckRequest();
}

class AuthenticatorWatcherSignOut extends AuthenticatorWatcherEvent {
  const AuthenticatorWatcherSignOut();
}
