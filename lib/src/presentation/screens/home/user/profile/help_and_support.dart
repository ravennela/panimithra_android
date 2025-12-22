import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/presentation/widget/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _supportTile(
            context,
            icon: Icons.help_outline,
            title: 'FAQs',
            subtitle: 'Find answers quickly',
            onTap: () {
              context.push(AppRoutes.FAQ_SCREEN_PATH);
              // Navigate to FAQs screen (next step)
            },
          ),
          _supportTile(
            context,
            icon: Icons.email_outlined,
            title: 'Contact Support',
            subtitle: 'Write to our team',
            onTap: () {
              UrlLauncherHelper.launchEmail("kullaraki@gmail.com",
                  context: context);
              // Email action (later)
            },
          ),
          _supportTile(
            context,
            icon: Icons.call_outlined,
            title: 'Call Us',
            subtitle: 'Talk to us directly',
            onTap: () {
              UrlLauncherHelper.launchPhone("9347573451", context: context);
              // Call action (later)
            },
          ),
        ],
      ),
    );
  }

  Widget _supportTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
