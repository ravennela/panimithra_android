// Subcategory BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/domain/usecase/create_subcategory_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_subcategory_usecase.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_event.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_state.dart';

class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  final FetchSubcategoriesUseCase fetchSubcategoriesUseCase;
  final CreateSubcategoryUseCase createSubcategoryUseCase;
  SubcategoryBloc({
    required this.fetchSubcategoriesUseCase,
    required this.createSubcategoryUseCase,
  }) : super(const SubcategoryInitial()) {
    on<FetchSubcategoriesEvent>(_onFetchSubcategories);
    on<CreateSubcategoryEvent>(_onCreateSubcategory);
  }

  Future<void> _onFetchSubcategories(
    FetchSubcategoriesEvent event,
    Emitter<SubcategoryState> emit,
  ) async {
    // Show loading only for first page
    if (event.page == 1) {
      emit(const SubcategoryLoading());
    }

    final result = await fetchSubcategoriesUseCase(
      categoryId: event.categoryId,
      page: event.page,
    );

    result.fold(
      (error) {
        emit(SubcategoryError(message: error));
      },
      (fetchSubcategoryModel) {
        List<SubcategoryItem> newData = fetchSubcategoryModel.data ?? [];

        // Handle pagination: append data if not first page
        if (event.page > 1 && state is SubcategoryLoaded) {
          final currentState = state as SubcategoryLoaded;
          // Only append if same category
          if (currentState.categoryId == event.categoryId) {
            final existingData = currentState.data ?? [];
            newData = [...existingData, ...newData];
          }
        }

        emit(SubcategoryLoaded(
          categoryId: event.categoryId,
          page: event.page,
          totalRecords: fetchSubcategoryModel.totalItems ?? 0,
          fetchSubcategoryModel: fetchSubcategoryModel,
          data: newData,
        ));
      },
    );
  }

  Future<void> _onCreateSubcategory(
    CreateSubcategoryEvent event,
    Emitter<SubcategoryState> emit,
  ) async {
    emit(const CreateSubcategoryLoading());

    final result = await createSubcategoryUseCase(event.categoryId, event.data);

    result.fold(
      (error) {
        emit(CreateSubcategoryError(message: error));
      },
      (successModel) {
        emit(CreateSubcategoryLoaded(successModel: successModel));
      },
    );
  }
}
