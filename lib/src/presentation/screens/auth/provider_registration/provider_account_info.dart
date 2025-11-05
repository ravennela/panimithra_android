import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_bloc.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_event.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_state.dart';
import 'package:panimithra/src/presentation/cubit/provider_registration/prover_registration_state.dart';
import 'package:panimithra/src/presentation/cubit/provider_registration/provider_registration_cubit.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';
import 'package:panimithra/src/utilities/location_fetch.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Service Provider Registration',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                buildProgressStep(isActive: true, isCompleted: true),
                buildProgressLine(isActive: false),
                buildProgressStep(isActive: true, isCompleted: true),
                buildProgressLine(isActive: false),
                buildProgressStep(isActive: false, isCompleted: false),
                buildProgressLine(isActive: false),
                buildProgressStep(isActive: false, isCompleted: false),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Password Field
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: const TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 16,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFFBBBBBB),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue[700]!,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Confirm Password Field
                      const Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          hintStyle: const TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 16,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFFBBBBBB),
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue[700]!,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Terms & Conditions Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: Color(0xFFCCCCCC),
                                width: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<ProviderRegistrationCubit,
                            ProverRegistrationState>(
                          listener: (BuildContext context,
                              ProverRegistrationState state) {},
                          builder: (context, state) {
                            return BlocListener<ProviderRegistrationBloc,
                                ProviderRegistrationState>(
                              listener: (context, regState) {
                                if (regState is ProviderRegistrationLoaded) {
                                  context.go(AppRoutes.LOGIN_ROUTE_PATH);
                                  ToastHelper.showToast(
                                      context: context,
                                      type: "success",
                                      title: "Registration Successful");
                                }
                                if (regState is ProviderRegistrationError) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: "error",
                                      title: regState.error);
                                }
                              },
                              child: ElevatedButton(
                                onPressed: _agreedToTerms
                                    ? () async {
                                        if (_passwordController.text.isEmpty) {
                                          ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title: "Please Enter Password",
                                          );
                                          return;
                                        }
                                        if (_confirmPasswordController
                                            .text.isEmpty) {
                                          ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title:
                                                "Please Enter Conform Password",
                                          );
                                          return;
                                        }
                                        // Handle registration submission
                                        if (_passwordController.text ==
                                            _confirmPasswordController.text) {
                                          double latitude = 0.0;
                                          double longitude = 0.0;
                                          try {
                                            Map<String, double>? location =
                                                await getCurrentLocation();
                                            latitude = location!['lat']!;
                                            longitude = location['lng']!;
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                          Map<String, dynamic> request = {
                                            "name": state.name,
                                            "contactNumber": state.mobileNumber,
                                            "emailId": state.emailId,
                                            "password":
                                                _passwordController.text,
                                            "address": state.address,
                                            "latitude": latitude,
                                            "longitude": longitude,
                                            "profileImageUrl": "",
                                            "gender": state.gender,
                                            "dateOfBirth": state.dateobBirth
                                                .toIso8601String(),
                                            "city": state.city,
                                            "state": state.state,
                                            "pincode": state.pincode,
                                            "role": "EMPLOYEE",
                                            "status": "ACTIVE",
                                            "deviceToken": "",
                                            "alternateMobileNumber":
                                                state.alternateNumber,
                                            "primaryService":
                                                state.primaryServiceCategory,
                                            "experiance": state.experience,
                                            "shortBio": state.shortDescription
                                          };
                                          context
                                              .read<ProviderRegistrationBloc>()
                                              .add(
                                                  ProviderRegistrationSubmitted(
                                                      registrationData:
                                                          request));
                                          // Process registration
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Passwords do not match!',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2),
                                  disabledBackgroundColor:
                                      const Color(0xFFBBDEFB),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Submit Registration',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
