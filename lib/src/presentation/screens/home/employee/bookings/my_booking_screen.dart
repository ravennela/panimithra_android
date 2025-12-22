import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/fetch_bookins_model.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_bloc.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_event.dart';
import 'package:panimithra/src/presentation/bloc/booking_bloc/booking_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

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

  bool isActionLoading = false;

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
              'My Bookings',
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
              child: const Icon(Icons.notifications_none_rounded,
                  color: Color(0xFF1A1D1E)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  'Manage all your assigned service bookings here.',
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: BlocConsumer<BookingBloc, BookingState>(
                  buildWhen: (previous, current) {
                    return (current is BookingLoadedState ||
                            current is BookingErrorState) ||
                        (page == 0 && current is BookingLoadingState);
                  },
                  listener: (context, state) {
                    if (state is UpdateBookingStatusLoading) {
                      setState(() {
                        isActionLoading = true;
                      });
                    }
                    if (state is BookingLoadedState) {
                      isLoading = false;
                      totalRecords = state.totalRecords;
                      totalLength = state.item.length;
                    }
                    if (state is UpdateBookingStatusLoaded) {
                      setState(() {
                        isActionLoading = false;
                      });
                      ToastHelper.showToast(
                          context: context,
                          type: "success",
                          title: "Updated Booking Status Successfully");
                      context.read<BookingBloc>().add(FetchBookingsEvent(0));
                    }
                    if (state is UpdateBookingStatusError) {
                      setState(() {
                        isActionLoading = false;
                      });
                      ToastHelper.showToast(
                          context: context,
                          type: "error",
                          title: state.message);
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
                              'Error loading Bookings',
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
                              onPressed: () {
                                context
                                    .read<BookingBloc>()
                                    .add(FetchBookingsEvent(0));
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is BookingLoadedState) {
                      return state.totalRecords > 0
                          ? ListView.builder(
                              controller: _scrollController,
                              itemCount: state.item.length + 1,
                              itemBuilder: (context, index) {
                                if (index >= state.item.length) {
                                  return Visibility(
                                      visible: state.totalRecords <=
                                              state.item.length
                                          ? false
                                          : true,
                                      child: const Center(
                                          child: CircularProgressIndicator()));
                                }

                                return BookingCardUltraUC(
                                  item: state.item[index],
                                  onTap: () {
                                    context.push(
                                        AppRoutes
                                            .EMPLOYEE_BOOKING_DETAILS_SCREEN_PATH,
                                        extra: {
                                          "bookingId":
                                              state.item[index].bookingId
                                        });
                                  },
                                );
                              })
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2),
                                  Icon(Icons.calendar_today_rounded,
                                      size: 64, color: Colors.grey[300]),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "No Bookings Available",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
          if (isActionLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

class UCTheme {
  static const Color primary = Color(0xFF1A73E8);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF6D6D6D);
  static const Color bgLight = Color(0xFFF7F9FC);
  static const Color card = Colors.white;

  static const double radius = 16;
}

class BookingCardUltraUC extends StatelessWidget {
  final BookingItem item;
  final VoidCallback onTap;

  const BookingCardUltraUC({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Service Icon, Name & Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.cleaning_services_rounded,
                      color: Color(0xFF0EA5E9), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalize(item.serviceName) ?? "Service",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1D1E),
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Booking ID: #${item.bookingId.substring(0, 8)}...',
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\₹${item.amount}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1D1E),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),

            /// Info Rows
            _buildInfoRow(
                Icons.calendar_today_rounded,
                DateFormat("EEE, dd MMM yyyy, hh:mm a")
                    .format(item.bookingDate ?? DateTime.now())),
            const SizedBox(height: 12),
            if (item.location.isNotEmpty || item.city.isNotEmpty) ...[
              _buildInfoRow(
                  Icons.location_on_outlined, "${item.location}, ${item.city}"),
              const SizedBox(height: 12),
            ],
            _buildInfoRow(Icons.person_outline_rounded,
                capitalize(item.userName) ?? "Customer"),

            const SizedBox(height: 20),

            /// Footer: Status & Actions
            Row(
              children: [
                _statusChip(item.bookingStatus),
                const Spacer(),
                if (_shouldShowActions(item.bookingStatus))
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.grey[400], size: 20),
              ],
            ),
            if (_shouldShowActions(item.bookingStatus)) ...[
              const SizedBox(height: 16),
              _buildActionButtons(item.bookingId, item.bookingStatus, context),
            ],
          ],
        ),
      ),
    );
  }

  bool _shouldShowActions(String status) {
    final s = status.toUpperCase();
    return s == "PENDING" || s == "INPROGRESS";
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String? status) {
    Color bg;
    Color text;
    String label = status ?? "Unknown";

    switch (status?.toUpperCase()) {
      case "COMPLETED":
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF10B981);
        break;
      case "INPROGRESS":
        bg = const Color(0xFFF0F9FF);
        text = const Color(0xFF0EA5E9);
        break;
      case "PENDING":
        bg = const Color(0xFFFFF7ED);
        text = const Color(0xFFF97316);
        break;
      case "REJECTED":
      case "CANCELLED":
        bg = const Color(0xFFFEF2F2);
        text = const Color(0xFFEF4444);
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        text = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: bg == const Color(0xFFF3F4F6)
                ? Colors.grey[300]!
                : Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: text,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: text,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      String bookingId, String status, BuildContext context) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  context.read<BookingBloc>().add(UpdateBookingStatusEvent(
                      bookingId: bookingId, bookingStatus: "INPROGRESS"));
                },
                child: const Text("Accept",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFEF4444),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  context.read<BookingBloc>().add(UpdateBookingStatusEvent(
                      bookingId: bookingId, bookingStatus: "REJECTED"));
                },
                child: const Text("Reject",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        );

      case "INPROGRESS":
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0EA5E9).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.read<BookingBloc>().add(
                      UpdateBookingStatusEvent(
                        bookingId: bookingId,
                        bookingStatus: "COMPLETED",
                      ),
                    );
              },
              borderRadius: BorderRadius.circular(14),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Text(
                    "Complete Booking",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
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
