import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/domain/usecase/create_order_usecase.dart';
import 'package:panimithra/src/domain/usecase/employee_plans_usecase.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_event.dart';
import 'package:panimithra/src/presentation/bloc/payments_bloc/payments_state.dart';

class EmployeePaymentBloc
    extends Bloc<EmployeePaymentEvent, EmployeePaymentState> {
  final GetEmployeePaymentsUseCase fetchEmployeePaymentsUseCase;
  final CreateOrderUseCase createOrderUseCase;
  EmployeePaymentBloc(
      {required this.fetchEmployeePaymentsUseCase,
      required this.createOrderUseCase})
      : super(EmployeePaymentLoading()) {
    on<LoadEmployeePaymentsEvent>(_onLoadEmployeePayments);
    on<CreateOrderEvent>(_createOrderEvent);
  }

  Future<void> _onLoadEmployeePayments(
    LoadEmployeePaymentsEvent event,
    Emitter<EmployeePaymentState> emit,
  ) async {
    emit(EmployeePaymentLoading());

    final result =
        await fetchEmployeePaymentsUseCase.execute(userId: event.userId);
    result.fold(
      (failure) => emit(EmployeePaymentError(message: failure)),
      (payments) => emit(EmployeePaymentLoaded(paymentsData: payments)),
    );
  }

  FutureOr<void> _createOrderEvent(
      CreateOrderEvent event, Emitter<EmployeePaymentState> emit) async {
    emit(CreateOrderLoading());
    final result = await createOrderUseCase(planId: event.planId);

    result.fold(
      (error) => emit(CreateOrderError(error)),
      (data) => emit(CreateOrderLoaded(data)),
    );
  }
}
