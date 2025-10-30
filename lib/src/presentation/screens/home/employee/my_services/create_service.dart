import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/common/colors.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_event.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_state.dart';
import 'package:panimithra/src/presentation/bloc/service/service_bloc.dart';
import 'package:panimithra/src/presentation/bloc/service/service_event.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_event.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_state.dart';
import 'package:panimithra/src/utilities/location_fetch.dart';

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
  bool hasMoreRecords = true;
  Map<String, dynamic> availableDate = {};
  List<Map<String, dynamic>> availableDatesList = [];

  TextEditingController subCategoryController = TextEditingController();
  final ScrollController subScrollController = ScrollController();
  TextEditingController addressController = TextEditingController();
  Timer? _subDebounce;
  int subTotalRecords = 0;
  int subTotalLength = 0;
  int subPage = 1;
  bool subHasMoreRecords = true;

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
                              if (state is CategoriesLoaded) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: 'success',
                                    title: "Category Fetched successfully");
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
                                                      title: Text(
                                                          "${state.data![index].categoryName.toString()}"),
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
                              if (state is SubcategoryLoaded) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: 'success',
                                    title: "Category Fetched successfully");
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
                                                      title: Text(
                                                          "${state.data![index].categoryName.toString()}"),
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
                              label: 'Service Name',
                              hint: 'e.g., Leaky Faucet Repair',
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _descriptionController,
                              label: 'Service Description',
                              hint: 'Describe the service you offer...',
                              maxLines: 4,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: addressController,
                              label: 'Address',
                              hint: 'Address',
                              maxLines: 4,
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
                              children: List.generate(5, (index) {
                                return Container(
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
                                      ? const Icon(Icons.add_photo_alternate,
                                          color: Color(0xFF2563EB))
                                      : null,
                                );
                              }),
                            ),
                          ],
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
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
                            for (int i = 0; i < selectedDays.length; i++) {
                              availableDatesList.add({
                                "availableDate": selectedDays[i].toString(),
                              });
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

                            Map<String, dynamic> data = {
                              "name": _serviceNameController.text,
                              "description": _descriptionController.text,
                              "price": _priceController.text.isNotEmpty
                                  ? double.parse(_priceController.text)
                                  : 0.0,
                              "duration": 1,
                              "status": "ACTIVE",
                              "latitude": latitude,
                              "longitude": longitude,
                              "availableDates": availableDatesList,
                              "images": [
                                {"imageUrls": "hg"}
                              ],
                              "address": addressController.text
                            };

                            context.read<ServiceBloc>().add(CreateServiceEvent(
                                serviceData: data,
                                categoryId: _selectedCategory.toString(),
                                subCategoryId:
                                    _selectedSubcategory.toString()));
                          },
                          child: const Text(
                            'Submit for Approval',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: prefix,
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
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
