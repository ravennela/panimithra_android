import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panimithra/src/common/images.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/login/login_bloc.dart';
import 'package:panimithra/src/presentation/bloc/login/login_event.dart';
import 'package:panimithra/src/presentation/bloc/login/login_state.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/l10n/app_localizations.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/widget/error_ui_builder.dart';

import 'package:panimithra/src/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Handle session expired message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = GoRouterState.of(context);
      if (state.uri.queryParameters['reason'] == 'sessionExpired') {
        ToastHelper.showToast(
          context: context,
          type: 'error',
          title: AppLocalizations.of(context)!.sessionExpired,
        );
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Logo + Title
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.handyman_rounded,
                        size: 48,
                        color: Color(0xFF0D6EFD),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.welcomeBack,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.loginToContinue,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Card container
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      Text(
                        l10n.emailId,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _usernameController,
                        hint: l10n.enterEmailId,
                        l10n: l10n,
                      ),

                      const SizedBox(height: 20),

                      // Password
                      Text(
                        l10n.password,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                          controller: _passwordController,
                          hint: l10n.enterPassword,
                          l10n: l10n,
                          obscure: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )),

                      const SizedBox(height: 12),

                      // Forgot password
                      GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.FORGOT_PASSWORD_EMAIL);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            l10n.forgotPassword,
                            style: GoogleFonts.inter(
                              color: Color(0xFF0D6EFD),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Login Button
                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            ToastHelper.showToast(
                              context: context,
                              type: 'success',
                              title: l10n.loginSuccessful,
                            );
                            getToken();
                            // Update global auth state before navigating
                            context.read<AuthenticatorWatcherBloc>().add(
                                  const AuthenticatorWatcherAuthCheckRequest(),
                                );
                            context.go(AppRoutes.HOME_SCREEN_PATH);
                          }
                        },
                        builder: (context, state) {
                          // Show error UI if login failed
                          if (state is LoginError) {
                            return Column(
                              children: [
                                ErrorUIBuilder.buildErrorUI(
                                  context: context,
                                  error: state.message,
                                  onRetry: () {
                                    if (!formKey.currentState!.validate()) return;
                                    context.read<LoginBloc>().add(
                                          CreateloginLoginEvent({
                                            "username": _usernameController.text,
                                            "password": _passwordController.text
                                          }),
                                        );
                                  },
                                ),
                              ],
                            );
                          }
                          
                          bool isLoading = state is LoginLoading;
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!.validate())
                                        return;
                                      context.read<LoginBloc>().add(
                                            CreateloginLoginEvent({
                                              "username":
                                                  _usernameController.text,
                                              "password":
                                                  _passwordController.text
                                            }),
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF0D6EFD),
                                disabledBackgroundColor:
                                    const Color(0xFF0D6EFD).withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 3,
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
                                  : Text(
                                      l10n.login,
                                      style: GoogleFonts.inter(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAccount + " ",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.WELCOME_ROUTE_PATH),
                      child: Text(
                        l10n.signUp,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D6EFD),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    context
        .read<FetchUsersBloc>()
        .add(RegisterFcmTokenEvent(deviceToken: token.toString()));
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required AppLocalizations l10n,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (value) =>
          value == null || value.isEmpty ? l10n.fieldCannotBeEmpty : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF6F7F9),
        hintStyle: GoogleFonts.inter(
          color: Colors.grey.shade500,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
