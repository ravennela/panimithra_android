import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:panimithra/src/common/colors.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/core/constants/api_constants.dart';
import 'package:panimithra/src/data/datasource/remote/upload_file_remote_datasource.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_event.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_state.dart';
import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_event.dart';
import 'package:panimithra/src/presentation/bloc/service/service_state.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_event.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_state.dart';
import 'package:panimithra/src/presentation/widget/helper.dart';
import 'package:panimithra/src/utilities/location_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool showManagerDropdown = false;

  bool subShowManagerDropdown = false;
  String? _selectedCategory;
  String? _selectedSubcategory;
  String? _selectedDuration;
  List<String> selectedDays = [];
  TextEditingController categoryController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;
  int totalRecords = 0;
  int totalLength = 0;
  int page = 0;
  int x = 0;
  File? _selectedFile;
  bool hasMoreRecords = true;
  Map<String, dynamic> availableDate = {};
  List<Map<String, dynamic>> availableDatesList = [];

  TextEditingController subCategoryController = TextEditingController();
  final ScrollController subScrollController = ScrollController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addInfoLine1Controller = TextEditingController();
  TextEditingController addInfoLine2Controller = TextEditingController();
  TextEditingController addInfoLine3Controller = TextEditingController();
  Timer? _subDebounce;
  int subTotalRecords = 0;
  int subTotalLength = 0;
  String? selectedCategoryId;
  String? selectedSubCategoryId;
  int subPage = 0;
  bool subHasMoreRecords = true;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (startTime ?? TimeOfDay.now())
          : (endTime ?? TimeOfDay.now()),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "Select time";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(availableDate);
    scrollController.addListener(_scrollListener);
    subScrollController.addListener(_subScrollListener);
    context.read<CategoriesBloc>().add(const FetchCategoriesEvent(page: 0));
    context.read<SubcategoryBloc>().add(FetchSubcategoriesEvent(
        categoryId: _selectedCategory.toString(), page: 0));
  }

  void _scrollListener() {
    print("Scrolling");
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        if (totalLength >= totalRecords) {
          hasMoreRecords = false;
          return;
        }
        print("length passed");

        if (totalLength <= totalRecords) {
          page += 1;
          context.read<CategoriesBloc>().add(FetchCategoriesEvent(page: page));
        }
      }
    });
  }

  void _subScrollListener() {
    if (_subDebounce?.isActive ?? false) _subDebounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (subScrollController.position.pixels >=
          subScrollController.position.maxScrollExtent - 100) {
        if (subTotalLength >= subTotalRecords) {
          subHasMoreRecords = false;
          return;
        }
        if (subTotalLength <= subTotalRecords) {
          subPage += 1;
          context.read<SubcategoryBloc>().add(FetchSubcategoriesEvent(
              categoryId: _selectedCategory.toString(), page: subPage));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black87, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Description
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.info_outline,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Fill in the details below to list your service',
                                style: TextStyle(
                                  color: Color(0xFF1E40AF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ---------- Service Category ----------
                      _sectionCard(
                        title: 'Service Category',
                        icon: Icons.category_outlined,
                        child: Column(
                          children: [
                            BlocConsumer<CategoriesBloc, CategoriesState>(
                                listener: (context, state) {
                              if (state is CategoriesError) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: 'error',
                                    title: state.message);
                              }
                              if (state is CategoriesLoaded) {
                                totalLength = state.data!.length;
                                totalRecords = state.totalRecords;
                              }
                            }, builder: (context, state) {
                              if (state is CategoriesLoading ||
                                  state is CategoriesInitial) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (state is CategoriesError) {
                                return const SizedBox.shrink();
                              }
                              if (state is CategoriesLoaded) {
                                return Column(
                                  children: [
                                    TextFormField(
                                      readOnly: true,
                                      controller: categoryController,
                                      onTap: () {
                                        setState(() {
                                          showManagerDropdown =
                                              !showManagerDropdown;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Select Category',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        prefixIcon: const Icon(
                                            Icons.grid_view_rounded,
                                            size: 20),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: Icon(
                                            showManagerDropdown
                                                ? Icons
                                                    .keyboard_arrow_up_outlined
                                                : Icons
                                                    .keyboard_arrow_down_outlined,
                                            color: const Color(0xFF2563EB),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (showManagerDropdown) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                          height: 240,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: state.totalRecords > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      state.data!.length + 1,
                                                  controller: scrollController,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    if (index >=
                                                        state.data!.length) {
                                                      return Visibility(
                                                          visible:
                                                              state.totalRecords <=
                                                                      state
                                                                          .data!
                                                                          .length
                                                                  ? false
                                                                  : true,
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          ));
                                                    }
                                                    return InkWell(
                                                      onTap: () {
                                                        subCategoryController
                                                            .clear();
                                                        _selectedSubcategory =
                                                            null;
                                                        categoryController
                                                                .text =
                                                            state.data![index]
                                                                .categoryName
                                                                .toString();
                                                        showManagerDropdown =
                                                            !showManagerDropdown;
                                                        _selectedCategory =
                                                            state.data![index]
                                                                .categoryId;
                                                        context
                                                            .read<
                                                                SubcategoryBloc>()
                                                            .add(FetchSubcategoriesEvent(
                                                                categoryId:
                                                                    _selectedCategory
                                                                        .toString(),
                                                                page: 0));
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Colors
                                                                  .grey[200]!,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFFEFF6FF),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .folder_outlined,
                                                                size: 18,
                                                                color: Color(
                                                                    0xFF2563EB),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child: Text(
                                                                state
                                                                    .data![
                                                                        index]
                                                                    .categoryName
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .chevron_right,
                                                              color:
                                                                  Colors.grey,
                                                              size: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  })
                                              : const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .category_outlined,
                                                            size: 48,
                                                            color: Colors.grey),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          "No Category Available",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                    ]
                                  ],
                                );
                              }
                              return Container();
                            }),
                            const SizedBox(height: 16),
                            //sub category
                            BlocConsumer<SubcategoryBloc, SubcategoryState>(
                                listener: (context, state) {
                              if (state is SubcategoryError) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: 'error',
                                    title: state.message);
                              }
                              if (state is SubcategoryLoaded) {
                                subTotalLength = state.data!.length;
                                subTotalRecords = state.totalRecords;
                              }
                            }, builder: (context, state) {
                              if (state is SubcategoryLoading ||
                                  state is SubcategoryInitial) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (state is CategoriesError) {
                                return const SizedBox.shrink();
                              }
                              if (state is SubcategoryLoaded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      readOnly: true,
                                      controller: subCategoryController,
                                      onTap: () {
                                        setState(() {
                                          subShowManagerDropdown =
                                              !subShowManagerDropdown;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Select SubCategory',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        prefixIcon: const Icon(
                                            Icons.apps_outlined,
                                            size: 20),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: Icon(
                                            subShowManagerDropdown
                                                ? Icons
                                                    .keyboard_arrow_up_outlined
                                                : Icons
                                                    .keyboard_arrow_down_outlined,
                                            color: const Color(0xFF2563EB),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (subShowManagerDropdown) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                          height: 240,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: state.totalRecords > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      state.data!.length + 1,
                                                  controller:
                                                      subScrollController,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    if (index >=
                                                        state.data!.length) {
                                                      return Visibility(
                                                          visible:
                                                              state.totalRecords <=
                                                                      state
                                                                          .data!
                                                                          .length
                                                                  ? false
                                                                  : true,
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          ));
                                                    }
                                                    return InkWell(
                                                      onTap: () {
                                                        subCategoryController
                                                                .text =
                                                            state.data![index]
                                                                .categoryName
                                                                .toString();
                                                        subShowManagerDropdown =
                                                            !subShowManagerDropdown;
                                                        _selectedSubcategory =
                                                            state.data![index]
                                                                .categoryId;
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Colors
                                                                  .grey[200]!,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFFFEF3C7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .label_outline,
                                                                size: 18,
                                                                color: Color(
                                                                    0xFFD97706),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child: Text(
                                                                state
                                                                    .data![
                                                                        index]
                                                                    .categoryName
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .chevron_right,
                                                              color:
                                                                  Colors.grey,
                                                              size: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  })
                                              : const Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons.apps_outlined,
                                                            size: 48,
                                                            color: Colors.grey),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          "No SubCategories Available",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                    ]
                                  ],
                                );
                              }
                              return Container();
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- Service Details ----------
                      _sectionCard(
                        title: 'Service Details',
                        icon: Icons.description_outlined,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _serviceNameController,
                              maxLines: 1,
                              label: 'Service Name',
                              maxLenghth: 100,
                              hint: 'e.g., Leaky Faucet Repair',
                              icon: Icons.build_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _descriptionController,
                              maxLenghth: 100,
                              label: 'Service Description',
                              hint: 'Describe the service you offer...',
                              maxLines: 4,
                              icon: Icons.notes_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: addressController,
                              label: 'Service Address',
                              maxLenghth: 100,
                              hint: 'Enter service location',
                              maxLines: 3,
                              icon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- Additional Information ----------
                      _sectionCard(
                        title: 'Additional Information',
                        icon: Icons.info_outline,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: addInfoLine1Controller,
                              label: 'Additional Info 1',
                              maxLenghth: 100,
                              hint: 'Items included in service',
                              maxLines: 2,
                              icon: Icons.check_circle_outline,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: addInfoLine2Controller,
                              label: 'Additional Info 2',
                              maxLenghth: 100,
                              hint: 'Items included in service',
                              maxLines: 2,
                              icon: Icons.check_circle_outline,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: addInfoLine3Controller,
                              label: 'Additional Info 3',
                              maxLenghth: 100,
                              hint: 'Items included in service',
                              maxLines: 2,
                              icon: Icons.check_circle_outline,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- Pricing & Duration ----------
                      _sectionCard(
                        title: 'Pricing & Duration',
                        icon: Icons.attach_money_outlined,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _priceController,
                                label: 'Price',
                                hint: '50',
                                prefix: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: const Text(
                                    '\$',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                label: 'Duration',
                                value: _selectedDuration,
                                hint: '1 hour',
                                onChanged: (val) =>
                                    setState(() => _selectedDuration = val),
                                items: [
                                  '30 min',
                                  '1 hour',
                                  '2 hours',
                                  'Half day',
                                  'Full day'
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- Service Timings ----------
                      _sectionCard(
                        title: 'Service Timings',
                        icon: Icons.access_time_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Start Time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () => _selectTime(context, true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: startTime != null
                                                  ? const Color(0xFF2563EB)
                                                      .withOpacity(0.3)
                                                  : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                formatTime(startTime),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: startTime != null
                                                      ? Colors.black
                                                      : Colors.grey[400],
                                                ),
                                              ),
                                              Icon(
                                                Icons.access_time_rounded,
                                                size: 20,
                                                color: startTime != null
                                                    ? const Color(0xFF2563EB)
                                                    : Colors.grey[400],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'End Time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () =>
                                            _selectTime(context, false),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: endTime != null
                                                  ? const Color(0xFF2563EB)
                                                      .withOpacity(0.3)
                                                  : Colors.grey[300]!,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                formatTime(endTime),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: endTime != null
                                                      ? Colors.black
                                                      : Colors.grey[400],
                                                ),
                                              ),
                                              Icon(
                                                Icons.access_time_rounded,
                                                size: 20,
                                                color: endTime != null
                                                    ? const Color(0xFF2563EB)
                                                    : Colors.grey[400],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- Service Images ----------
                      _sectionCard(
                        title: 'Service Images',
                        icon: Icons.image_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add up to 5 images to showcase your service',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (_selectedFile == null)
                              GestureDetector(
                                onTap: () async {
                                  _pickAndUpload();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF2563EB),
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                    color: const Color(0xFFEFF6FF),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2563EB)
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Color(0xFF2563EB),
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Upload Image',
                                        style: TextStyle(
                                          color: Color(0xFF2563EB),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'JPG, PNG up to 10MB',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_selectedFile != null)
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_selectedFile!.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Color(0xFF2563EB)),
                                            onPressed: () {
                                              _pickAndUpload();
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                _selectedFile = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- Availability ----------
                      _sectionCard(
                        title: 'Set Your Availability',
                        icon: Icons.calendar_today_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select the days you are available',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ]
                                  .map(
                                    (day) => InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedDays.contains(day)) {
                                            selectedDays.remove(day);
                                          } else {
                                            selectedDays.add(day);
                                          }
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: selectedDays.contains(day)
                                              ? const Color(0xFF2563EB)
                                              : const Color(0xFFF9FAFB),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: selectedDays.contains(day)
                                                ? const Color(0xFF2563EB)
                                                : Colors.grey[300]!,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            color: selectedDays.contains(day)
                                                ? Colors.white
                                                : const Color(0xFF374151),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(height: 32),

                      // ---------- Submit Button ----------
                      BlocConsumer<ServiceBloc, ServiceState>(
                        listener: (context, state) {
                          if (state is CreateServiceError) {
                            ToastHelper.showToast(
                                context: context,
                                type: 'error',
                                title: state.message);
                          }
                          if (state is CreateServiceSuccess) {
                            ToastHelper.showToast(
                                context: context,
                                type: 'success',
                                title: "Service Created Successfully");
                            context
                                .read<ServiceBloc>()
                                .add(FetchServicesEvent(page: 0));
                            context.pop();
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF2563EB).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed: state is CreateServiceLoading
                                  ? null
                                  : () async {
                                      print("form valid");
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }
                                      print("valid");
                                      if (_selectedCategory == null) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title: 'Please Select Category');
                                        return;
                                      }
                                      print("category");
                                      if (_selectedSubcategory == null) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title:
                                                'Please Select Sub Category');
                                        return;
                                      }
                                      print("sub category");
                                      if (_serviceNameController.text.isEmpty) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title:
                                                'Please Select Service Name');
                                        return;
                                      }
                                      print('service name');
                                      if (_serviceNameController.text.isEmpty) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title:
                                                'Please Select Service Description');
                                        return;
                                      }
                                      print("price");
                                      if (_priceController.text.isEmpty) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title: 'Please Select Price');
                                        return;
                                      }
                                      for (int i = 0;
                                          i < selectedDays.length;
                                          i++) {
                                        availableDatesList.add({
                                          "availableDate":
                                              selectedDays[i].toString(),
                                        });
                                      }
                                      print("dates");
                                      if (startTime == null) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title: 'Please Select Start Time');
                                        return;
                                      }
                                      if (endTime == null) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title: 'Please Select End Time');
                                        return;
                                      }
                                      print("address");
                                      if (addressController.text.isEmpty) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title: 'Please Select Address');
                                        return;
                                      }
                                      if (startTime!.isAfter(endTime!)) {
                                        ToastHelper.showToast(
                                            context: context,
                                            type: 'error',
                                            title:
                                                'Please Select Start Time Before End Time');
                                        return;
                                      }
                                      print("location");
                                      double latitude = 0.0;
                                      double longitude = 0.0;
                                      try {
                                        Map<String, double>? location =
                                            await getCurrentLocation();
                                        latitude = location!['lat']!;
                                        longitude = location['lng']!;
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                      print("till location");
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();

                                      String employeeId = preferences
                                              .getString(ApiConstants.userId) ??
                                          '';

                                      final availableEndDates =
                                          '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
                                      final availableStartTime =
                                          '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
                                      print("till data");
                                      Map<String, dynamic> data = {
                                        "employeeId": employeeId,
                                        "name": _serviceNameController.text,
                                        "description":
                                            _descriptionController.text,
                                        "price":
                                            _priceController.text.isNotEmpty
                                                ? double.parse(
                                                    _priceController.text)
                                                : 0.0,
                                        "duration": convertTimeToMinutes(
                                            _selectedDuration ?? ""),
                                        "status": "ACTIVE",
                                        "iconUrl": _selectedFile,
                                        "timeIn": availableStartTime,
                                        "timeOut": availableEndDates,
                                        "addInfoOne":
                                            addInfoLine1Controller.text,
                                        "addInfoTwo":
                                            addInfoLine2Controller.text,
                                        "addInfoThree":
                                            addInfoLine3Controller.text,
                                        "availableStartTime":
                                            availableStartTime,
                                        "availableEndTime": availableEndDates,
                                        "latitude": latitude,
                                        "longitude": longitude,
                                        "availableDates": availableDatesList,
                                        "images": [
                                          {"imageUrls": "hg"}
                                        ],
                                        "address": addressController.text
                                      };

                                      context.read<ServiceBloc>().add(
                                          CreateServiceEvent(
                                              serviceData: data,
                                              categoryId:
                                                  _selectedCategory.toString(),
                                              subCategoryId:
                                                  _selectedSubcategory
                                                      .toString()));
                                    },
                              child: state is CreateServiceLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Creating Service...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_circle_outline,
                                            size: 22),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Create Service',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFFD97706),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: const Text(
                                'Your service will be reviewed by our team before it goes live.',
                                style: TextStyle(
                                  color: Color(0xFF92400E),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUpload() async {
    final picked = await UploadFileRemoteDatasource(client: Dio()).pickImage();
    if (picked == null) return;

    setState(() {
      _selectedFile = picked;
    });
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF2563EB)),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e, style: const TextStyle(fontSize: 15)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    int? maxLenghth,
    Widget? prefix,
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLenghth ?? 10,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            counterText: '',
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFF6B7280), size: 20)
                : (prefix != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: prefix,
                      )
                    : null),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 48, minHeight: 0),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: EdgeInsets.symmetric(
              horizontal: icon != null || prefix != null ? 12 : 16,
              vertical: maxLines > 1 ? 16 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
