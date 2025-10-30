abstract class LoginEvent {}

class CreateloginLoginEvent extends LoginEvent {
  final Map<String, dynamic> data;
  CreateloginLoginEvent(this.data);
}
