import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return MyBookingsScreenWidget();
  }
}

class MyBookingsScreenWidget extends State<MyBookingsScreen> {
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Manage all your assigned service bookings',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          BlocConsumer<BookingBloc, BookingState>(
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
              if (state is BookingInitalState && page == 0) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is BookingErrorState) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading Site Manager',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: state.item.length + 1,
                            itemBuilder: (context, index) {
                              if (index >= state.item.length) {
                                return Visibility(
                                    visible:
                                        state.totalRecords <= state.item.length
                                            ? false
                                            : true,
                                    child: const Center(
                                        child: CircularProgressIndicator()));
                              }

                              return BookingCard(booking: state.item[index]);
                            }),
                      )
                    : Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.26),
                          const Text("No Bookings Available"),
                        ],
                      );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingItem booking;

  const BookingCard({Key? key, required this.booking}) : super(key: key);

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFF3E0);
      case 'accepted':
        return const Color(0xFFE3F2FD);
      case 'completed':
        return const Color(0xFFE8F5E9);
      case 'cancelled':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF57C00);
      case 'accepted':
        return const Color(0xFF1976D2);
      case 'completed':
        return const Color(0xFF388E3C);
      case 'cancelled':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Info Row
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage:
                    NetworkImage("https://i.pravatar.cc/150?img=1"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.serviceName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(booking.bookingStatus),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.bookingStatus,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: getStatusTextColor(booking.bookingStatus),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Date Time
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd/MMM/yyyy')
                    .format(booking.bookingDate ?? DateTime(0, 0, 0, 0)),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Location
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.city,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),

          // Action Buttons - Conditional based on status
          if (booking.bookingStatus.toLowerCase() == 'pending') ...[
            const SizedBox(height: 16),
            BlocConsumer<BookingBloc, BookingState>(
              listener: (context, bookState) {
                if (bookState is UpdateBookingStatusError) {
                  ToastHelper.showToast(
                      context: context,
                      type: "error",
                      title: bookState.message);
                }
                if (bookState is UpdateBookingStatusLoaded) {
                  ToastHelper.showToast(
                      context: context,
                      type: "success",
                      title: "Booking Status Updated Successfully");
                  context.read<BookingBloc>().add(FetchBookingsEvent(0));
                }
              },
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<BookingBloc>().add(
                              UpdateBookingStatusEvent(
                                  bookingId: booking.bookingId,
                                  bookingStatus: "REJECTED"));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<BookingBloc>().add(
                              UpdateBookingStatusEvent(
                                  bookingId: booking.bookingId,
                                  bookingStatus: "INPROGRESS"));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],

          if (booking.bookingStatus.toLowerCase() == 'accepted' ||
              booking.bookingStatus.toLowerCase() == "inprogress") ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: BlocListener<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state is UpdateBookingStatusLoaded) {
                    context.read<BookingBloc>().add(FetchBookingsEvent(0));
                  }
                  if (state is UpdateBookingStatusError) {
                    ToastHelper.showToast(
                        context: context, type: "error", title: state.message);
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    context.read<BookingBloc>().add(UpdateBookingStatusEvent(
                        bookingId: booking.bookingId,
                        bookingStatus: "COMPLETED"));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Mark as Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Booking Model
class Booking {
  final String customerName;
  final String customerImage;
  final String serviceType;
  final String status;
  final String dateTime;
  final String location;

  Booking({
    required this.customerName,
    required this.customerImage,
    required this.serviceType,
    required this.status,
    required this.dateTime,
    required this.location,
  });
}
