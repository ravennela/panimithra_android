import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/data/models/employee_active_plan_model.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_bloc.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_event.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

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
                        child:
                            // Container(
                            //   margin: const EdgeInsets.only(bottom: 16),
                            //   padding: const EdgeInsets.all(20),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(16),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.black.withOpacity(0.08),
                            //         blurRadius: 10,
                            //         offset: const Offset(0, 2),
                            //       ),
                            //     ],
                            //   ),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       // Header with title and status
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           const Text(
                            //             'Subscription',
                            //             style: TextStyle(
                            //               fontSize: 24,
                            //               fontWeight: FontWeight.bold,
                            //               color: Color(0xFF1F2937),
                            //             ),
                            //           ),
                            //           Container(
                            //             padding: const EdgeInsets.symmetric(
                            //               horizontal: 16,
                            //               vertical: 6,
                            //             ),
                            //             decoration: BoxDecoration(
                            //               color: subscription.status == 'ACTIVE'
                            //                   ? const Color(0xFFD1FAE5)
                            //                   : const Color(0xFFFEE2E2),
                            //               borderRadius: BorderRadius.circular(20),
                            //             ),
                            //             child: Text(
                            //               subscription.status,
                            //               style: TextStyle(
                            //                 fontSize: 14,
                            //                 fontWeight: FontWeight.w600,
                            //                 color: subscription.status == 'ACTIVE'
                            //                     ? const Color(0xFF059669)
                            //                     : const Color(0xFFDC2626),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(height: 20),

                            //       // Plan
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           const Text(
                            //             'Plan:',
                            //             style: TextStyle(
                            //               fontSize: 16,
                            //               color: Color(0xFF6B7280),
                            //               fontWeight: FontWeight.w500,
                            //             ),
                            //           ),
                            //           Text(
                            //             subscription.planname,
                            //             style: const TextStyle(
                            //               fontSize: 16,
                            //               color: Color(0xFF1F2937),
                            //               fontWeight: FontWeight.w600,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(height: 12),

                            //       // Renews on
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           const Text(
                            //             'Renews on:',
                            //             style: TextStyle(
                            //               fontSize: 16,
                            //               color: Color(0xFF6B7280),
                            //               fontWeight: FontWeight.w500,
                            //             ),
                            //           ),
                            //           Text(
                            //             subscription.enDate.toString(),
                            //             style: const TextStyle(
                            //               fontSize: 16,
                            //               color: Color(0xFF1F2937),
                            //               fontWeight: FontWeight.w600,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(height: 12),

                            //       // Amount
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           const Text(
                            //             'Amount:',
                            //             style: TextStyle(
                            //               fontSize: 16,
                            //               color: Color(0xFF6B7280),
                            //               fontWeight: FontWeight.w500,
                            //             ),
                            //           ),
                            //           Text(
                            //             subscription.price.toString(),
                            //             style: const TextStyle(
                            //               fontSize: 16,
                            //               color: Color(0xFF1F2937),
                            //               fontWeight: FontWeight.w600,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(height: 18),

                            //       // Divider
                            //       Container(
                            //         height: 1,
                            //         color: const Color(0xFFE5E7EB),
                            //       ),
                            //       const SizedBox(height: 16),

                            //       // Renew Now Button
                            //       Center(
                            //         child: TextButton(
                            //           onPressed: () {},
                            //           child: const Text(
                            //             'Renew Now',
                            //             style: TextStyle(
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.w600,
                            //               color: Color(0xFF3B82F6),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            _buildSubscriptionCard(
                                state.paymentsData.plan[index], context),
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

Widget _buildSubscriptionCard(Plan subscription, BuildContext context) {
  final bool isPopular = true && subscription.price == 0;
  return GestureDetector(
    onTap: () {
      context.push(AppRoutes.EMPLOYEE_PLANS_SCREEN_PATH);
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF10B981),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Radio Button

                const SizedBox(width: 12),

                // Plan Name
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        subscription.planname,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F2937),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Most popular',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (subscription.status.toString() != "PENDING") ...[
                      Row(
                        children: [
                          Text(
                            subscription.price > 0
                                ? '-${(subscription.price * 0.5).toInt()}%'
                                : 'FREE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: subscription.price > 0
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      subscription.status == "PENDING"
                          ? 'PENDING'
                          : '\$${subscription.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: subscription.status == "PENDING" ? 14 : 20,
                        fontWeight: FontWeight.bold,
                        color: subscription.status == "PENDING"
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Duration
            Text(
              "${DateFormat("dd MMM yyyy").format(subscription.startDate)} to ${DateFormat("dd MMM yyyy").format(subscription.enDate)}",
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),

            if (!(subscription.status == "PENDING")) ...[
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  _showDetailsDialog(subscription, context);
                },
                child: const Text(
                  'View details',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3B82F6),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Description Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!(subscription.status == "PENDING")) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Active subscription with ${calculateDaysBetween(subscription.startDate ?? DateTime.now(), subscription.enDate ?? DateTime.now())}days validity',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${calculateDaysBetween(DateTime.now(), subscription.enDate)} days remaining',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Employee ID: ${subscription.employeeId}...',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Subscription pending activation',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Complete payment to activate',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Status Badge
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: subscription.status == "ACTIVE"
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        subscription.status == "ACTIVE"
                            ? Icons.check_circle
                            : Icons.pending,
                        size: 14,
                        color: subscription.status == "ACTIVE"
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        subscription.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: subscription.status == "ACTIVE"
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showDetailsDialog(Plan subscription, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('Subscription Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow('Plan ID', subscription.id),
          _detailRow('Subscription ID', subscription.id),
          _detailRow('Employee ID', subscription.employeeId),
          _detailRow('Status', subscription.status),
          _detailRow(
              'Start Date',
              DateFormat("dd/MMM/yyyy").format(subscription.startDate) ??
                  'N/A'),
          _detailRow('End Date',
              DateFormat("dd/MMM/yyyy").format(subscription.enDate) ?? 'N/A'),
          _detailRow('Price', '\$${subscription.price.toStringAsFixed(2)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
