import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF6A82FB),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔷 Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A82FB), Color(0xFFFF5E62)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: const [
                  Icon(
                    Icons.handshake_outlined,
                    color: Colors.white,
                    size: 64,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Panimithra",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Service Management Made Simple",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📄 About Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _infoCard(
                    title: "Who We Are",
                    content:
                        "Panimithra is a workforce and service management platform "
                        "designed to streamline operations between administrators "
                        "and field professionals.",
                  ),

                  _infoCard(
                    title: "What We Do",
                    content:
                        "We help manage service requests, track operational activities, "
                        "and empower professionals with a reliable and secure system.",
                  ),

                  _infoCard(
                    title: "Our Vision",
                    content:
                        "To simplify service operations and enable professionals "
                        "to focus on delivering quality work with confidence.",
                  ),

                  const SizedBox(height: 20),

                  /// ℹ️ App Info
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          Text(
                            "App Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          _InfoRow(label: "Version", value: "1.0.0"),
                          _InfoRow(label: "Platform", value: "Panimithra App"),
                          _InfoRow(label: "Support", value: "Admin Managed"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// © Footer
                  const Text(
                    "© 2025 Panimithra. All rights reserved.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String content}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Reusable row for app info
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
