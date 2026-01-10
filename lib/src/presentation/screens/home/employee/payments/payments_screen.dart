import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/data/models/employee_active_plan_model.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_bloc.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_event.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:panimithra/l10n/app_localizations.dart';

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
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payments',
              style: TextStyle(
                color: Color(0xFF1A1D1E),
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.history_rounded,
                color: Color(0xFF1A1D1E),
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<EmployeePaymentBloc, EmployeePaymentState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EmployeePaymentLoading) {
            return _buildShimmerLoading();
          }
          if (state is EmployeePaymentError) {
            final l10n = AppLocalizations.of(context)!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animated Error Icon with Gradient Background
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFEF4444).withOpacity(0.1),
                                  const Color(0xFFF97316).withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEF4444).withOpacity(0.2),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.error_outline_rounded,
                              size: 64,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Error Title
                    Text(
                      l10n.oopsSomethingWentWrong,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1D1E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Error Message
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Retry Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<EmployeePaymentBloc>()
                              .add(LoadEmployeePaymentsEvent(userId: ""));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0EA5E9),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          shadowColor: const Color(0xFF0EA5E9).withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.refresh_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.tryAgain,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.credit_card_off_rounded,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text(
                          "No Active Plans",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Subscribe to a plan to get started",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFD1D5DB),
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.white,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildSubscriptionCard(Plan subscription, BuildContext context) {
  final bool isActive = subscription.status == "ACTIVE";
  final bool isPending = subscription.status == "PENDING";

  return GestureDetector(
    onTap: () {
      if (isActive) {
        context.push(AppRoutes.EMPLOYEE_PLANS_SCREEN_PATH);
      } else {
        context.push(AppRoutes.EMPLOYEE_PLANS_SCREEN_PATH);
      }
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? const Color(0xFF10B981).withOpacity(0.12)
                : Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: isActive
            ? Border.all(
                color: const Color(0xFF10B981).withOpacity(0.3), width: 1.5)
            : Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            if (isActive)
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isActive ? 'ACTIVE PLAN' : 'PENDING PAYMENT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: isActive
                                ? const Color(0xFF059669)
                                : const Color(0xFFD97706),
                          ),
                        ),
                      ),
                      Text(
                        '\₹${subscription.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1D1E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subscription.planname,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1D1E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isPending
                            ? 'Valid until payment complete'
                            : '${DateFormat("d MMM yyyy").format(subscription.startDate)} - ${DateFormat("d MMM yyyy").format(subscription.enDate)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 1),
                  ),
                  if (isActive)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Employee ID',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subscription.employeeId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_forward_rounded,
                              size: 18, color: Color(0xFF4B5563)),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1D1E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          context.push(AppRoutes.EMPLOYEE_PLANS_SCREEN_PATH);
                        },
                        child: const Text(
                          'Complete Payment',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
