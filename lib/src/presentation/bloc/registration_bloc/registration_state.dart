import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class ProviderRegistrationState extends Equatable {
  const ProviderRegistrationState();

  @override
  List<Object?> get props => [];
}

class ProviderRegistrationInitial extends ProviderRegistrationState {}

class ProviderRegistrationLoading extends ProviderRegistrationState {}

class ProviderRegistrationLoaded extends ProviderRegistrationState {
  final SuccessModel success;

  const ProviderRegistrationLoaded({required this.success});

  @override
  List<Object?> get props => [success];
}

class ProviderRegistrationError extends ProviderRegistrationState {
  final String error;

  const ProviderRegistrationError({required this.error});

  @override
  List<Object?> get props => [error];
}
