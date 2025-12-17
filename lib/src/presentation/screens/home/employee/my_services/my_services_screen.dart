import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/data/models/fetch_service_model.dart';
import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_event.dart';
import 'package:panimithra/src/presentation/bloc/service/service_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isLoadingMore = false;
  int totalRecords = 0;
  int totalLength = 0;
  Timer? _debounce;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(FetchServicesEvent(page: _currentPage));
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
          _currentPage += 1;
          context
              .read<ServiceBloc>()
              .add(FetchServicesEvent(page: _currentPage));
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentPage = 0;
      _isLoadingMore = false;
    });
    context.read<ServiceBloc>().add(const FetchServicesEvent(page: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.CREATE_SERVICE_PATH);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Services',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Performance Overview',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Services List
            Expanded(
              child: BlocConsumer<ServiceBloc, ServiceState>(
                buildWhen: (previous, current) =>
                    ((current is ServiceLoaded || current is ServiceError) ||
                        (current is ServiceLoading && _currentPage == 0)),
                listener: (context, state) {
                  if (state is ServiceLoaded) {
                    totalRecords = state.totalRecords;
                    totalLength = state.data?.length ?? 0;
                    isLoading = false;
                  } else if (state is ServiceError) {
                    isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  if (state is ServiceLoading) {
                    isLoading = true;
                  }
                },
                builder: (context, state) {
                  if (state is ServiceLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2563EB),
                      ),
                    );
                  }

                  if (state is ServiceError && _currentPage == 0) {
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
                            onPressed: _onRefresh,
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

                  if (state is ServiceLoaded) {
                    final services = state.data ?? [];

                    if (services.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No services yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first service to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: const Color(0xFF2563EB),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: services.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show loading indicator at the bottom
                          if (index == services.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            );
                          }

                          final service = services[index];
                          return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 0.6),
                                ),
                                child: Column(
                                  children: [
                                    // TOP SECTION
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // LEFT IMAGE (Large classic style)
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: 95,
                                              height: 95,
                                              color: Colors.grey.shade200,
                                              child: Image.network(
                                                service.iconUrl ?? "",
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 14),

                                          // RIGHT DETAILS
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  capitalize(service.serviceName
                                                          .toString()) ??
                                                      "",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                const SizedBox(height: 6),

                                                Text(
                                                  capitalize(service.description
                                                          .toString()) ??
                                                      "",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    height: 1.3,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),

                                                const SizedBox(height: 10),

                                                // 2-COLUMN INFO GRID
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _infoLabel(
                                                              "Category"),
                                                          _infoValue(capitalize(service
                                                                  .categoryName
                                                                  .toString()) ??
                                                              "N/A"),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _infoLabel(
                                                              "Duration"),
                                                          _infoValue(
                                                              "${timeToDuration(state.data![index].duration ?? 0) ?? 0}"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 6),

                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _infoLabel(
                                                              "Created on"),
                                                          _infoValue(
                                                            DateFormat("dd/MMM/yyyy").format(state
                                                                        .data![
                                                                            index]
                                                                        .createdAt ??
                                                                    DateTime
                                                                        .now()) ??
                                                                "-",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          _infoLabel(
                                                              "Sub category"),
                                                          _infoValue(
                                                              "${state.data![index].subcategoryName}"),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // DIVIDER
                                    Container(
                                      height: 1,
                                      color: Colors.grey.shade200,
                                    ),

                                    // FOOTER SECTION
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // PRICE
                                          Text(
                                            "₹ ${service.price}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),

                                          // STATUS BADGE
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: service.status == "Active"
                                                  ? Colors.green.shade50
                                                  : Colors.orange.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: service.status ==
                                                        "Active"
                                                    ? Colors.green.shade300
                                                    : Colors.orange.shade300,
                                              ),
                                            ),
                                            child: Text(
                                              service.status ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: service.status ==
                                                        "Active"
                                                    ? Colors.green.shade700
                                                    : Colors.orange.shade700,
                                              ),
                                            ),
                                          ),

                                          // EDIT BUTTON
                                          ElevatedButton(
                                            onPressed: () {
                                              context.push(
                                                AppRoutes
                                                    .EDIT_SERVICE_SCREEN_PATH,
                                                extra: {
                                                  "serviceId":
                                                      service.id.toString()
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black87,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              "Edit",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )

                              // padding: const EdgeInsets.all(12),
                              // margin: const EdgeInsets.only(bottom: 8),
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(8),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: Colors.black.withOpacity(0.05),
                              //       blurRadius: 4,
                              //       offset: const Offset(0, 2),
                              //     ),
                              //   ],
                              // ),
                              // child: Column(
                              //   children: [
                              //     // Top Row with Image, Info, Price, and Status
                              //     Row(
                              //       children: [
                              //         // Product Image
                              //         Container(
                              //           width: 60,
                              //           height: 60,
                              //           decoration: BoxDecoration(
                              //             color: Colors.grey.shade200,
                              //             borderRadius:
                              //                 BorderRadius.circular(28),
                              //           ),
                              //           child: ClipRRect(
                              //             borderRadius:
                              //                 BorderRadius.circular(14),
                              //             child: Image.network(
                              //               state.data![index].iconUrl != null
                              //                   ? state.data![index].iconUrl
                              //                       .toString()
                              //                   : "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/a2a45875170291.5c45acd8af715.jpg",
                              //               fit: BoxFit.fill,
                              //               errorBuilder:
                              //                   (context, error, stackTrace) {
                              //                 return Container();
                              //               },
                              //             ),
                              //           ),
                              //         ),
                              //         const SizedBox(width: 12),

                              //         // Product Info
                              //         Expanded(
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Text(
                              //                 state.data![index]
                              //                         .serviceName ??
                              //                     "",
                              //                 style: const TextStyle(
                              //                   fontSize: 14,
                              //                   fontWeight: FontWeight.w600,
                              //                   color: Colors.black,
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 4),
                              //               Text(
                              //                 state.data![index]
                              //                         .description ??
                              //                     "",
                              //                 style: TextStyle(
                              //                   fontSize: 12,
                              //                   color: Colors.grey.shade600,
                              //                 ),
                              //                 maxLines: 2,
                              //                 overflow: TextOverflow.ellipsis,
                              //               ),
                              //             ],
                              //           ),
                              //         ),

                              //         const SizedBox(width: 8),

                              //         // Amount and Status
                              //         Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.end,
                              //           children: [
                              //             Text(
                              //               state.data![index].price
                              //                   .toString(),
                              //               style: const TextStyle(
                              //                 fontSize: 14,
                              //                 fontWeight: FontWeight.w600,
                              //                 color: Colors.black,
                              //               ),
                              //             ),
                              //             const SizedBox(height: 4),
                              //             Container(
                              //               padding:
                              //                   const EdgeInsets.symmetric(
                              //                       horizontal: 12,
                              //                       vertical: 4),
                              //               decoration: BoxDecoration(
                              //                 color: Colors.grey.shade100,
                              //                 borderRadius:
                              //                     BorderRadius.circular(12),
                              //               ),
                              //               child: Text(
                              //                 state.data![index].status ?? "",
                              //                 style: const TextStyle(
                              //                   fontSize: 11,
                              //                   fontWeight: FontWeight.w500,
                              //                   color: Colors.black87,
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ],
                              //     ),

                              //     const SizedBox(height: 12),

                              //     // Edit Button Row (Bottom)
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: [
                              //         Container(
                              //           decoration: BoxDecoration(
                              //             gradient: const LinearGradient(
                              //               colors: [
                              //                 Color(0xFF2563EB),
                              //                 Color(0xFF1D4ED8),
                              //               ],
                              //               begin: Alignment.topLeft,
                              //               end: Alignment.bottomRight,
                              //             ),
                              //             borderRadius:
                              //                 BorderRadius.circular(8),
                              //             boxShadow: [
                              //               BoxShadow(
                              //                 color: const Color(0xFF2563EB)
                              //                     .withOpacity(0.3),
                              //                 blurRadius: 8,
                              //                 offset: const Offset(0, 4),
                              //               ),
                              //             ],
                              //           ),
                              //           child: Material(
                              //             color: Colors.transparent,
                              //             child: InkWell(
                              //               onTap: () {
                              //                 // TODO: Add your edit navigation here
                              //                 // Example: context.push(AppRoutes.EDIT_SERVICE_PATH, extra: service);
                              //                 context.push(
                              //                     AppRoutes
                              //                         .EDIT_SERVICE_SCREEN_PATH,
                              //                     extra: {
                              //                       "serviceId": state
                              //                           .data![index].id
                              //                           .toString()
                              //                     });
                              //               },
                              //               borderRadius:
                              //                   BorderRadius.circular(8),
                              //               child: const Padding(
                              //                 padding: EdgeInsets.symmetric(
                              //                   horizontal: 16,
                              //                   vertical: 8,
                              //                 ),
                              //                 child: Row(
                              //                   mainAxisSize:
                              //                       MainAxisSize.min,
                              //                   children: const [
                              //                     Icon(
                              //                       Icons.edit_rounded,
                              //                       color: Colors.white,
                              //                       size: 18,
                              //                     ),
                              //                     SizedBox(width: 6),
                              //                     Text(
                              //                       'Edit',
                              //                       style: TextStyle(
                              //                         color: Colors.white,
                              //                         fontSize: 13,
                              //                         fontWeight:
                              //                             FontWeight.w600,
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget serviceCardUC({
  required ServiceItem item,
  required VoidCallback onEdit,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// IMAGE + TITLE + PRICE
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade200,
                child: Image.network(
                  item.iconUrl ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 32),
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// TITLE + DESCRIPTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.serviceName ?? "",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.3,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// PRICE
            Text(
              "₹${item.price}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// STATUS BADGE
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.status ?? "",
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        /// EDIT BUTTON
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onEdit,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class BookingDetailsUrbanPro extends StatelessWidget {
  final String serviceName;
  final String description;
  final String bookingId;
  final DateTime bookingDate;
  final String bookingStatus;
  final double totalAmount;
  final String paymentStatus;
  final String assignedEmployee; // optional field

  const BookingDetailsUrbanPro({
    super.key,
    required this.serviceName,
    required this.description,
    required this.bookingId,
    required this.bookingDate,
    required this.bookingStatus,
    required this.totalAmount,
    required this.paymentStatus,
    required this.assignedEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Booking Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _headerBanner(),
            const SizedBox(height: 20),
            _infoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _infoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelValue("Booking ID", bookingId),
                  const SizedBox(height: 14),
                  _labelValue("Scheduled Time",
                      DateFormat('hh:mm a').format(bookingDate) + " — 9:45 PM"),
                  const SizedBox(height: 14),
                  _labelValue(
                    "Booking Status",
                    bookingStatus,
                    valueColor: _statusColor(bookingStatus),
                  ),
                  const SizedBox(height: 14),
                  _labelValue(
                    "Payment Status",
                    paymentStatus,
                    valueColor:
                        paymentStatus == "PAID" ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _infoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Assigned Professional",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        assignedEmployee,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 14),
            _infoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "₹${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _headerBanner() {
    return Container(
      height: 220,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade400,
            Colors.deepPurple.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -20,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "assets/images/service_banner.png",
                height: 240,
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 25,
            child: const Text(
              "Premium Service\nExperience",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _labelValue(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "inprogress":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}

Widget _infoLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget _infoValue(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}
