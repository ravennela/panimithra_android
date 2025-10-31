import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            context.push(AppRoutes.CREATE_SUBSCRIPTION_PLAN_SCREEN_PATH);
          }),
      body: Column(
        children: [Text("Subscription Plan Screen")],
      ),
    );
  }
}
