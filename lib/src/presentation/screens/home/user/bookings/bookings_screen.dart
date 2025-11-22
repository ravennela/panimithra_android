import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/top_five_rating_model.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';
import 'package:panimithra/src/presentation/widget/rating_dialog.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return BookingScreenWidget();
  }
}

class BookingScreenWidget extends State<BookingsScreen> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int totalRecords = 0;
  int totalLength = 0;
  int page = 1;
  int x = 0;
  String searchString = "";
  Timer? _debounce;
  Timer? _searchDebounce;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchBookingsEvent(0));
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    _searchDebounce?.cancel();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (isLoading) {
      return;
    }
    if (!mounted) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (totalLength >= totalRecords) {
          return;
        }
        if (totalLength <= totalRecords) {
          x = 2;
          page += 1;
          context.read<BookingBloc>().add(FetchBookingsEvent(page));
        }
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _callApi(query); // Trigger the API
    });
  }

  _callApi(String query) {
    if (query.isEmpty) {
      page = 0;
    }
    context.read<BookingBloc>().add(FetchBookingsEvent(page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        buildWhen: (previous, current) {
          return (current is BookingLoadedState ||
                  current is BookingErrorState) ||
              (page == 0 && current is BookingLoadingState);
        },
        listener: (context, state) {
          if (state is BookingLoadedState) {
            isLoading = false;
            totalRecords = state.totalRecords;
            totalLength = state.item.length;
          }
          if (state is BookingLoadingState) {
            isLoading = true;
          }
          if (state is BookingErrorState) {
            isLoading = false;
            ToastHelper.showToast(
              context: context,
              type: 'error',
              title: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is BookingLoadingState && page == 0) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookingErrorState) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading Site Manager',
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
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is BookingLoadedState) {
            return state.totalRecords > 0
                ? ListView.builder(
                    itemCount: state.item.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.item.length) {
                        return Visibility(
                            visible: state.totalRecords <= state.item.length
                                ? false
                                : true,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      }
                      return GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.BookingDetailsScreen, extra: {
                            "bookingId": state.item[index].bookingId
                          });
                        },
                        child: BookingTile(
                          amount: state.bookings.data[index].amount.toString(),
                          bookingDate: DateFormat("dd/MMM/yyyy").format(
                              state.bookings.data[index].bookingDate ??
                                  DateTime.now()),
                          provider: state.bookings.data[index].employeeName,
                          serviceName: capitalize(state.item[index].name),
                          status: state.item[index].bookingStatus.toString(),
                          timeSlot: "",
                          icon: Icons.settings,
                          bookingId: state.item[index].bookingId,
                          employeeId: state.item[index].employeeId,
                          serviceId: state.item[index].serviceId,
                          createdAt: '',
                        ),
                      );
                    })
                : Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.34),
                      Center(child: const Text("No Bookings Available")),
                    ],
                  );
          }
          return Container();
        },
      ),
    );
  }
}

class BookingTile extends StatelessWidget {
  final String serviceName;
  final String bookingDate;
  final String amount;
  final String createdAt;
  final String provider;
  final String timeSlot; // "07:45 AM - 09:45 AM"
  final String status; // Confirmed, Cancelled, InProgress
  final IconData icon;
  final String serviceId;
  final String bookingId;
  final String employeeId;

  const BookingTile({
    super.key,
    required this.serviceName,
    required this.bookingDate,
    required this.amount,
    required this.createdAt,
    required this.provider,
    required this.timeSlot,
    required this.status,
    required this.serviceId,
    required this.employeeId,
    required this.bookingId,
    this.icon = Icons.cleaning_services,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _serviceIcon(),
              const SizedBox(width: 16),
              Expanded(child: _serviceInfo()),
            ],
          ),
          const SizedBox(height: 14),

          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 14),

          // BOTTOM INFO
          _infoRow("📅 Booking Date", bookingDate),
          _infoRow("💳 Total Amount", amount),
          _infoRow(
            "🕒 Provider",
            provider,
          ),

          const SizedBox(height: 12),

          // STATUS TAG
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showRatingDialog(
                      context, provider, serviceId, employeeId, bookingId);
                },
                child: const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 18,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showRatingDialog(
                      context, provider, serviceId, employeeId, bookingId);
                },
                child: const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 18,
                ),
              ),
              Expanded(child: Container()),
              _statusTag(status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceIcon() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: 30, color: Colors.blue),
    );
  }

  Widget _serviceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          serviceName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(timeSlot,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _statusTag(String status) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case "confirmed":
        bg = Colors.green.shade100;
        fg = Colors.green.shade700;
        break;
      case "cancelled":
        bg = Colors.red.shade100;
        fg = Colors.red.shade700;
        break;
      default:
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade700;
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
