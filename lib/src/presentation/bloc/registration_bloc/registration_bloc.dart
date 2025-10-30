import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/domain/usecase/provider_registration_usecase.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_event.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_state.dart';

class ProviderRegistrationBloc
    extends Bloc<ProviderRegistrationEvent, ProviderRegistrationState> {
  final ProviderRegistrationUsecase providerRegistrationUseCase;

  ProviderRegistrationBloc({required this.providerRegistrationUseCase})
      : super(ProviderRegistrationInitial()) {
    on<ProviderRegistrationSubmitted>(_onProviderRegistrationSubmitted);
  }

  Future<void> _onProviderRegistrationSubmitted(
    ProviderRegistrationSubmitted event,
    Emitter<ProviderRegistrationState> emit,
  ) async {
    emit(ProviderRegistrationLoading());
    final result = await providerRegistrationUseCase.createProviderUseCase(
        data: event.registrationData);

    result.fold(
      (failure) => emit(ProviderRegistrationError(error: failure)),
      (success) => emit(ProviderRegistrationLoaded(success: success)),
    );
  }
}
