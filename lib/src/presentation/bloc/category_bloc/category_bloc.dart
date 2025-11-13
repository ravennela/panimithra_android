import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/fetch_category_model.dart';
import 'package:panimithra/src/domain/usecase/create_category_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_categories_usecase.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_event.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final FetchCategoriesUseCase fetchCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;

  CategoriesBloc({
    required this.fetchCategoriesUseCase,
    required this.createCategoryUseCase,
  }) : super(const CategoriesInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<CreateCategoryEvent>(_onCreateCategory);
  }

  Future<void> _onFetchCategories(
    FetchCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    // Show loading only for first page
    if (event.page == 0) {
      emit(const CategoriesLoading());
    }

    final result = await fetchCategoriesUseCase(event.page);

    result.fold(
      (error) {
        emit(CategoriesError(message: error));
      },
      (fetchCategoryModel) {
        List<CategoryItem> newData = fetchCategoryModel.data ?? [];

        // Handle pagination: append data if not first page
        if (event.page > 0 && state is CategoriesLoaded) {
          final currentState = state as CategoriesLoaded;
          final existingData = currentState.data ?? [];
          newData = [...existingData, ...newData];
        }

        emit(CategoriesLoaded(
          page: event.page,
          totalRecords: fetchCategoryModel.totalItems ?? 0,
          fetchCategoryModel: fetchCategoryModel,
          data: newData,
        ));
      },
    );
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const CreateCategoryLoading());

    final result = await createCategoryUseCase(event.data);

    result.fold(
      (error) {
        emit(CreateCategoryError(message: error));
      },
      (successModel) {
        emit(CreateCategoryLoaded(successModel: successModel));
      },
    );
  }
}
