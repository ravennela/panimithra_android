import 'package:equatable/equatable.dart';

abstract class ProviderRegistrationEvent extends Equatable {
  const ProviderRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class ProviderRegistrationSubmitted extends ProviderRegistrationEvent {
  final Map<String, dynamic> registrationData;

  const ProviderRegistrationSubmitted({required this.registrationData});

  @override
  List<Object?> get props => [registrationData];
}
