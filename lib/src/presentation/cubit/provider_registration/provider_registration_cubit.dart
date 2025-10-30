import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/presentation/cubit/provider_registration/prover_registration_state.dart';

class ProviderRegistrationCubit extends Cubit<ProverRegistrationState> {
  ProviderRegistrationCubit()
    : super(
        ProverRegistrationState(
          address: '',
          alternateNumber: '',
          city: '',
          dateobBirth: DateTime(0, 0, 0, 0),
          emailId: '',
          experience: 0,
          gender: '',
          mobileNumber: '',
          name: '',
          pincode: '',
          password: '',
          primaryServiceCategory: '',
          shortDescription: '',
          state: '',
        ),
      );

  void addBaseInfo(
    String name,
    String email,
    String mobileNumber,
    String alternateNumber,
    String gender,
    DateTime dob,
  ) {
    emit(
      state.copyWith(
        name: name,
        emailId: email,
        mobileNumber: mobileNumber,
        alternateNumber: alternateNumber,
        gender: gender,
        dateobBirth: dob,
      ),
    );
  }

  void addressInfo(
    String fullAddress,
    String city,
    String stateS,
    String pinCode,
  ) {
    emit(
      state.copyWith(
        address: fullAddress,
        city: city,
        state: stateS,
        pincode: pinCode,
      ),
    );
  }

  void serviceInfo(String primaryService, int experiance, String shortBio) {
    emit(
      state.copyWith(
        primaryServiceCategory: primaryService,
        experience: experiance,
        shortDescription: shortBio,
      ),
    );
  }

  void accountInfo(String password) {
    emit(state.copyWith(password: password));
  }
}
