import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

  File? _selectedFile;
  bool hasMoreRecords = true;
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
    categoryController.dispose();
    subCategoryController.dispose();
    scrollController.dispose();
    subScrollController.dispose();
    addressController.dispose();
    addInfoLine1Controller.dispose();
    addInfoLine2Controller.dispose();
    addInfoLine3Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    subScrollController.addListener(_subScrollListener);
    context.read<CategoriesBloc>().add(const FetchCategoriesEvent(page: 0));
  }

  void _scrollListener() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        if (totalLength >= totalRecords) {
          hasMoreRecords = false;
          return;
        }

        if (totalLength <= totalRecords) {
          page += 1;
          context.read<CategoriesBloc>().add(FetchCategoriesEvent(page: page));
        }
      }
    });
  }

  void _subScrollListener() {
    if (_subDebounce?.isActive ?? false) _subDebounce?.cancel();
    _subDebounce = Timer(const Duration(milliseconds: 300), () {
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFF1A1D1E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Service',
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDBEAFE)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.tips_and_updates_outlined,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Text(
                                'Complete details to list your service. High-quality info attracts more customers!',
                                style: TextStyle(
                                  color: Color(0xFF1E40AF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ---------- Service Category ----------
                      _SectionHeader(
                          title: 'Category', icon: Icons.category_rounded),
                      const SizedBox(height: 12),
                      _sectionCard(
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
                                return const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                );
                              }
                              if (state is CategoriesError) {
                                return const SizedBox.shrink();
                              }
                              if (state is CategoriesLoaded) {
                                return Column(
                                  children: [
                                    _buildSelectField(
                                      controller: categoryController,
                                      hint: 'Select Category',
                                      icon: Icons.grid_view_rounded,
                                      isExpanded: showManagerDropdown,
                                      onTap: () {
                                        setState(() {
                                          showManagerDropdown =
                                              !showManagerDropdown;
                                        });
                                      },
                                    ),
                                    if (showManagerDropdown) ...[
                                      const SizedBox(height: 8),
                                      _buildDropdownList(
                                        itemCount: state.data!.length + 1,
                                        controller: scrollController,
                                        itemBuilder: (context, index) {
                                          if (index >= state.data!.length) {
                                            return _buildLoader(
                                                state.totalRecords <=
                                                    state.data!.length);
                                          }
                                          final item = state.data![index];
                                          return _buildDropdownItem(
                                            text: item.categoryName.toString(),
                                            icon: Icons.folder_outlined,
                                            onTap: () {
                                              subCategoryController.clear();
                                              _selectedSubcategory = null;
                                              categoryController.text =
                                                  item.categoryName.toString();
                                              showManagerDropdown = false;
                                              _selectedCategory =
                                                  item.categoryId;
                                              context
                                                  .read<SubcategoryBloc>()
                                                  .add(FetchSubcategoriesEvent(
                                                      categoryId:
                                                          _selectedCategory
                                                              .toString(),
                                                      page: 0));
                                              setState(() {});
                                            },
                                          );
                                        },
                                        emptyMessage: "No Category Available",
                                        isEmpty: state.totalRecords == 0,
                                      ),
                                    ]
                                  ],
                                );
                              }
                              return Container();
                            }),
                            const SizedBox(height: 16),
                            // Sub Category
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
                                return const SizedBox
                                    .shrink(); // Only show when loaded/active
                              }
                              if (state is SubcategoryError) {
                                return const SizedBox.shrink();
                              }
                              if (state is SubcategoryLoaded) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSelectField(
                                      controller: subCategoryController,
                                      hint: 'Select SubCategory',
                                      icon: Icons.widgets_outlined,
                                      isExpanded: subShowManagerDropdown,
                                      onTap: () {
                                        setState(() {
                                          subShowManagerDropdown =
                                              !subShowManagerDropdown;
                                        });
                                      },
                                    ),
                                    if (subShowManagerDropdown) ...[
                                      const SizedBox(height: 8),
                                      _buildDropdownList(
                                        itemCount: state.data!.length + 1,
                                        controller: subScrollController,
                                        itemBuilder: (context, index) {
                                          if (index >= state.data!.length) {
                                            return _buildLoader(
                                                state.totalRecords <=
                                                    state.data!.length);
                                          }
                                          final item = state.data![index];
                                          return _buildDropdownItem(
                                            text: item.categoryName.toString(),
                                            icon:
                                                Icons.subdirectory_arrow_right,
                                            iconColor: Colors.orange,
                                            bgColor: const Color(0xFFFFF7ED),
                                            onTap: () {
                                              subCategoryController.text =
                                                  item.categoryName.toString();
                                              subShowManagerDropdown = false;
                                              _selectedSubcategory =
                                                  item.categoryId;
                                              setState(() {});
                                            },
                                          );
                                        },
                                        emptyMessage:
                                            "No SubCategories Available",
                                        isEmpty: state.totalRecords == 0,
                                      ),
                                    ]
                                  ],
                                );
                              }
                              return Container();
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------- Service Details ----------
                      _SectionHeader(
                          title: 'Service Details',
                          icon: Icons.description_rounded),
                      const SizedBox(height: 12),
                      _sectionCard(
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _serviceNameController,
                              isMandatory: true,
                              label: 'Service Name',
                              maxLength: 100,
                              hint: 'e.g., Leaky Faucet Repair',
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              isMandatory: true,
                              controller: _descriptionController,
                              maxLength: 500,
                              label: 'Description',
                              hint: 'Describe the service you offer...',
                              maxLines: 4,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              isMandatory: false,
                              controller: addressController,
                              label: 'Service Location',
                              maxLength: 200,
                              hint: 'Enter service area or address',
                              maxLines: 2,
                              icon: Icons.location_on_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------- Additional Info ----------
                      _SectionHeader(
                          title: 'Included Items',
                          icon: Icons.check_circle_rounded),
                      const SizedBox(height: 12),
                      _sectionCard(
                        child: Column(
                          children: [
                            _buildTextField(
                              isMandatory: false,
                              controller: addInfoLine1Controller,
                              label: 'Additional Info 1',
                              maxLength: 100,
                              hint: 'e.g., Tools included',
                              icon: Icons.done_all_rounded,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              isMandatory: false,
                              controller: addInfoLine2Controller,
                              label: 'Additional Info 2',
                              maxLength: 100,
                              hint: 'e.g., 30 days warranty',
                              icon: Icons.done_all_rounded,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              isMandatory: false,
                              controller: addInfoLine3Controller,
                              label: 'Additional Info 3',
                              maxLength: 100,
                              hint: 'e.g., Free consultation',
                              icon: Icons.done_all_rounded,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------- Pricing & Duration ----------
                      _SectionHeader(
                          title: 'Pricing & Time',
                          icon: Icons.monetization_on_rounded),
                      const SizedBox(height: 12),
                      _sectionCard(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    isMandatory: true,
                                    controller: _priceController,
                                    label: 'Price (₹)',
                                    hint: '500',
                                    keyboardType: TextInputType.number,
                                    prefixIcon: const Icon(Icons.currency_rupee,
                                        size: 18),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDropdown(
                                    label: 'Duration',
                                    value: _selectedDuration,
                                    hint: 'Select',
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
                            const SizedBox(height: 20),
                            const Text(
                              'Availability Window',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'Start Time',
                                    time: startTime,
                                    onTap: () => _selectTime(context, true),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'End Time',
                                    time: endTime,
                                    onTap: () => _selectTime(context, false),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------- Available Days ----------
                      _SectionHeader(
                          title: 'Available Days',
                          icon: Icons.calendar_month_rounded),
                      const SizedBox(height: 12),
                      _sectionCard(
                        child: Wrap(
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
                          ].map((day) => _buildDayChip(day)).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------- Service Images ----------
                      _SectionHeader(
                          title: 'Gallery', icon: Icons.photo_library_rounded),
                      const SizedBox(height: 12),
                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedFile == null)
                              GestureDetector(
                                onTap: _pickAndUpload,
                                child: Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                      width: 2,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add_photo_alternate_rounded,
                                          color: Color(0xFF2563EB),
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Click to upload cover image',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      File(_selectedFile!.path),
                                      width: double.infinity,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Row(
                                      children: [
                                        _buildImageActionBtn(
                                          icon: Icons.edit_rounded,
                                          color: Colors.white,
                                          bgColor:
                                              Colors.black.withOpacity(0.6),
                                          onTap: _pickAndUpload,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildImageActionBtn(
                                          icon: Icons.close_rounded,
                                          color: Colors.white,
                                          bgColor: Colors.red.withOpacity(0.8),
                                          onTap: () => setState(() {
                                            _selectedFile = null;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100), // Spacing for bottom button
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: BlocConsumer<ServiceBloc, ServiceState>(
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
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: state is CreateServiceLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;

                                if (_selectedCategory == null) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Category');
                                  return;
                                }
                                if (_selectedSubcategory == null) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Sub Category');
                                  return;
                                }
                                if (_selectedDuration == null) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Duration');
                                  return;
                                }
                                if (startTime == null || endTime == null) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Timings');
                                  return;
                                }
                                if (startTime!.isAfter(endTime!)) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title:
                                          'Start Time must be before End Time');
                                  return;
                                }

                                availableDatesList.clear();
                                for (int i = 0; i < selectedDays.length; i++) {
                                  availableDatesList.add({
                                    "availableDate": selectedDays[i].toString(),
                                  });
                                }

                                double latitude = 0.0;
                                double longitude = 0.0;
                                try {
                                  Map<String, double>? location =
                                      await getCurrentLocation();
                                  if (location != null) {
                                    latitude = location['lat'] ?? 0.0;
                                    longitude = location['lng'] ?? 0.0;
                                  }
                                } catch (e) {
                                  print(e.toString());
                                }

                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();

                                String employeeId = preferences
                                        .getString(ApiConstants.userId) ??
                                    '';

                                final availableEndDates =
                                    '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
                                final availableStartTime =
                                    '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';

                                Map<String, dynamic> data = {
                                  "employeeId": employeeId,
                                  "name": _serviceNameController.text,
                                  "description": _descriptionController.text,
                                  "price": _priceController.text.isNotEmpty
                                      ? double.parse(_priceController.text)
                                      : 0.0,
                                  "duration":
                                      convertTimeToMinutes(_selectedDuration!),
                                  "status": "ACTIVE",
                                  "iconUrl": _selectedFile,
                                  "timeIn": availableStartTime,
                                  "timeOut": availableEndDates,
                                  "addInfoOne": addInfoLine1Controller.text,
                                  "addInfoTwo": addInfoLine2Controller.text,
                                  "addInfoThree": addInfoLine3Controller.text,
                                  "availableStartTime": availableStartTime,
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
                                            _selectedSubcategory.toString()));
                              },
                        child: state is CreateServiceLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Create Service',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
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

  // ---------- Helper Widgets ----------

  Widget _sectionCard({required Widget child}) {
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
      child: child,
    );
  }

  Widget _buildDropdownList({
    required int itemCount,
    required ScrollController controller,
    required IndexedWidgetBuilder itemBuilder,
    required String emptyMessage,
    required bool isEmpty,
  }) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 40, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(emptyMessage,
                      style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListView.builder(
                itemCount: itemCount,
                controller: controller,
                itemBuilder: itemBuilder,
              ),
            ),
    );
  }

  Widget _buildLoader(bool visible) {
    return Visibility(
      visible: visible,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }

  Widget _buildDropdownItem({
    required String text,
    required VoidCallback onTap,
    IconData? icon,
    Color? iconColor,
    Color? bgColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor ?? const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon,
                      size: 18, color: iconColor ?? const Color(0xFF2563EB)),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
    required bool isExpanded,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade500, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.text.isEmpty ? hint : controller.text,
                style: TextStyle(
                  fontSize: 15,
                  color: controller.text.isEmpty
                      ? Colors.grey.shade400
                      : const Color(0xFF1F2937),
                  fontWeight: controller.text.isNotEmpty
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isMandatory,
    int maxLines = 1,
    int? maxLength,
    IconData? icon,
    Widget? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.grey.shade400, fontWeight: FontWeight.normal),
            counterText: "",
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            prefixIcon: prefixIcon ??
                (icon != null
                    ? Icon(icon, size: 20, color: Colors.grey.shade400)
                    : null),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
          ),
          validator: (value) {
            if (isMandatory) if (value == null || value.isEmpty) {
              return 'Required';
            }
            return null;
          },
        ),
      ],
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF64748B)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(time),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: time != null
                        ? const Color(0xFF1F2937)
                        : Colors.grey.shade400,
                  ),
                ),
                Icon(Icons.access_time_rounded,
                    size: 20, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayChip(String day) {
    final isSelected = selectedDays.contains(day);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedDays.remove(day);
            } else {
              selectedDays.add(day);
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF2563EB) : const Color(0xFFF8FAFC),
            border: Border.all(
              color:
                  isSelected ? const Color(0xFF2563EB) : Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            day,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageActionBtn({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1D1E),
          ),
        ),
      ],
    );
  }
}
