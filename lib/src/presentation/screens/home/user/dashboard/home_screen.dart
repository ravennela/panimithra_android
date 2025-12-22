import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          // Content
          Expanded(
            child: Stack(
              children: [
                _buildServiceList(),
                if (showFilters) _buildFilterSheet(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Services',
                          style: TextStyle(
                            fontSize: 28, // Larger, display font
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1D1E),
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discover the best services near you',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: Color(0xFF1A1D1E)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "Search for 'plumbing'...",
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: Colors.grey[400], size: 24),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Filter Chips
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildFilterChip(
                    'Filters',
                    Icons.tune_rounded,
                    true, // Keeping logic same, but visually improved
                    () {
                      setState(() {
                        showFilters = !showFilters;
                      });
                    },
                    isPrimary: true,
                  ),
                  const SizedBox(width: 12),
                  _buildFilterChip(
                    'Sort: $sortBy',
                    Icons.keyboard_arrow_down_rounded,
                    false,
                    () => _showSortBottomSheet(),
                  ),
                  const SizedBox(width: 12),
                  _buildFilterChip(
                    'Category',
                    Icons.category_outlined,
                    false,
                    () => _showCategoryBottomSheet(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, IconData icon, bool isActive, VoidCallback onTap,
      {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF1A1D1E) : Colors.white,
          border: Border.all(
            color:
                isPrimary ? const Color(0xFF1A1D1E) : const Color(0xFFE5E7EB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (!isPrimary)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? Colors.white : const Color(0xFF4B5563),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : const Color(0xFF4B5563),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList() {
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
          return const CircularProgressIndicator();
        }
        if (state is SearchServiceErrorState) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Error loading Service',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ServiceBloc>().add(const SearchServiceEvent(
                          page: 0,
                        ));
                  },
                  child: const Text('Retry'),
                ),
              ],
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
                          child:
                              const Center(child: CircularProgressIndicator()));
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
                    Center(child: _buildNoServicesFound()),
                  ],
                );
        }
        return Container();
      },
    );
  }

  Widget _buildNoServicesFound() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 60, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Services Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1D1E),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We couldn\'t find any services matching\nyour search. Try different filters.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              setState(() {
                searchController.clear();
                selectedCategory = 'All';
                _callApi("");
              });
            },
            child: const Text("Clear Filters",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheet() {
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
                            child: const Text('Clear All'),
                          ),
                          const Text(
                            'Filters',
                            style: TextStyle(
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
                          const Text(
                            'Category',
                            style: TextStyle(
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
                                    category,
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
                          const Text(
                            'Price Range',
                            style: TextStyle(
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
                          const Text(
                            'Minimum Rating',
                            style: TextStyle(
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
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
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

  void _showSortBottomSheet() {
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ...sortOptions.map((option) {
                return ListTile(
                  title: Text(option),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Select Category',
                  style: TextStyle(
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
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isHovered = true),
        onTapUp: (_) => setState(() => isHovered = false),
        onTapCancel: () => setState(() => isHovered = false),
        child: AnimatedScale(
          scale: isHovered ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A1D1E).withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(24)),
                      child: SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[100],
                              child: Icon(Icons.broken_image_rounded,
                                  color: Colors.grey[400], size: 40),
                            );
                          },
                        ),
                      ),
                    ),
                    // Rating Badge
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFF59E0B), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1D1E),
                              ),
                            ),
                            Text(
                              ' (${widget.reviewCount})',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Category Badge
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D1E).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          // backdropFilter: null,
                        ),
                        child: Text(
                          widget.category.trim(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1D1E),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Info Rows
                      Row(
                        children: [
                          _buildIconText(
                              Icons.location_on_rounded, widget.location,
                              maxLines: 2),
                          const SizedBox(width: 16),
                          if (widget.mobileNumber.isNotEmpty) ...[
                            _buildIconText(
                                Icons.phone_rounded, widget.mobileNumber,
                                maxLines: 1),
                            const SizedBox(width: 16),
                          ],
                          _buildIconText(
                              Icons.access_time_rounded, widget.workingHours),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      const SizedBox(height: 16),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Starting from',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '₹${widget.price}',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1A1D1E),
                                          letterSpacing: -0.5,
                                          height: 1,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(bottom: 2, left: 2),
                                    //   child: Text(
                                    //     '/${widget.priceUnit}',
                                    //     style: TextStyle(
                                    //       fontSize: 13,
                                    //       fontWeight: FontWeight.w600,
                                    //       color: Colors.grey[500],
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: () {
                                context.push(AppRoutes.PREBOOKING_SCREEN_PATH,
                                    extra: {"serviceId": widget.serviceId});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1D1E),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                              child: const Text(
                                'Book Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
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

  Widget _buildIconText(IconData icon, String text, {int maxLines = 1}) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
