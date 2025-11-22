import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/toast.dart' show ToastHelper;
import 'package:panimithra/src/data/datasource/remote/upload_file_remote_datasource.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_state.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_bloc.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_event.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_state.dart';

class EditSubcategoryScreen extends StatefulWidget {
  final String subCategoryId;
  final String categoryId;
  const EditSubcategoryScreen(
      {super.key, required this.subCategoryId, required this.categoryId});

  @override
  State<EditSubcategoryScreen> createState() => _EditSubcategoryScreenState();
}

class _EditSubcategoryScreenState extends State<EditSubcategoryScreen> {
  final TextEditingController _subCategoryNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _iconUrlController = TextEditingController();

  String _selectedStatus = 'ACTIVE';
  final List<String> _statusOptions = [
    'ACTIVE',
    'INACTIVE',
  ];
  File? _selectedFile;

  @override
  void dispose() {
    _subCategoryNameController.dispose();
    _descriptionController.dispose();
    _iconUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context
        .read<SubcategoryBloc>()
        .add(FetchSubcategoryByIdEvent(widget.subCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Sub Category',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<SubcategoryBloc, SubcategoryState>(
        buildWhen: (previous, current) => ((current is UpdateSubcategoryError ||
            current is FetchSubcategoryByIdLoaded ||
            current is FetchSubcategoryByIdError ||
            current is UpdateSubcategoryLoaded)),
        listener: (context, state) {
          if (state is FetchSubcategoryByIdLoaded) {
            _subCategoryNameController.text = state.subcategory.subCategoryname;
            _descriptionController.text = state.subcategory.description;
            _selectedStatus = state.subcategory.status;
            _iconUrlController.text = state.subcategory.iconUrl;
          }
        },
        builder: (context, state) {
          if (state is FetchSubcategoryByIdLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FetchSubcategoryByIdError) {
            return Center(
              child: Column(
                children: [
                  Column(
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
                        onPressed: () {},
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          if (state is FetchSubcategoryByIdLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Information Section
                    const Text(
                      'SubCategory Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category Name Field
                    const Text(
                      'SubCategory Name*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _subCategoryNameController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Plumbing',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
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
                          borderSide: const BorderSide(
                              color: Color(0xFF2196F3), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description Field
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'e.g., All plumbing-related services...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
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
                          borderSide: const BorderSide(
                              color: Color(0xFF2196F3), width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Configuration Section
                    const Text(
                      'Configuration',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Status Dropdown
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey[600]),
                        items: _statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Icon URL Field
                    const Text(
                      'Icon URL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

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

                    if (_selectedFile == null &&
                        _iconUrlController.text.isEmpty)
                      GestureDetector(
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
                                style: BorderStyle.solid),
                            color: Colors.grey.shade200,
                          ),
                          child: const Icon(Icons.add_photo_alternate,
                              color: Color(0xFF2563EB)),
                        ),
                      ),

                    if (_selectedFile == null &&
                        _iconUrlController.text.isNotEmpty)
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
                              child: Image.network(
                                _iconUrlController.text,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    const SizedBox(height: 40),

                    // Create Category Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: BlocConsumer<SubcategoryBloc, SubcategoryState>(
                        listener: (context, state) {
                          if (state is UpdateSubcategoryError) {
                            ToastHelper.showToast(
                                context: context,
                                type: 'error',
                                title: state.message);
                          }
                          if (state is UpdateSubcategoryLoaded) {
                            ToastHelper.showToast(
                                context: context,
                                type: 'success',
                                title: "Updated Subcategory Successfully");
                            context.read<SubcategoryBloc>().add(
                                  FetchSubcategoriesEvent(
                                    categoryId: widget.subCategoryId,
                                    page: 0,
                                  ),
                                );
                            context.pop();
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_subCategoryNameController.text.isEmpty) {
                                ToastHelper.showToast(
                                    context: context,
                                    type: 'error',
                                    title: "Please Enter SubCategory Name");
                                return;
                              }
                              Map<String, dynamic> data = {
                                "subCategoryName":
                                    _subCategoryNameController.text,
                                "description": _descriptionController.text,
                                "iconUrl": _selectedFile,
                                "status": _selectedStatus,
                                "categoryId": widget.categoryId,
                                "subCategoryId": widget.subCategoryId
                              };
                              context
                                  .read<SubcategoryBloc>()
                                  .add(UpdateSubcategoryEvent(data: data));
                              // Handle create category
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              state is UpdateCategoryLoading
                                  ? 'Updating ...'
                                  : "Update Subcategory",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
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
}
