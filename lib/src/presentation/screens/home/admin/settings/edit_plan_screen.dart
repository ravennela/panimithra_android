import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocConsumer, BlocListener, ReadContext;
import 'package:go_router/go_router.dart';
import 'package:panimithra/src/common/toast.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_event.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_state.dart'
    show
        FetchPlanByIdError,
        FetchPlanByIdLoaded,
        FetchPlanByIdLoadingState,
        FetchPlansLoaded,
        FetchPlansLoading,
        PlanState,
        UpdatePlanError,
        UpdatePlanLoaded;

class EditPlanScreen extends StatefulWidget {
  final String planId;
  const EditPlanScreen({super.key, required this.planId});

  @override
  State<EditPlanScreen> createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController originalPriceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  String _selectedDuration = '1 Month';
  int selectedDuration = 30;
  String _selectedStatus = "ACTIVE";
  @override
  void initState() {
    super.initState();
    context.read<PlanBloc>().add(FetchPlanByIdEvent(planId: widget.planId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Plans',
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: BlocConsumer<PlanBloc, PlanState>(
                buildWhen: (previous, current) => (current is UpdatePlanError ||
                    current is UpdatePlanLoaded ||
                    current is FetchPlanByIdLoaded ||
                    current is FetchPlanByIdError ||
                    current is FetchPlansLoading),
                listener: (context, state) {
                  if (state is FetchPlanByIdLoaded) {
                    _planNameController.text = state.plan.data?.planName ?? "";
                    _descriptionController.text =
                        state.plan.data?.planDescription ?? "";
                    _priceController.text = state.plan.data!.price.toString();
                    originalPriceController.text =
                        state.plan.data!.originalPrice.toString();
                    discountController.text =
                        state.plan.data!.discount.toString();
                    _selectedStatus = state.plan.data?.status ?? "ACTIVE";
                  }
                },
                builder: (context, state) {
                  if (state is FetchPlanByIdError) {
                    return Text(state.message);
                  }
                  if (state is FetchPlanByIdLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is FetchPlanByIdLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Plan Details',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: TextField(
                            controller: _planNameController,
                            decoration: const InputDecoration(
                              hintText: 'e.g., Premium Quarterly',
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 16,
                              ),
                              prefixIcon: const Icon(
                                Icons.edit_outlined,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText:
                                  'Enter a brief description of the plan...',
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 16,
                              ),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(top: 8, right: 8),
                                child: Icon(
                                  Icons.align_horizontal_left,
                                  color: Color(0xFF666666),
                                  size: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFE0E0E0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.flag_circle_outlined,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            items: ['ACTIVE', 'INACTIVE'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedStatus = newValue!;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 24),
                        // Price
                        const Text(
                          'Price (INR)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g., 999',
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 16,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 16, right: 8),
                                child: Icon(
                                  Icons.currency_rupee,
                                  color: Color(0xFF666666),
                                  size: 20,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                              ),
                              suffixIcon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        const Text(
                          'Original Price (INR)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: TextField(
                            controller: originalPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g., 999',
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 16,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 16, right: 8),
                                child: Icon(
                                  Icons.currency_rupee,
                                  color: Color(0xFF666666),
                                  size: 20,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                              ),
                              suffixIcon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Disccount (in % )',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: TextField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g., 50 %',
                              hintStyle: const TextStyle(
                                color: Color(0xFFBDBDBD),
                                fontSize: 16,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 16, right: 8),
                                child: Icon(
                                  Icons.currency_rupee,
                                  color: Color(0xFF666666),
                                  size: 20,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                              ),
                              suffixIcon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Duration',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedDuration,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.access_time,
                                color: Color(0xFF666666),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            items: ['1 Month', '3 Months', '6 Months', '1 Year']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDuration = newValue!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: BlocListener<PlanBloc, PlanState>(
                              listener: (context, state) {
                                if (state is UpdatePlanLoaded) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'success',
                                      title: "Plan Updated Successfully");
                                  context
                                      .read<PlanBloc>()
                                      .add(const FetchPlansEvent());
                                  context.pop();
                                }
                                if (state is UpdatePlanError) {
                                  ToastHelper.showToast(
                                      context: context,
                                      type: 'error',
                                      title: state.message);
                                }
                              },
                              child: ElevatedButton(
                                onPressed: () {
                                  print(_selectedDuration);
                                  if (_planNameController.text.isEmpty) {
                                    ToastHelper.showToast(
                                        context: context,
                                        type: 'error',
                                        title: "Please Enter Plan Name");
                                    return;
                                  }
                                  if (_descriptionController.text.isEmpty) {
                                    ToastHelper.showToast(
                                        context: context,
                                        type: 'error',
                                        title: "Please Enter Plan Description");
                                    return;
                                  }
                                  if (originalPriceController.text.isEmpty) {
                                    ToastHelper.showToast(
                                        context: context,
                                        type: 'error',
                                        title: "Please Enter Original Price");
                                    return;
                                  }
                                  if (_priceController.text.isEmpty) {
                                    ToastHelper.showToast(
                                        context: context,
                                        type: 'error',
                                        title: "Please Enter Plan Price");
                                    return;
                                  }
                                  if (_selectedDuration == "1 Month") {
                                    selectedDuration = 30;
                                  } else if (_selectedDuration == "3 Months") {
                                    selectedDuration = 90;
                                  } else if (_selectedDuration == "6 Months") {
                                    selectedDuration = 180;
                                  } else if (_selectedDuration == "1 Year") {
                                    selectedDuration = 365;
                                  }
                                  Map<String, dynamic> data = {
                                    "planName": _planNameController.text,
                                    "description": _descriptionController.text,
                                    "price":
                                        double.parse(_priceController.text),
                                    "durationInDays": selectedDuration,
                                    "status": _selectedStatus,
                                    "discount": discountController.text,
                                    "originalPrice":
                                        originalPriceController.text.isNotEmpty
                                            ? double.parse(
                                                originalPriceController.text)
                                            : 0.0
                                  };
                                  context.read<PlanBloc>().add(UpdatePlanEvent(
                                      planId: widget.planId, body: data));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF7A00),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Update Plan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
