import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/routes.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/data/models/fetch_category_model.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_event.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Fetch initial categories
    context.read<CategoriesBloc>().add(FetchCategoriesEvent(page: currentPage));

    // Setup pagination scroll listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = context.read<CategoriesBloc>().state;

      if (state is CategoriesLoaded) {
        final hasMore = (state.data?.length ?? 0) < state.totalRecords;
        if (hasMore) {
          context.read<CategoriesBloc>().add(
                FetchCategoriesEvent(page: state.page + 1),
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        buildWhen: (previous, current) =>
            ((current is CategoriesError || current is CategoriesLoaded) ||
                (current is CategoriesLoading && currentPage == 0)),
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoriesError) {
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
                      context.read<CategoriesBloc>().add(
                            const FetchCategoriesEvent(page: 1),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CategoriesLoaded) {
            final categories = state.data ?? [];

            if (categories.isEmpty) {
              return const Center(
                child: Text(
                  'No categories available',
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
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                // Show loading indicator at the end while loading more
                if (index == categories.length) {
                  final hasMore = categories.length < state.totalRecords;
                  return hasMore
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox.shrink();
                }

                return _buildCategoryCard(categories[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.CREATE_CATEGORY_PATH);
          // Add category action
        },
        backgroundColor: const Color(0xFFE3F2FD),
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Color(0xFF2196F3),
          size: 32,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryItem category) {
    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.SUB_CATEGORY_PATH,
          extra: {
            'categoryId': category.categoryId,
            'categoryName': category.categoryName,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: getBackgroundColor(category.categoryName ?? ''),
                    shape: BoxShape.circle,
                  ),
                  child: category.iconUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            category.iconUrl.toString(),
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                getIconData(category.categoryName ?? ''),
                                color:
                                    getIconColor(category.categoryName ?? ''),
                                size: 28,
                              );
                            },
                          ),
                        )
                      : Icon(
                          getIconData(category.categoryName ?? ''),
                          color: getIconColor(category.categoryName ?? ''),
                          size: 28,
                        ),
                ),
                const SizedBox(width: 16),
                // Title and Subcategories
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.categoryName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category.subCategoriesCount ?? 0} Subcategories',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Action buttons
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.grey[600],
                    size: 22,
                  ),
                  onPressed: () {
                    // Edit category action
                    context.push(AppRoutes.EDIT_CATEGORY_SCREEN_PATH,
                        extra: {"categoryId": category.categoryId});
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 22,
                  ),
                  onPressed: () {
                    _showDeleteDialog(context, category.categoryName.toString(),
                        category.categoryId.toString());
                    // Delete category action
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              category.description ?? 'No description available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            // Status
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: getStatusColor(category.status ?? ''),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  getStatusText(category.status.toString()),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: getStatusColor(category.status ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String subcategoryName, String subCategoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Category',
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
            BlocListener<CategoriesBloc, CategoriesState>(
              listener: (context, state) {
                if (state is DeleteCategoryError) {
                  ToastHelper.showToast(
                      context: context, type: "error", title: state.message);
                }
                if (state is DeleteCategoryLoaded) {
                  ToastHelper.showToast(
                      context: context,
                      type: "success",
                      title: "SubCategory Deleted Successfully");
                  context
                      .read<CategoriesBloc>()
                      .add(const FetchCategoriesEvent(page: 0));
                  context.pop();
                }
              },
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<CategoriesBloc>()
                      .add(DeleteCategoryEvent(categoryId: subCategoryId));
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
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  } // Helper methods to determine icon based on category name
}
