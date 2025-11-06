import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_event.dart';
import 'package:panimithra/src/presentation/bloc/service/service_state.dart';

class FindServicesScreen extends StatefulWidget {
  const FindServicesScreen({super.key});

  @override
  State<FindServicesScreen> createState() => _FindServicesScreenState();
}

class _FindServicesScreenState extends State<FindServicesScreen> {
  bool showFilters = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  RangeValues priceRange = const RangeValues(0, 500);
  String selectedDistance = '50';
  String sortBy = 'asec';
  double minRating = 0;
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
    'Plumber',
    'Electrical',
    'Cleaning',
    'Carpentry',
    'Painting',
    'HVAC',
    'Landscaping'
  ];
  final List<String> sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
  ];
  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(const SearchServiceEvent(page: 0));
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
          x = 2;
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
    context
        .read<ServiceBloc>()
        .add(SearchServiceEvent(page: 0, serviceName: searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: Text(
                      'Find Services',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search for 'plumbing', 'electrician'...",
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip(
                    'Filters',
                    Icons.tune,
                    true,
                    () {
                      setState(() {
                        showFilters = !showFilters;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Sort By: $sortBy',
                    Icons.keyboard_arrow_down,
                    false,
                    () => _showSortBottomSheet(),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Category',
                    Icons.keyboard_arrow_down,
                    false,
                    () => _showCategoryBottomSheet(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[50] : Colors.white,
          border: Border.all(
            color: isActive ? Colors.blue[200]! : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.blue[700] : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue[700] : Colors.grey[700],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList() {
    return BlocConsumer<ServiceBloc, ServiceState>(
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
                  onPressed: () {},
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
                    print("total items" + state.items.length.toString());
                    if (index >= state.items.length) {
                      return Visibility(
                          visible: state.totalRecords <= state.items.length
                              ? false
                              : true,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }
                    return _buildServiceCard(
                        imageUrl:
                            "https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=400&h=300&fit=crop",
                        category: state.items[index].categoryName.toString(),
                        title: state.items[index].serviceName.toString(),
                        provider: state.items[index].employeeName ?? "",
                        rating: state.items[index].avgrating ?? 0.0,
                        price: state.items[index].price.toString(),
                        distance: "25 miles",
                        id: state.items[index].serviceId.toString());
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
    // return ListView(
    //   padding: const EdgeInsets.all(16),
    //   children: [

    //     _buildServiceCard(
    //       imageUrl:
    //           'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=400&h=300&fit=crop',
    //       category: 'Plumbing',
    //       title: 'Leaky Faucet Repair',
    //       provider: "John's Plumbing",
    //       rating: 4.9,
    //       price: '\$75/hr',
    //       distance: '21 mi away',
    //     ),
    //     const SizedBox(height: 16),
    //     _buildServiceCard(
    //       imageUrl:
    //           'https://images.unsplash.com/photo-1621905251918-48416bd8575a?w=400&h=300&fit=crop',
    //       category: 'Electrical',
    //       title: 'Ceiling Fan Installation',
    //       provider: 'Sparky Electric',
    //       rating: 4.8,
    //       price: '\$120 fixed',
    //       distance: '5.3 mi away',
    //     ),
    //     const SizedBox(height: 16),
    //     _buildNoServicesFound(),
    //   ],
    // );
  }

  Widget _buildServiceCard({
    required String imageUrl,
    required String category,
    required String title,
    required String provider,
    required double rating,
    required String price,
    required String distance,
    required String id,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by $provider',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print(id);
                      context.push(AppRoutes.PREBOOKING_SCREEN_PATH,
                          extra: {"serviceId": id});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoServicesFound() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Services Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or\nsearching for something else.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
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
                            max: 500,
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

                            print(priceRange.start);
                            print(priceRange.end);
                            context.read<ServiceBloc>().add(SearchServiceEvent(
                                page: 0,
                                categoryName: selectedCategory.toLowerCase(),
                                minPrice: priceRange.start,
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
                    setState(() {
                      sortBy = option;
                    });
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
