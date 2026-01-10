import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_bloc.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_event.dart';
import 'package:panimithra/src/presentation/bloc/registration_bloc/registration_state.dart';
import 'package:panimithra/src/presentation/widget/url_launcher.dart';
import 'package:panimithra/src/utilities/location_fetch.dart';

import 'package:panimithra/l10n/app_localizations.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _selectedState;
  bool _isConfirmPasswordVisible = false;
  final List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressLine1Controller.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.createAccount,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Center(
                  child: Column(
                    children: [
                      Text(
                        l10n.joinPanimithra,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.fillDetailsToStart,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Personal Info Section
                _buildSectionHeader(l10n.personalInformation),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _fullNameController,
                  label: l10n.fullName,
                  hintText: l10n.enterFullName,
                  icon: Icons.person_outline_rounded,
                  isRequired: true,
                  validator: (value) =>
                      value!.isEmpty ? l10n.fieldCannotBeEmpty : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: l10n.emailAddress,
                  hintText: 'john.doe@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.fieldCannotBeEmpty;
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return l10n.invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _phoneController,
                  label: l10n.phoneNumber,
                  hintText: l10n.enterPhoneNumber,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.fieldCannotBeEmpty;
                    }
                    final mobileRegex = RegExp(r'^[0-9]{10}$');
                    if (!mobileRegex.hasMatch(value)) {
                      return l10n.invalidPhoneNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Address Section
                _buildSectionHeader(l10n.addressDetails),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressLine1Controller,
                  label: l10n.addressLine1,
                  hintText: l10n.addressHint,
                  icon: Icons.location_on_outlined,
                  isRequired: true,
                  validator: (value) =>
                      value!.isEmpty ? l10n.fieldCannotBeEmpty : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cityController,
                        label: l10n.city,
                        hintText: l10n.cityHint,
                        icon: Icons.location_city_rounded,
                        isRequired: true,
                        validator: (value) =>
                            value!.isEmpty ? "!" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _zipCodeController,
                        label: l10n.pincode,
                        hintText: l10n.pincodeHint,
                        icon: Icons.pin_drop_outlined,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        validator: (value) =>
                            value!.isEmpty ? "!" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:  [
                        Text(
                          l10n.state,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const Text(' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedState,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF64748B)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF2563EB), width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red.shade200),
                        ),
                      ),
                      hint: Text(
                        l10n.selectState,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 15),
                      ),
                      items: _states.map((String state) {
                        return DropdownMenuItem<String>(
                          value: state,
                          child:
                              Text(state, style: const TextStyle(fontSize: 15)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedState = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? "!" : null,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Security Section
                _buildSectionHeader(l10n.security),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: l10n.password,
                  hintText: l10n.enterPassword,
                  icon: Icons.lock_outline_rounded,
                  isRequired: true,
                  obscureText: !_isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) =>
                      value!.isEmpty ? l10n.fieldCannotBeEmpty : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: l10n.confirmPassword,
                  hintText: l10n.confirmPassword,
                  icon: Icons.lock_reset_rounded,
                  isRequired: true,
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF94A3B8),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) =>
                      value!.isEmpty ? l10n.fieldCannotBeEmpty : null,
                ),

                const SizedBox(height: 32),

                // Terms and Conditions
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        height: 1.5,
                      ),
                      children: [
                         TextSpan(
                            text: l10n.agreeToTerms + ' '),
                        TextSpan(
                          text: l10n.termsOfService,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              UrlLauncherHelper.launchWebUrl(
                                  "https://dynamic-lolly-961756.netlify.app/",
                                  context: context);
                            },
                        ),
                         TextSpan(text: ' ' + l10n.and + ' '),
                        TextSpan(
                          text: l10n.privacyPolicy,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              UrlLauncherHelper.launchWebUrl(
                                  "https://694bb0de96fad848212f7f2b--sprightly-sunshine-aac8ce.netlify.app/",
                                  context: context);
                            },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Create Account Button
                BlocConsumer<ProviderRegistrationBloc,
                    ProviderRegistrationState>(
                  listener: (context, regState) {
                    if (regState is ProviderRegistrationLoaded) {
                      context.go(AppRoutes.LOGIN_ROUTE_PATH);
                      ToastHelper.showToast(
                          context: context,
                          type: "success",
                          title: l10n.registrationSuccessful);
                    }
                    if (regState is ProviderRegistrationError) {
                      ToastHelper.showToast(
                          context: context,
                          type: "error",
                          title: regState.error);
                    }
                  },
                  builder: (context, regState) {
                    bool isLoading = regState is ProviderRegistrationLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                }
                                if (_confirmPasswordController.text !=
                                    _passwordController.text) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: "error",
                                      title: l10n.passwordsMismatch);
                                  return;
                                }
                                double latitude = 0.0;
                                double longitude = 0.0;
                                try {
                                  Map<String, double>? location =
                                      await getCurrentLocation();
                                  if (location != null) {
                                    latitude = location['lat'] ?? 0.0;
                                    longitude = location['lng'] ?? 0.0;
                                  }
                                } catch (e) {
                                  print(e.toString());
                                }
                                Map<String, dynamic> request = {
                                  "name": _fullNameController.text,
                                  "contactNumber": _phoneController.text,
                                  "emailId": _emailController.text,
                                  "password": _passwordController.text,
                                  "address": _addressLine1Controller.text,
                                  "latitude": latitude,
                                  "longitude": longitude,
                                  "profileImageUrl": "",
                                  "city": _cityController.text,
                                  "state": _selectedState,
                                  "pincode": _zipCodeController.text,
                                  "role": "USER",
                                  "status": "ACTIVE",
                                  "deviceToken": ""
                                };
                                context.read<ProviderRegistrationBloc>().add(
                                    ProviderRegistrationSubmitted(
                                        registrationData: request));
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          disabledBackgroundColor:
                              const Color(0xFF2563EB).withOpacity(0.6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            :  Text(
                                l10n.createAccount,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Already have an account
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                      ),
                      children: [
                         TextSpan(text: l10n.alreadyHaveAccount + ' '),
                        TextSpan(
                          text: l10n.logIn,
                          style: const TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w700,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Login if needed, usually Navigator.pop works if came from login
                              context.go(AppRoutes.LOGIN_ROUTE_PATH);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E293B),
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool isRequired = false,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
          ),
        ),
      ],
    );
  }
}
