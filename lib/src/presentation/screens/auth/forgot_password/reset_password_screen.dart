import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
import 'package:panimithra/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String emailId;
  const ResetPasswordScreen({super.key, required this.emailId});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _currentObscure = true;
  bool _newObscure = true;
  bool _confirmObscure = true;
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final body = {
        "emailId": widget.emailId,
        "currentPassword": _currentPasswordController.text.trim(),
        "newPassword": _newPasswordController.text.trim(),
      };

      context.read<FetchUsersBloc>().add(
            ResetPasswordBeforeAuthEvent(body: body),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.changePassword,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// Current Password
                        _passwordField(
                          controller: _currentPasswordController,
                          label: l10n.currentPassword,
                          obscure: _currentObscure,
                          toggle: () {
                            setState(() {
                              _currentObscure = !_currentObscure;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.enterCurrentPassword;
                            }
                            if (value.length < 6) {
                              return l10n.passwordLengthError;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        /// New Password
                        _passwordField(
                          controller: _newPasswordController,
                          label: l10n.newPassword,
                          obscure: _newObscure,
                          toggle: () {
                            setState(() {
                              _newObscure = !_newObscure;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.enterNewPassword;
                            }
                            if (value.length < 8) {
                              return l10n.min8Chars;
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return l10n.atLeastOneNumber;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        /// Confirm Password
                        _passwordField(
                          controller: _confirmPasswordController,
                          label: l10n.confirmPassword,
                          obscure: _confirmObscure,
                          toggle: () {
                            setState(() {
                              _confirmObscure = !_confirmObscure;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.confirmYourPassword;
                            }
                            if (value != _newPasswordController.text) {
                              return l10n.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        BlocConsumer<FetchUsersBloc, FetchUsersState>(
                          listener: (context, state) {
                            /// ✅ Success
                            if (state is ResetPasswordBeforeAuthSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              context.go(AppRoutes.LOGIN_ROUTE_PATH);
                            }

                            /// ❌ Error
                            if (state is ResetPasswordBeforeAuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: const Color(0xFF6A82FB),
                              ),
                              child: Text(
                                state is ResetPasswordLoading
                                    ? l10n.updating
                                    : l10n.updatePassword,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }
}
