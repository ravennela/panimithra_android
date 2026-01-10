import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:panimithra/l10n/app_localizations.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userId = preferences.getString(ApiConstants.userId) ?? "";
      Map<String, dynamic> data = {
        "userId": userId,
        "currentPassword": _currentPasswordController.text,
        "newPassword": _newPasswordController.text
      };
      context.read<FetchUsersBloc>().add(ResetPasswordEvent(body: data));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Professional Header
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            backgroundColor: primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                l10n.changePassword,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor,
                          primaryColor.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -20,
                    top: -10,
                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 150,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.secureYourAccount,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.resetRegularlyMessage,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 32),

                        /// Current Password
                        _buildPasswordField(
                          controller: _currentPasswordController,
                          label: l10n.currentPassword,
                          hint: l10n.enterCurrentPassword,
                          icon: Icons.lock_outline_rounded,
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
                        _buildPasswordField(
                          controller: _newPasswordController,
                          label: l10n.newPassword,
                          hint: "Enter 8+ characters",
                          icon: Icons.vpn_key_outlined,
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
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          label: l10n.confirmPassword,
                          hint: l10n.reEnterNewPassword,
                          icon: Icons.check_circle_outline_rounded,
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

                        const SizedBox(height: 48),

                        BlocConsumer<FetchUsersBloc, FetchUsersState>(
                          listener: (context, state) {
                            if (state is ResetPasswordError) {
                              ToastHelper.showToast(
                                  context: context,
                                  type: 'error',
                                  title: state.message);
                            }
                            if (state is ResetPasswordSuccess) {
                              ToastHelper.showToast(
                                  context: context,
                                  type: 'success',
                                  title: state.message);
                              context.pop();
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state is ResetPasswordLoading
                                  ? null
                                  : _submit,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: primaryColor,
                                elevation: 2,
                                shadowColor: primaryColor.withOpacity(0.4),
                              ),
                              child: state is ResetPasswordLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      l10n.updatePassword,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback toggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          cursorColor: Theme.of(context).primaryColor,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: Colors.grey[400],
                size: 20,
              ),
              onPressed: toggle,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
