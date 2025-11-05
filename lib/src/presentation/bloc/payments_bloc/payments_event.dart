import 'package:equatable/equatable.dart';

abstract class EmployeePaymentEvent extends Equatable {
  const EmployeePaymentEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployeePaymentsEvent extends EmployeePaymentEvent {
  final String userId;

  const LoadEmployeePaymentsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CreateOrderEvent extends EmployeePaymentEvent {
  final String planId;

  const CreateOrderEvent({required this.planId});

  @override
  List<Object?> get props => [planId];
}
