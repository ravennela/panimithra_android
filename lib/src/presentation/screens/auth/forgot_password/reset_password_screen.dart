import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
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
                        const Text(
                          "Change Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),

                        /// Current Password
                        _passwordField(
                          controller: _currentPasswordController,
                          label: "Current Password",
                          obscure: _currentObscure,
                          toggle: () {
                            setState(() {
                              _currentObscure = !_currentObscure;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter current password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        /// New Password
                        _passwordField(
                          controller: _newPasswordController,
                          label: "New Password",
                          obscure: _newObscure,
                          toggle: () {
                            setState(() {
                              _newObscure = !_newObscure;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter new password";
                            }
                            if (value.length < 8) {
                              return "Minimum 8 characters required";
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return "Must contain at least one number";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        /// Confirm Password
                        _passwordField(
                          controller: _confirmPasswordController,
                          label: "Confirm Password",
                          obscure: _confirmObscure,
                          toggle: () {
                            setState(() {
                              _confirmObscure = !_confirmObscure;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm your password";
                            }
                            if (value != _newPasswordController.text) {
                              return "Passwords do not match";
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
                                    ? "Updating ..."
                                    : "Update Password",
                                style: TextStyle(
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
