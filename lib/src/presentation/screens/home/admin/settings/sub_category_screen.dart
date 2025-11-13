import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_event.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

class SubcategoriesScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;

  const SubcategoriesScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Fetch initial subcategories
    context.read<SubcategoryBloc>().add(
          FetchSubcategoriesEvent(
            categoryId: widget.categoryId,
            page: 0,
          ),
        );

    // Setup pagination scroll listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = context.read<SubcategoryBloc>().state;
      if (state is SubcategoryLoaded) {
        final hasMore = (state.data?.length ?? 0) < state.totalRecords;
        if (hasMore && state.categoryId == widget.categoryId) {
          context.read<SubcategoryBloc>().add(
                FetchSubcategoriesEvent(
                  categoryId: widget.categoryId,
                  page: currentPage + 1,
                ),
              );
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subcategories',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.categoryName,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<SubcategoryBloc, SubcategoryState>(
        buildWhen: (previous, current) =>
            ((current is SubcategoryLoaded || current is SubcategoryError) ||
                (current is SubcategoryLoading && currentPage == 0)),
        builder: (context, state) {
          if (state is SubcategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SubcategoryError) {
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
                    state.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubcategoryBloc>().add(
                            FetchSubcategoriesEvent(
                              categoryId: widget.categoryId,
                              page: 1,
                            ),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SubcategoryLoaded) {
            final subcategories = state.data ?? [];

            if (subcategories.isEmpty) {
              return const Center(
                child: Text(
                  'No subcategories available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: subcategories.length + 1,
              itemBuilder: (context, index) {
                // Show loading indicator at the end while loading more
                if (index == subcategories.length) {
                  final hasMore = subcategories.length < state.totalRecords;
                  return hasMore
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                }

                return _buildSubcategoryCard(subcategories[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            AppRoutes.CREATE_SUBCATEGORY_PATH,
            extra: {
              'categoryId': widget.categoryId,
            },
          );
        },
        backgroundColor: const Color(0xFF2196F3),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Subcategory',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard(SubcategoryItem subcategory) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // View subcategory details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                // Container(
                //   width: 52,
                //   height: 52,
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //         _getColor(subcategory.categoryName ?? '')
                //             .withOpacity(0.8),
                //         _getColor(subcategory.categoryName ?? ''),
                //       ],
                //     ),
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: [
                //       BoxShadow(
                //         color: _getColor(subcategory.categoryName ?? '')
                //             .withOpacity(0.3),
                //         blurRadius: 8,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   child: Icon(
                //     _getIcon(subcategory.categoryName ?? ''),
                //     color: Colors.white,
                //     size: 26,
                //   ),
                // ),

                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: getBackgroundColor(subcategory.categoryName ?? ''),
                    shape: BoxShape.circle,
                  ),
                  child: subcategory.iconUrl != null
                      ? Image.network(
                          subcategory.iconUrl ?? ''.toString(),
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              getIconData(subcategory.categoryName ?? '' ?? ''),
                              color: getIconColor(
                                  subcategory.categoryName ?? '' ?? ''),
                              size: 28,
                            );
                          },
                        )
                      : Icon(
                          getIconData(subcategory.categoryName ?? '' ?? ''),
                          color: getIconColor(
                              subcategory.categoryName ?? '' ?? ''),
                          size: 28,
                        ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subcategory.categoryName ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          _buildStatusBadge(subcategory.status ?? ''),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subcategory.description ?? 'No description available',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Action Buttons
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                            color: const Color(0xFF2196F3),
                            onTap: () {
                              // Edit action
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildActionButton(
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            color: const Color(0xFFEF5350),
                            onTap: () {
                              _showDeleteDialog(
                                  context, subcategory.categoryName ?? '');
                            },
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                            size: 20,
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

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF4CAF50).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? const Color(0xFF4CAF50).withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? const Color(0xFF4CAF50) : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String subcategoryName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Subcategory',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$subcategoryName"? This action cannot be undone.',
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete action
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF5350),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper methods to get icon and color based on subcategory name
  IconData _getIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('leak')) return Icons.water_drop;
    if (lowerName.contains('pipe') || lowerName.contains('install')) {
      return Icons.plumbing;
    }
    if (lowerName.contains('drain') || lowerName.contains('clean')) {
      return Icons.cleaning_services;
    }
    if (lowerName.contains('heater') || lowerName.contains('water')) {
      return Icons.hot_tub;
    }
    if (lowerName.contains('emergency')) return Icons.emergency;
    return Icons.build;
  }

  Color _getColor(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('leak')) return const Color(0xFF2196F3);
    if (lowerName.contains('pipe') || lowerName.contains('install')) {
      return const Color(0xFF4CAF50);
    }
    if (lowerName.contains('drain') || lowerName.contains('clean')) {
      return const Color(0xFFFF9800);
    }
    if (lowerName.contains('heater') || lowerName.contains('water')) {
      return const Color(0xFFE91E63);
    }
    if (lowerName.contains('emergency')) return const Color(0xFFF44336);
    return const Color(0xFF9C27B0);
  }
}
