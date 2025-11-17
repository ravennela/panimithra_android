import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreenTest extends StatelessWidget {
  final String serviceName;
  final String description;
  final String bookingId;
  final DateTime bookingDate;
  final String bookingStatus;
  final double totalAmount;
  final String paymentStatus;
  final String employeeId;

  const BookingDetailsScreenTest({
    super.key,
    required this.serviceName,
    required this.description,
    required this.bookingId,
    required this.bookingDate,
    required this.bookingStatus,
    required this.totalAmount,
    required this.paymentStatus,
    required this.employeeId,
  });

  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "COMPLETED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      case "PENDING":
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        title: const Text("Booking Details",
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: paymentStatus.toUpperCase() == "PAID"
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -2),
                    blurRadius: 5,
                    color: Color(0x11000000),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Call your API or navigate
                    print("Mark Payment as Paid clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Mark Payment as Paid",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.06),
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: getStatusColor(bookingStatus), size: 26),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Booking ${bookingStatus.toLowerCase()}",
                        style: TextStyle(
                          fontSize: 16,
                          color: getStatusColor(bookingStatus),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Your booking is processed successfully",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // BOOKING DETAILS CARD
            _buildCard(
              title: "Booking Details",
              child: Column(
                children: [
                  _tile(
                      "Service", serviceName + "jhbgfcvbnm,fcvgbnmkcfvgbhnmk"),
                  _tile("Description", description),
                  _tile("Booking ID", bookingId),
                  _tile(
                    "Booking Date",
                    DateFormat('dd MMM yyyy').format(bookingDate),
                  ),

                  /// **Fixed Time Slot (you can change later)**
                  _tile("Time Slot", "07:45 AM – 09:45 PM"),

                  _tile("Assigned Employee", employeeId),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // PAYMENT SUMMARY CARD
            _buildCard(
              title: "Payment Summary",
              child: Column(
                children: [
                  _tile("Total Amount", "₹ $totalAmount"),
                  _tile("Payment Status", paymentStatus),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _tile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 130,
              child: Text(label,
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500))),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.06),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
