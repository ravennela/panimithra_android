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
  int page = 1;
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
  int subPage = 1;
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
    if (time == null) return "--:--";
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
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (subScrollController.position.pixels >=
          subScrollController.position.maxScrollExtent - 100) {
        if (subTotalLength >= subTotalRecords) {
          subHasMoreRecords = false;
          return;
        }
        if (subTotalLength <= subTotalRecords) {
          page += 1;
          context.read<SubcategoryBloc>().add(FetchSubcategoriesEvent(
              categoryId: _selectedCategory.toString(), page: page));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fill in the details below to list a new service.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // ---------- Service Details ----------
                      _sectionCard(
                        title: 'Service Details',
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
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.only(right: 12.0),
                                          child: IconButton(
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                            onPressed: () {
                                              setState(() {
                                                showManagerDropdown =
                                                    !showManagerDropdown;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        // _onManagerSearchChanged(value);
                                      },
                                    ),
                                    if (showManagerDropdown) ...[
                                      Container(
                                          height: 260,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorLight.textborder),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
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
                                                          child: const Center(
                                                              child:
                                                                  CircularProgressIndicator()));
                                                    }
                                                    return ListTile(
                                                      title: Text(state
                                                          .data![index]
                                                          .categoryName
                                                          .toString()),
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
                                                    );
                                                  })
                                              : const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          "No Category Available"),
                                                    ],
                                                  ),
                                                ))
                                    ]
                                  ],
                                );
                              }
                              return Container();
                            }),
                            const SizedBox(height: 24),
                            //sub category
                            BlocConsumer<SubcategoryBloc, SubcategoryState>(
                                listener: (context, state) {
                              if (state is SubcategoryError) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: 'error',
                                    title: state.message);
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
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.only(right: 12.0),
                                          child: IconButton(
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                            onPressed: () {
                                              setState(() {
                                                subShowManagerDropdown =
                                                    !subShowManagerDropdown;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        // _onManagerSearchChanged(value);
                                      },
                                    ),
                                    if (subShowManagerDropdown) ...[
                                      Container(
                                          height: 260,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorLight.textborder),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
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
                                                          child: const Center(
                                                              child:
                                                                  CircularProgressIndicator()));
                                                    }
                                                    return ListTile(
                                                      title: Text(state
                                                          .data![index]
                                                          .categoryName
                                                          .toString()),
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
                                                    );
                                                  })
                                              : const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          "No SubCategries Available"),
                                                    ],
                                                  ),
                                                ))
                                    ]
                                  ],
                                );
                              }
                              return Container();
                            }),

                            const SizedBox(height: 24),
                            _buildTextField(
                              controller: _serviceNameController,
                              maxLines: 1,
                              label: 'Service Name',
                              maxLenghth: 15,
                              hint: 'e.g., Leaky Faucet Repair',
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _descriptionController,
                              maxLenghth: 30,
                              label: 'Service Description',
                              hint: 'Describe the service you offer...',
                              maxLines: 4,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: addressController,
                              label: 'Address',
                              maxLenghth: 40,
                              hint: 'Address',
                              maxLines: 4,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: addInfoLine1Controller,
                              label: 'Additinal Info 1',
                              maxLenghth: 40,
                              hint: 'About Your Items Inlided In Service',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: addInfoLine2Controller,
                              label: 'Additinal Info 2',
                              maxLenghth: 40,
                              hint: 'About Your Items Inlided In Service',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: addInfoLine3Controller,
                              label: 'Additinal Info 3',
                              maxLenghth: 40,
                              hint: 'About Your Items Inlided In Service',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              margin: EdgeInsets.only(right: size.width * 0.45),
                              child: const Text("Select Available Timings",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                // Start Time Field
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectTime(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formatTime(startTime),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const Icon(Icons.access_time,
                                              size: 20, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // End Time Field
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _selectTime(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formatTime(endTime),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const Icon(Icons.access_time,
                                              size: 20, color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _priceController,
                                    label: 'Price',
                                    hint: 'e.g., 50',
                                    prefix: const Text('\$ '),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDropdown(
                                    label: 'Duration',
                                    value: _selectedDuration,
                                    hint: 'e.g., 1 hour',
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
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ---------- Service Images ----------
                      if (_selectedFile == null)
                        _sectionCard(
                          title: 'Service Images',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Add up to 5 images',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(1, (index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      _pickAndUpload();
                                    },
                                    child: Container(
                                      width: (size.width - 64) / 4,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          style: index == 0
                                              ? BorderStyle.solid
                                              : BorderStyle.none,
                                        ),
                                        color: index == 0
                                            ? Colors.transparent
                                            : Colors.grey.shade200,
                                      ),
                                      child: index == 0
                                          ? const Icon(
                                              Icons.add_photo_alternate,
                                              color: Color(0xFF2563EB))
                                          : null,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      if (_selectedFile != null)
                        GestureDetector(
                          onTap: () {
                            _pickAndUpload();
                          },
                          child: Container(
                            width: size.width * 0.2,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  File(_selectedFile!.path),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // ---------- Availability ----------
                      _sectionCard(
                        title: 'Set Your Availability',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
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
                                    (day) => ChoiceChip(
                                      label: Text(day),
                                      selected:
                                          selectedDays.contains(day), // demo
                                      onSelected: (element) {
                                        setState(() {});
                                        if (selectedDays.contains(day)) {
                                          selectedDays.remove(day);
                                        } else {
                                          selectedDays.add(day);
                                        }
                                      },
                                      selectedColor:
                                          (selectedDays.contains(day))
                                              ? Color(0xFF2563EB)
                                              : Colors.white,
                                      labelStyle: TextStyle(
                                        color: (selectedDays.contains(day))
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),

                      const Spacer(),
                      const SizedBox(height: 24),

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
                            context.pop();
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                print("form valid");
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
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
                                if (_serviceNameController.text.isEmpty) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Service Name');
                                  return;
                                }
                                if (_serviceNameController.text.isEmpty) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title:
                                          'Please Select Service Description');
                                  return;
                                }
                                if (_priceController.text.isEmpty) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Price');
                                  return;
                                }
                                for (int i = 0; i < selectedDays.length; i++) {
                                  availableDatesList.add({
                                    "availableDate": selectedDays[i].toString(),
                                  });
                                }
                                if (startTime == null) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Satrt Time');
                                  return;
                                }
                                if (endTime == null) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: 'Please Select Satrt Time');
                                  return;
                                }
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
                                          'Please Select Satrt Time Before End Time');
                                  return;
                                }

                                //sprint("available dates" + availableDate.toString());
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
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();

                                String employeeId = preferences
                                        .getString(ApiConstants.userId) ??
                                    '';

                                String availableStartTime =
                                    "${startTime!.hour}:${startTime!.minute} ${startTime!.period.name.toUpperCase()}";
                                String availableEndDates =
                                    "${endTime!.hour}:${endTime!.minute} ${endTime!.period.name.toUpperCase()}";
                                print("api call");
                                Map<String, dynamic> data = {
                                  "employeeId": employeeId,
                                  "name": _serviceNameController.text,
                                  "description": _descriptionController.text,
                                  "price": _priceController.text.isNotEmpty
                                      ? double.parse(_priceController.text)
                                      : 0.0,
                                  "duration": 1,
                                  "status": "ACTIVE",
                                  "iconUrl": _selectedFile,
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
                                print("api call");

                                context.read<ServiceBloc>().add(
                                    CreateServiceEvent(
                                        serviceData: data,
                                        categoryId:
                                            _selectedCategory.toString(),
                                        subCategoryId:
                                            _selectedSubcategory.toString()));
                              },
                              child: Text(
                                state is CreateServiceLoading
                                    ? 'Create Servicing ....'
                                    : "Creating Service",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Your service will be reviewed by our team before it goes live.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
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
    final picked = await UploadFileRemoteDatasource(client: Dio())
        .pickImage(); // pick from gallery
    if (picked == null) return;

    setState(() {
      _selectedFile = picked;
    });
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
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
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLenghth ?? 10,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: prefix,
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: const Color.fromARGB(255, 237, 241, 245),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
