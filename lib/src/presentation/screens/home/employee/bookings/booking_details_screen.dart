import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

class EmployeeBookingDetailsScreen extends StatefulWidget {
  final String bookingId;
  const EmployeeBookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<StatefulWidget> createState() {
    return BookingDetailsWidget();
  }
}

class BookingDetailsWidget extends State<EmployeeBookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchBookingDetailsEvent(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<BookingBloc, BookingState>(
          buildWhen: (previous, current) => (current is BookingDetailsLoading ||
              current is BookingDetailsError ||
              current is BookingDetailsLoaded),
          listener: (context, state) {
            if (state is UpdatePaymentStatusLoaded) {
              ToastHelper.showToast(
                  context: context,
                  type: "success",
                  title: "Status Changed Successfully");
              context.pop();
            }
            if(state is UpdatePaymentStatusError){
              ToastHelper.showToast(
                  context: context,
                  type: "error",
                  title: state.message);
            }
          },
          builder: (context, state) {
            if (state is BookingDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BookingDetailsError) {
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
                      'Failed to load services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<BookingBloc>()
                            .add(FetchBookingDetailsEvent(widget.bookingId));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (state is BookingDetailsLoaded) {
              return Scaffold(
                backgroundColor: const Color(0xffF6F6F6),
                appBar: AppBar(
                  title: const Text("Booking Details",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
                bottomNavigationBar: state.bookingDetails.paymentStatus
                                .toUpperCase() !=
                            "PAID" ||
                        state.bookingDetails.paymentStatus == ""
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
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
                          child: BlocListener<BookingBloc, BookingState>(
                            listener: (context, state) {
                              if (state is UpdateBookingStatusError) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: "error",
                                    title: state.message);
                              }
                              if (state is UpdateBookingStatusLoaded) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: "success",
                                    title:
                                        "Payment Status Updated Successfully");
                                context.read<BookingBloc>().add(
                                    FetchBookingDetailsEvent(widget.bookingId));
                                context
                                    .read<BookingBloc>()
                                    .add(FetchBookingsEvent(0));
                                context.pop();
                              }
                            },
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<BookingBloc>().add(
                                    UpdatePaymentStatusEvent(
                                        bookingId: widget.bookingId));
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
                                color: getStatusColor(
                                    state.bookingDetails.bookingStatus),
                                size: 26),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Booking ${state.bookingDetails.bookingStatus.toLowerCase()}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: getStatusColor(
                                        state.bookingDetails.bookingStatus),
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
                      _buildCard(
                        title: "Booking Details",
                        child: Column(
                          children: [
                            _tile("Service",
                                capitalize(state.bookingDetails.serviceName)),
                            _tile(
                                "Description",
                                capitalize(
                                    state.bookingDetails.serviceDescription)),
                            _tile("Customer Name",
                                capitalize(state.bookingDetails.customerName)),
                            _tile("Customer Mobile",
                                state.bookingDetails.customerContactNumber),
                            _tile(
                              "Booking Date",
                              DateFormat('dd MMM yyyy').format(
                                  state.bookingDetails.bookDate ??
                                      DateTime.now()),
                            ),
                            _tile("Assigned Employee",
                                capitalize(state.bookingDetails.providerName)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // PAYMENT SUMMARY CARD
                      _buildCard(
                        title: "Payment Summary",
                        child: Column(
                          children: [
                            _tile("Total Amount",
                                "₹ ${state.bookingDetails.price}"),
                            _tile(
                                "Payment Status",
                                state.bookingDetails.paymentStatus != ""
                                    ? state.bookingDetails.paymentStatus
                                    : "NOT PAYED"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
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
}
