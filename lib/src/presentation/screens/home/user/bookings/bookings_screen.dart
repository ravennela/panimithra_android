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
import 'package:shimmer/shimmer.dart';
import 'package:panimithra/l10n/app_localizations.dart';
import 'package:panimithra/src/presentation/widget/error_ui_builder.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return BookingScreenWidget();
  }
}

class BookingScreenWidget extends State<BookingsScreen> {
  final ScrollController _scrollController = ScrollController();
  int totalRecords = 0;
  int totalLength = 0;
  int page = 0;
  Timer? _debounce;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchBookingsEvent(0));
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
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
          page += 1;
          context.read<BookingBloc>().add(FetchBookingsEvent(page));
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.myBookings,
          style: const TextStyle(
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
            return _buildShimmerLoading();
          }
          if (state is BookingErrorState) {
            return ErrorUIBuilder.buildErrorUI(
              context: context,
              error: state.message,
              onRetry: () {
                page = 0;
                context.read<BookingBloc>().add(FetchBookingsEvent(0));
              },
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
                            child: _buildPaginationShimmer());
                      }
                      return GestureDetector(
                        onTap: () {
                          context.push(AppRoutes.UserBookingDetailsScreen,
                              extra: {
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
                : ErrorUIBuilder.buildEmptyState(
                    context: context,
                    message: AppLocalizations.of(context)!.yourBookingsWillAppearHere,
                    onRefresh: () {
                      page = 0;
                      context.read<BookingBloc>().add(FetchBookingsEvent(0));
                    },
                  );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 14,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
        ),
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
                _statusTag(context, status),
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
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context)!.rate,
                          style: const TextStyle(
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

  Widget _statusTag(BuildContext context, String status) {
    Color bg;
    Color fg;
    final l10n = AppLocalizations.of(context)!;
    String text = status;

    switch (status.toLowerCase()) {
      case "confirmed":
        bg = Colors.green.withOpacity(0.1);
        fg = Colors.green;
        text = l10n.confirmed;
        break;
      case "completed":
        bg = Colors.blue.withOpacity(0.1);
        fg = Colors.blue;
        text = l10n.completed;
        break;
      case "cancelled":
        bg = Colors.red.withOpacity(0.1);
        fg = Colors.red;
        text = l10n.cancelled;
        break;
      case "pending":
        bg = Colors.orange.withOpacity(0.1);
        fg = Colors.orange;
        text = l10n.pending;
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
