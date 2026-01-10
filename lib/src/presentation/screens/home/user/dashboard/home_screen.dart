import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:panimithra/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_event.dart';
import 'package:panimithra/src/presentation/bloc/service/service_state.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';
import 'package:shimmer/shimmer.dart';

class FindServicesScreen extends StatefulWidget {
  const FindServicesScreen({super.key});

  @override
  State<FindServicesScreen> createState() => _FindServicesScreenState();
}

class _FindServicesScreenState extends State<FindServicesScreen> {
  bool showFilters = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  RangeValues priceRange = const RangeValues(0, 10000);
  String selectedDistance = '50';
  String sortBy = 'Low to High';
  double minRating = 0;
  double maxRating = 0.0;
  double minPrice = 0.0;
  double maxPrice = 0.0;
  String selectedCategory = 'All';
  int totalRecords = 0;
  int totalLength = 0;
  int page = 0;
  int x = 0;
  Timer? _debounce;
  Timer? _searchDebounce;
  bool isLoading = false;
  final List<String> categories = [
    'All',
    'Pest Control',
    'Painter',
    'Mobile Repair',
    'Laundry',
    'It & Computer Support',
    'Gardening',
    'Home renovation',
    'CCTV & Security',
    'Car Washing',
    'Home Shifting',
    'Applieance Repair',
    'Beauty & Wellness',
    'Home Cleaning',
    'Carpenter',
    'Plumber',
    'Electrician'
  ];
  final List<String> sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
  ];
  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(const SearchServiceEvent(page: 0));
    //getToken();
    _scrollController.addListener(_scrollListener);
  }

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    context
        .read<FetchUsersBloc>()
        .add(RegisterFcmTokenEvent(deviceToken: token.toString()));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    _searchDebounce?.cancel();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    print("is loading test" + isLoading.toString());
    if (isLoading) {
      return;
    }
    print("failing");

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
          context.read<ServiceBloc>().add(SearchServiceEvent(page: page));
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
    context.read<ServiceBloc>().add(SearchServiceEvent(
          page: 0,
          serviceName: searchController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          // Header
          _buildHeader(l10n),
          // Content
          Expanded(
            child: Stack(
              children: [
                _buildServiceList(l10n),
                if (showFilters) _buildFilterSheet(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar: Greeting & Notification
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.exploreServices,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded,
                                size: 14, color: primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              l10n.nearLocation,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildTopIconButton(Icons.notifications_none_rounded, () {}),
                ],
              ),
            ),

            // Search Bar: Modern & Integrated
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: l10n.searchServices,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: primaryColor, size: 24),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Filter Chips: Elegant & Horizontal
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildFilterChip(
                    l10n.filters,
                    Icons.tune_rounded,
                    showFilters,
                    () => setState(() => showFilters = !showFilters),
                    isPrimary: true,
                  ),
                  const SizedBox(width: 10),
                  _buildFilterChip(
                    '${l10n.sortBy}: ${sortBy == 'Price: Low to High' ? l10n.priceLowToHigh : (sortBy == 'Price: High to Low' ? l10n.priceHighToLow : sortBy)}',
                    Icons.sort_rounded,
                    false,
                    () => _showSortBottomSheet(l10n),
                  ),
                  const SizedBox(width: 10),
                  _buildFilterChip(
                    l10n.category,
                    Icons.grid_view_rounded,
                    false,
                    () => _showCategoryBottomSheet(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF1E293B), size: 24),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildFilterChip(
      String label, IconData icon, bool isActive, VoidCallback onTap,
      {bool isPrimary = false}) {
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary && isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isPrimary && isActive ? primaryColor : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: [
            if (isPrimary && isActive)
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary && isActive
                  ? Colors.white
                  : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary && isActive
                    ? Colors.white
                    : const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(AppLocalizations l10n) {
    return BlocConsumer<ServiceBloc, ServiceState>(
      buildWhen: (previous, current) => ((current is SearchServiceLoadedState ||
              current is SearchServiceErrorState) ||
          (current is SearchServiceLoadingState && page == 0)),
      listener: (context, state) {
        if (state is SearchServiceLoadedState) {
          isLoading = false;
          totalRecords = state.totalRecords;
          totalLength = state.items.length;
        }
        if (state is SearchServiceLoadingState) {
          isLoading = true;
        }
        if (state is SearchServiceErrorState) {
          isLoading = false;
          ToastHelper.showToast(
            context: context,
            type: 'error',
            title: state.error,
          );
        }
      },
      builder: (context, state) {
        if (state is SearchServiceLoadingState && page == 0) {
          return _buildShimmerLoading();
        }
        if (state is SearchServiceErrorState) {
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
                      state.error,
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
                        context.read<ServiceBloc>().add(const SearchServiceEvent(
                              page: 0,
                            ));
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
        if (state is SearchServiceLoadedState) {
          return state.totalRecords > 0
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: state.items.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return Visibility(
                          visible: state.totalRecords <= state.items.length
                              ? false
                              : true,
                          child: _buildPaginationShimmer());
                    }
                    return ServiceCard(
                      imageUrl: state.items[index].iconUrl != null
                          ? state.items[index].iconUrl.toString()
                          : 'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=600',
                      title:
                          capitalize(state.items[index].serviceName.toString()),
                      subtitle: '',
                      serviceId: state.items[index].serviceId.toString(),
                      category:
                          '${state.items[index].categoryName.toString()} ',
                      rating: state.items[index].avgrating ?? 0.0,
                      reviewCount: 5,
                      joinedDate: DateFormat("MMM dd yyyy").format(
                          state.items[index].createdAt ?? DateTime(000)),
                      location: state.items[index].address.toString() ?? "",
                      workingDays: '',
                      workingHours:
                          '${state.items[index].startTime}  -  ${state.items[index].endTime}',
                      price: state.items[index].price!.toInt() ?? 0,
                      priceUnit: 'Day',
                      mobileNumber: state.items[index].mobileNumber ?? "",
                      onBookingPressed: () {},
                    );
                  })
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                    Center(child: _buildNoServicesFound(l10n)),
                  ],
                );
        }
        return Container();
      },
    );
  }

  Widget _buildNoServicesFound(AppLocalizations l10n) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 72, color: primaryColor.withOpacity(0.2)),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.noServicesFound,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noServicesMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              setState(() {
                searchController.clear();
                selectedCategory = 'All';
                _callApi("");
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(l10n.clearAllFilters,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet(AppLocalizations l10n) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showFilters = false;
          });
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: GestureDetector(
            onTap: () {},
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = 'All';
                                priceRange = const RangeValues(0, 500);
                                selectedDistance = '50';
                                minRating = 0;
                              });
                            },
                            child: Text(l10n.clearAll),
                          ),
                          Text(
                            l10n.filters,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                showFilters = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // Filter Content
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Category
                          Text(
                            l10n.category,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: categories.map((category) {
                              final isSelected = selectedCategory == category;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    category == 'All' ? l10n.all : category,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 24),

                          // Price Range
                          Text(
                            l10n.priceRange,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${priceRange.start.round()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '\$${priceRange.end.round()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          RangeSlider(
                            values: priceRange,
                            min: 0,
                            max: 10000,
                            divisions: 50,
                            activeColor: Colors.blue,
                            onChanged: (RangeValues values) {
                              setState(() {
                                priceRange = values;
                              });
                            },
                          ),

                          const SizedBox(height: 24),

                          // Rating
                          Text(
                            l10n.minRating,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: List.generate(5, (index) {
                              final starValue = index + 1.0;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    minRating = starValue;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    minRating >= starValue
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 36,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Apply Button
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showFilters = false;
                            });
                            print(minRating);
                            context.read<ServiceBloc>().add(SearchServiceEvent(
                                page: 0,
                                categoryName: selectedCategory.toLowerCase(),
                                minPrice: priceRange.start,
                                maxRating: maxRating,
                                minRating: minRating,
                                maxPrice: priceRange.end));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            l10n.applyFilters,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSortBottomSheet(AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  l10n.sortBy,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ...sortOptions.map((option) {
                return ListTile(
                  title: Text(option == 'Price: Low to High'
                      ? l10n.priceLowToHigh
                      : option == 'Price: High to Low'
                          ? l10n.priceHighToLow
                          : option),
                  trailing: sortBy == option
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    print("selected" + option.toLowerCase());
                    sortBy = option;
                    setState(() {});
                    context.read<ServiceBloc>().add(SearchServiceEvent(
                          page: 0,
                          priceSort: option
                                  .toString()
                                  .toLowerCase()
                                  .trim()
                                  .contains("low to high")
                              ? "asc"
                              : "desc",
                        ));
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  l10n.selectCategory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: categories.map((category) {
                    return ListTile(
                      title: Text(category),
                      trailing: selectedCategory == category
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        context.read<ServiceBloc>().add(SearchServiceEvent(
                            page: 0, categoryName: selectedCategory));
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 14,
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
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
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
        );
      },
    );
  }

  Widget _buildPaginationShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String serviceId;
  final String category;
  final double rating;
  final int reviewCount;
  final String joinedDate;
  final String location;
  final String workingDays;
  final String workingHours;
  final int price;
  final String priceUnit;
  final String mobileNumber;
  final VoidCallback onBookingPressed;

  const ServiceCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.serviceId,
    required this.subtitle,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.joinedDate,
    required this.location,
    required this.workingDays,
    required this.workingHours,
    required this.price,
    required this.priceUnit,
    required this.mobileNumber,
    required this.onBookingPressed,
  }) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedScale(
          scale: isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section with Badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(28)),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Hero(
                          tag: 'service_${widget.serviceId}',
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: const Color(0xFFF1F5F9),
                              child: Icon(Icons.handyman_rounded,
                                  color: Colors.grey[300], size: 48),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Rating Badge (Top Right)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10)
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFF59E0B), size: 18),
                            const SizedBox(width: 4),
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Category Badge (Top Left)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.category.trim().toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Details Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Info Grid
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildDetailRow(
                                    Icons.location_on_rounded, widget.location),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                    Icons.access_time_filled_rounded,
                                    widget.workingHours),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Container(height: 1, color: const Color(0xFFF1F5F9)),
                      const SizedBox(height: 24),

                      // Footer with Price and CTA
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.fairEstimate,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${widget.price}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: primaryColor,
                                    letterSpacing: -0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.push(AppRoutes.PREBOOKING_SCREEN_PATH,
                                  extra: {"serviceId": widget.serviceId});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F172A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                            ),
                            child: Text(
                              l10n.bookNow,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2),
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
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF475569),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
