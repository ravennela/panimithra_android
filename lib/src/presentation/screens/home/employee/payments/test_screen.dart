import 'package:flutter/material.dart';

class Subscription {
  final String id;
  final String? endDate;
  final String? startDate;
  final String status;
  final String employeeId;
  final String planId;
  final double price;
  final String? paymentId;
  final String? paymentMethod;
  final String? razorpayOrderId;

  Subscription({
    required this.id,
    this.endDate,
    this.startDate,
    required this.status,
    required this.employeeId,
    required this.planId,
    required this.price,
    this.paymentId,
    this.paymentMethod,
    this.razorpayOrderId,
  });

  bool get isActive => status == 'ACTIVE';
  bool get isPending => status == 'PENDING';

  String get planName {
    // You can customize this based on your plan types
    if (price == 0) return 'Free Plan';
    if (price < 100) return 'Basic Plan';
    if (price < 200) return 'Premium Plan';
    return 'Enterprise Plan';
  }

  String get duration {
    if (startDate == null || endDate == null) return 'Not activated';
    final start = DateTime.parse(startDate!);
    final end = DateTime.parse(endDate!);
    final months = ((end.difference(start).inDays) / 30).round();
    return '$months months';
  }

  String get formattedDateRange {
    if (startDate == null || endDate == null) return 'Pending activation';
    final start = DateTime.parse(startDate!);
    final end = DateTime.parse(endDate!);
    return '${_formatDate(start)} to ${_formatDate(end)}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  int get daysRemaining {
    if (endDate == null) return 0;
    final end = DateTime.parse(endDate!);
    final now = DateTime.now();
    return end.difference(now).inDays;
  }
}

class SubscriptionListScreen extends StatefulWidget {
  const SubscriptionListScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  String? selectedSubscriptionId;

  // Sample data from your database
  final List<Subscription> subscriptions = [
    Subscription(
      id: '022f8687-a140-41f7-8a4a-2e59be507977',
      endDate: '2026-10-25',
      startDate: '2025-10-25',
      status: 'ACTIVE',
      employeeId: 'f2eba15e-58aa-4d0b-b676-9669627e867d',
      planId: 'd30f7c73-af33-11f0-a0c0-862ccfb03cb0',
      price: 0,
    ),
    Subscription(
      id: '4d9d0edf-f512-46e5-beff-57f15c5bb934',
      endDate: '2026-11-05',
      startDate: '2025-11-05',
      status: 'ACTIVE',
      employeeId: '89354047-dabb-41c5-90fe-cbc5fa252c59',
      planId: 'd30f7c73-af33-11f0-a0c0-862ccfb03cb0',
      price: 0,
    ),
    Subscription(
      id: 'b8a1461c-68f3-43f1-9f40-5643d98e0ed1',
      endDate: null,
      startDate: null,
      status: 'PENDING',
      employeeId: 'f2eba15e-58aa-4d0b-b676-9669627e867d',
      planId: 'd30f7c73-af33-11f0-a0c0-862ccfb03cb0',
      price: 160,
    ),
    Subscription(
      id: '877dc795-003b-41bf-ab3f-bce0c66747a7',
      endDate: '2026-11-01',
      startDate: '2025-11-01',
      status: 'ACTIVE',
      employeeId: '4c456d03-66d9-4148-8963-f9a422785fc3',
      planId: 'd30f7c73-af33-11f0-a0c0-862ccfb03cb0',
      price: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Subscriptions',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Subscriptions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your subscription plans',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            ...subscriptions.map((subscription) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildSubscriptionCard(subscription),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(Subscription subscription) {
    final bool isSelected = selectedSubscriptionId == subscription.id;
    final bool isPopular = subscription.isActive && subscription.price == 0;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubscriptionId = subscription.id;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF10B981)
                : subscription.isPending
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFFE5E7EB),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF10B981)
                            : const Color(0xFFD1D5DB),
                        width: 2,
                      ),
                      color: isSelected
                          ? const Color(0xFF10B981)
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Plan Name
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          subscription.planName,
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
                      if (!subscription.isPending) ...[
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
                        subscription.isPending
                            ? 'PENDING'
                            : '\$${subscription.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: subscription.isPending ? 14 : 20,
                          fontWeight: FontWeight.bold,
                          color: subscription.isPending
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
                subscription.formattedDateRange,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),

              if (!subscription.isPending) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    _showDetailsDialog(subscription);
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
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!subscription.isPending) ...[
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
                              'Active subscription with ${subscription.duration} validity',
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
                              '${subscription.daysRemaining} days remaining',
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
                              'Employee ID: ${subscription.employeeId.substring(0, 8)}...',
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
                      color: subscription.isActive
                          ? const Color(0xFF10B981).withOpacity(0.1)
                          : const Color(0xFFF59E0B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: subscription.isActive
                            ? const Color(0xFF10B981).withOpacity(0.3)
                            : const Color(0xFFF59E0B).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          subscription.isActive
                              ? Icons.check_circle
                              : Icons.pending,
                          size: 14,
                          color: subscription.isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          subscription.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: subscription.isActive
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

  void _showDetailsDialog(Subscription subscription) {
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
            _detailRow('Plan ID', subscription.planId),
            _detailRow('Subscription ID', subscription.id),
            _detailRow('Employee ID', subscription.employeeId),
            _detailRow('Status', subscription.status),
            _detailRow('Start Date', subscription.startDate ?? 'N/A'),
            _detailRow('End Date', subscription.endDate ?? 'N/A'),
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
}
