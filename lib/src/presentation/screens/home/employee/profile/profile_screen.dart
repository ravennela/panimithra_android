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
import 'package:shimmer/shimmer.dart';
import 'package:panimithra/l10n/app_localizations.dart';
import 'package:panimithra/src/presentation/widget/error_ui_builder.dart';
import 'package:panimithra/src/presentation/cubit/locale/locale_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchUsersBloc>().add(const GetUserProfileEvent(userId: ""));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final l10n = AppLocalizations.of(context)!;

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
            return _buildShimmerLoading(primaryColor);
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
                              user.fullName ?? l10n.employeeNameDefault,
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
                              title: l10n.accountSettings,
                              items: [
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.person_rounded,
                                  title: l10n.aboutUs,
                                  color: Colors.blue,
                                  onTap: () => context
                                      .push(AppRoutes.ABOUT_US_SCREEN_PATH),
                                ),
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.lock_rounded,
                                  title: l10n.changePassword,
                                  color: Colors.orange,
                                  onTap: () => context
                                      .push(AppRoutes.RESET_PASSWORD_SCREEN),
                                ),
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.language_rounded,
                                  title: l10n.changeLanguage,
                                  color: Colors.green,
                                  onTap: () => _showLanguageDialog(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSection(
                              context,
                              title: l10n.supportLegal,
                              items: [
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.help_center_rounded,
                                  title: l10n.helpSupport,
                                  color: Colors.teal,
                                  onTap: () => context
                                      .push(AppRoutes.HELP_SUPPORT_SCREEN_PATH),
                                ),
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.description_rounded,
                                  title: l10n.termsConditions,
                                  color: Colors.purple,
                                  onTap: () => UrlLauncherHelper.launchWebUrl(
                                      'https://dynamic-lolly-961756.netlify.app/',
                                      context: context),
                                ),
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.shield_rounded,
                                  title: l10n.privacyPolicy,
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
                              title: l10n.login,
                              items: [
                                _buildProfileMenuItem(
                                  context,
                                  icon: Icons.logout_rounded,
                                  title: l10n.signOut,
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
                                    "${l10n.appVersion} 1.0.0",
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
    return ErrorUIBuilder.buildErrorUI(
      context: context,
      error: message,
      onRetry: () {
        context.read<FetchUsersBloc>().add(const GetUserProfileEvent(userId: ""));
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.signOut),
          content: Text(l10n.signOutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel, style: const TextStyle(color: Colors.grey)),
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
              child: Text(l10n.signOut,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerLoading(Color primaryColor) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 280.0,
          backgroundColor: primaryColor.withOpacity(0.1),
          flexibleSpace: FlexibleSpaceBar(
            background: Shimmer.fromColors(
              baseColor: primaryColor.withOpacity(0.2),
              highlightColor: primaryColor.withOpacity(0.1),
              child: Container(color: Colors.white),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -28),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
              child: Column(
                children: List.generate(3, (index) => _buildMenuItemShimmer()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemShimmer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: Container(
              height: 18,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.selectLanguage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 32),
              _buildLanguageOption(context, "English", "en", "🇺🇸"),
              const SizedBox(height: 12),
              _buildLanguageOption(context, "हिन्दी", "hi", "🇮🇳"),
              const SizedBox(height: 12),
              _buildLanguageOption(context, "తెలుగు", "te", "🇮🇳"),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String name, String code, String flag) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final isSelected = currentLocale == code;

    return InkWell(
      onTap: () {
        context.read<LocaleCubit>().setLocale(code);
        Navigator.pop(context);
        ToastHelper.showToast(
          context: context,
          type: "success",
          title: AppLocalizations.of(context)!.languageChanged,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.blue[700] : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }
}
