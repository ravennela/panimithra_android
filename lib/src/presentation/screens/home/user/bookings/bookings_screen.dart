import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
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
  int page = 0;
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
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            height: 1.0,
          ),
        ),
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
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF1A1D1E),
              ),
            );
          }
          if (state is BookingErrorState) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading Bookings',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D1E)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookingBloc>().add(FetchBookingsEvent(0));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1D1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Retry',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }
          if (state is BookingLoadedState) {
            return state.totalRecords > 0
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    itemCount: state.item.length + 1,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index >= state.item.length) {
                        return Visibility(
                            visible: state.totalRecords <= state.item.length
                                ? false
                                : true,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            ));
                      }
                      return GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.BookingDetailsScreen, extra: {
                            "bookingId": state.item[index].bookingId
                          });
                        },
                        child: BookingTile(
                          amount: state.item[index].amount.toString(),
                          bookingDate: DateFormat("MMM dd, yyyy").format(
                              state.item[index].bookingDate ?? DateTime.now()),
                          provider: state.item[index].employeeName,
                          serviceName: capitalize(state.item[index].name),
                          status: state.item[index].bookingStatus.toString(),
                          timeSlot: "",
                          icon: Icons.cleaning_services_rounded,
                          bookingId: state.item[index].bookingId,
                          employeeId: state.item[index].employeeId,
                          serviceId: state.item[index].serviceId,
                          createdAt: '',
                        ),
                      );
                    })
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.calendar_today_rounded,
                              size: 48, color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "No Bookings Found",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1D1E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your bookings will appear here",
                          style: TextStyle(color: Colors.grey[500]),
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
}

class BookingTile extends StatelessWidget {
  final String serviceName;
  final String bookingDate;
  final String amount;
  final String createdAt;
  final String provider;
  final String timeSlot;
  final String status;
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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _serviceInfo(context)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FD),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: Colors.grey.withOpacity(0.05)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 8),
                    Text(
                      bookingDate,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1D1E),
                      ),
                    ),
                  ],
                ),
                _statusTag(status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                serviceName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1D1E),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '₹$amount',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D1E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.person_rounded, size: 14, color: Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            Text(
              provider,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            if (status.toLowerCase() ==
                "completed") // Only show rating for completed
              GestureDetector(
                onTap: () {
                  showRatingDialog(
                      context, provider, serviceId, employeeId, bookingId);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                      SizedBox(width: 4),
                      Text("Rate",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ))
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _statusTag(String status) {
    Color bg;
    Color fg;
    String text = status;

    switch (status.toLowerCase()) {
      case "confirmed":
        bg = Colors.green.withOpacity(0.1);
        fg = Colors.green;
        break;
      case "completed":
        bg = Colors.blue.withOpacity(0.1);
        fg = Colors.blue;
        break;
      case "cancelled":
        bg = Colors.red.withOpacity(0.1);
        fg = Colors.red;
        break;
      case "pending":
        bg = Colors.orange.withOpacity(0.1);
        fg = Colors.orange;
        break;
      default:
        bg = Colors.grey.withOpacity(0.1);
        fg = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
