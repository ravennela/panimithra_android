import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/employee_active_plan_model.dart';
import 'package:panimithra/src/data/models/order_creation_model.dart';

abstract class EmployeePaymentState extends Equatable {
  const EmployeePaymentState();

  @override
  List<Object?> get props => [];
}

class EmployeePaymentLoading extends EmployeePaymentState {}

class EmployeePaymentLoaded extends EmployeePaymentState {
  final EmployeeActivePlanModel paymentsData;
  final String message;

  const EmployeePaymentLoaded({
    required this.paymentsData,
    this.message = "",
  });

  @override
  List<Object?> get props => [paymentsData, message];
}

class EmployeePaymentError extends EmployeePaymentState {
  final String message;

  const EmployeePaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CreateOrderInitial extends EmployeePaymentState {}

class CreateOrderLoading extends EmployeePaymentState {}

class CreateOrderLoaded extends EmployeePaymentState {
  final OrderCreationModel successModel;

  const CreateOrderLoaded(this.successModel);

  @override
  List<Object?> get props => [successModel];
}

class CreateOrderError extends EmployeePaymentState {
  final String message;

  const CreateOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
