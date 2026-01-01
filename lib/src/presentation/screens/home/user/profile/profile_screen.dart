import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';
import 'package:panimithra/src/presentation/widget/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchUsersBloc>().add(const GetUserProfileEvent(userId: ""));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      body: BlocConsumer<FetchUsersBloc, FetchUsersState>(
        buildWhen: (previous, current) => (current is UserProfileError ||
            current is UserProfileLoaded ||
            current is UserProfileLoading),
        listener: (context, state) {
          if (state is UserProfileError) {
            ToastHelper.showToast(
                context: context, type: "error", title: state.message);
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileError) {
            return _buildErrorState(state.message, primaryColor);
          }

          if (state is UserProfileLoaded) {
            final user = state.userProfileModel;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Premium Header with Profile Info
                SliverAppBar(
                  expandedHeight: 280.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: primaryColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.7)
                              ],
                            ),
                          ),
                        ),
                        // Decorative Circles
                        Positioned(
                          right: -50,
                          top: -50,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        Positioned(
                          left: -30,
                          bottom: 50,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white.withOpacity(0.03),
                          ),
                        ),
                        // Profile Info
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    const AssetImage('assets/profile.png'),
                                onBackgroundImageError: (_, __) {},
                                child: user.fullName == null
                                    ? const Icon(Icons.person,
                                        size: 50, color: Colors.grey)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.fullName ?? "User Name",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email ?? user.phoneNumber ?? "",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Body Section
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -28),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection(
                              context,
                              title: "Account Settings",
                              items: [
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.person_rounded,
                                  title: "About Us",
                                  color: Colors.blue,
                                  onTap: () => context
                                      .push(AppRoutes.ABOUT_US_SCREEN_PATH),
                                ),
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.lock_rounded,
                                  title: "Change Password",
                                  color: Colors.orange,
                                  onTap: () => context
                                      .push(AppRoutes.RESET_PASSWORD_SCREEN),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSection(
                              context,
                              title: "Support & Legal",
                              items: [
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.help_center_rounded,
                                  title: "Help & Support",
                                  color: Colors.teal,
                                  onTap: () => context
                                      .push(AppRoutes.HELP_SUPPORT_SCREEN_PATH),
                                ),
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.description_rounded,
                                  title: "Terms & Conditions",
                                  color: Colors.purple,
                                  onTap: () => UrlLauncherHelper.launchWebUrl(
                                      'https://dynamic-lolly-961756.netlify.app/',
                                      context: context),
                                ),
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.shield_rounded,
                                  title: "Privacy Policy",
                                  color: Colors.indigo,
                                  onTap: () => UrlLauncherHelper.launchWebUrl(
                                      'https://694bb0de96fad848212f7f2b--sprightly-sunshine-aac8ce.netlify.app/',
                                      context: context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSection(
                              context,
                              title: "Login",
                              items: [
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.logout_rounded,
                                  title: "Sign Out",
                                  color: Colors.red,
                                  isLast: true,
                                  onTap: () => _showLogoutDialog(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "App Version 1.0.0",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.black54,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 60, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              "Oops! Something went wrong",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context
                  .read<FetchUsersBloc>()
                  .add(const GetUserProfileEvent(userId: "")),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Try Again",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Sign Out"),
        content:
            const Text("Are you sure you want to sign out from your account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
              if (context.mounted) {
                context.go(AppRoutes.LOGIN_ROUTE_PATH);
              }
            },
            child: const Text("Sign Out",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
