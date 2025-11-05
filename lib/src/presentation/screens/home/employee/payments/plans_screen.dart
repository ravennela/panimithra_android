import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_event.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

class MyPlansScreen extends StatefulWidget {
  const MyPlansScreen({super.key});

  @override
  State<MyPlansScreen> createState() => _MyPlansScreenState();
}

class _MyPlansScreenState extends State<MyPlansScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlanBloc>().add(const FetchPlansEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Subscription Plans',
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<PlanBloc, PlanState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FetchPlansError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PlanBloc>().add(const FetchPlansEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is FetchPlansLoading) {
            return const CircularProgressIndicator();
          }
          if (state is FetchPlansLoaded) {
            return ListView.builder(
              itemCount: state.fetchPlanModel.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.CHECKOUT_SCREEN_PATH,
                      extra: {
                        'planId': state.fetchPlanModel.data[index].planId,
                        'price': state.fetchPlanModel.data[index].price,
                        'planName': state.fetchPlanModel.data[index].planName
                      },
                    );
                  },
                  child: SubscriptionCard(
                    title: state.fetchPlanModel.data[index].planName,
                    price: state.fetchPlanModel.data[index].price.toString(),
                    period:
                        planHelper(state.fetchPlanModel.data[index].duration),
                    description:
                        state.fetchPlanModel.data[index].planDescription,
                    isActive:
                        state.fetchPlanModel.data[index].status.toString() ==
                                "ACTIVE"
                            ? true
                            : false,
                  ),
                );
              },
              padding: const EdgeInsets.all(16.0),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String description;
  final bool isActive;

  const SubscriptionCard({
    Key? key,
    required this.title,
    required this.price,
    required this.period,
    required this.description,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFD4F4E2)
                      : const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF00A85A)
                        : const Color(0xFF9E9E9E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B7EFF),
                  ),
                ),
                TextSpan(
                  text: ' / $period',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0B7EFF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF9E9E9E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
