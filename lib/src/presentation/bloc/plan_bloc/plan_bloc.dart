import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/domain/usecase/create_plan_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_plan_usecase.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_event.dart';
import 'package:panimithra/src/presentation/bloc/plan_bloc/plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final CreatePlanUseCase createPlanUseCase;
  final FetchPlansUseCase fetchPlansUseCase;

  PlanBloc({required this.createPlanUseCase, required this.fetchPlansUseCase})
      : super(CreatePlanInitial()) {
    /// 🔹 Handle CreatePlanEvent
    on<CreatePlanEvent>((event, emit) async {
      emit(CreatePlanLoading());

      final result = await createPlanUseCase.call(
        planName: event.planName,
        description: event.description,
        price: event.price,
        duration: event.duration,
      );

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
  }
}
