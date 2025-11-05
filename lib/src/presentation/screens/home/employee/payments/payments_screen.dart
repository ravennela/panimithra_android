import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_bloc.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_event.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_state.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<EmployeePaymentBloc>()
        .add(LoadEmployeePaymentsEvent(userId: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E7EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5E7EB),
        elevation: 0,
        title: const Text(
          'Payments',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Color(0xFF1F2937),
              size: 28,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<EmployeePaymentBloc, EmployeePaymentState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EmployeePaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EmployeePaymentError) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading Employee Plans',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is EmployeePaymentLoaded) {
            return state.paymentsData.plan.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.paymentsData.plan.length,
                    itemBuilder: (context, index) {
                      final subscription = state.paymentsData.plan[index];
                      return GestureDetector(
                        onTap: () {
                         
                          context.push(AppRoutes.EMPLOYEE_PLANS_SCREEN_PATH);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with title and status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Subscription',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: subscription.status == 'ACTIVE'
                                          ? const Color(0xFFD1FAE5)
                                          : const Color(0xFFFEE2E2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      subscription.status,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: subscription.status == 'ACTIVE'
                                            ? const Color(0xFF059669)
                                            : const Color(0xFFDC2626),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Plan
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Plan:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    subscription.planname,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1F2937),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Renews on
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Renews on:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    subscription.enDate.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1F2937),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Amount
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Amount:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    subscription.price.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF1F2937),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Divider
                              Container(
                                height: 1,
                                color: const Color(0xFFE5E7EB),
                              ),
                              const SizedBox(height: 16),

                              // Renew Now Button
                              Center(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Renew Now',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3B82F6),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.36),
                        const Text("No Employee Plan Available"),
                      ],
                    ),
                  );
          }
          return Container();
        },
      ),
    );
  }
}
