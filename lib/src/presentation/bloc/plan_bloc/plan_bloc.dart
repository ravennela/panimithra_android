import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/domain/usecase/create_plan_usecase.dart';
import 'package:panimithra/src/domain/usecase/delete_plan_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_plan_by_id_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_plan_usecase.dart';
import 'package:panimithra/src/domain/usecase/update_plan_usecase.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_event.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final CreatePlanUseCase createPlanUseCase;
  final FetchPlansUseCase fetchPlansUseCase;
  final DeletePlanUseCase deletePlanUseCase;
  final FetchPlanByIdUseCase fetchPlanByIdUseCase;
  final UpdatePlanUseCase updatePlanUseCase;
  PlanBloc(
      {required this.createPlanUseCase,
      required this.fetchPlansUseCase,
      required this.fetchPlanByIdUseCase,
      required this.updatePlanUseCase,
      required this.deletePlanUseCase})
      : super(CreatePlanInitial()) {
    on<UpdatePlanEvent>((event, emit) async {
      emit(UpdatePlanLoading());

      final result = await updatePlanUseCase.call(
        planId: event.planId,
        body: event.body,
      );

      result.fold(
        (error) => emit(UpdatePlanError(error)),
        (success) => emit(UpdatePlanLoaded(success)),
      );
    });
    on<FetchPlanByIdEvent>((event, emit) async {
      emit(FetchPlanByIdLoadingState());
      final result = await fetchPlanByIdUseCase.call(
        event.planId,
      );

      result.fold(
        (error) => emit(FetchPlanByIdError(error)),
        (plan) => emit(FetchPlanByIdLoaded(plan)),
      );
    });

    /// 🔹 Handle CreatePlanEvent
    on<CreatePlanEvent>((event, emit) async {
      emit(CreatePlanLoading());

      final result = await createPlanUseCase.call(
          planName: event.planName,
          description: event.description,
          price: event.price,
          duration: event.duration,
          discount: event.discount,
          originalPrice: event.originalPrice);

      result.fold(
        (error) => emit(CreatePlanError(error)),
        (success) => emit(CreatePlanLoaded(success)),
      );
    });

    /// 🔹 (Optional) Handle FetchPlansEvent later when implemented
    on<FetchPlansEvent>((event, emit) async {
      emit(FetchPlansLoading());
      final result = await fetchPlansUseCase.call();
      result.fold(
        (error) => emit(FetchPlansError(error)),
        (data) => emit(FetchPlansLoaded(data)),
      );
    });
    on<DeletePlanEvent>((event, emit) async {
      emit(DeletePlanLoading());

      final result = await deletePlanUseCase.call(event.planId);

      result.fold(
        (error) => emit(DeletePlanError(error)),
        (success) => emit(DeletePlanLoaded(success)),
      );
    });
  }
}
