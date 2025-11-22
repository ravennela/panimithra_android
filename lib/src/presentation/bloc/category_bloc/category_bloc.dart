import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/fetch_category_model.dart';
import 'package:panimithra/src/domain/usecase/create_category_usecase.dart';
import 'package:panimithra/src/domain/usecase/delete_category_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_categories_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_category_by_id_usecase.dart';
import 'package:panimithra/src/domain/usecase/update_category_usecase.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_event.dart';
import 'package:panimithra/src/presentation/bloc/category_bloc/category_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final FetchCategoriesUseCase fetchCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final DeleteCategoryUsecase deleteCategoryUseCase;
  final FetchCategoryByIdUseCase fetchCategoryByIdUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  CategoriesBloc(
      {required this.fetchCategoriesUseCase,
      required this.createCategoryUseCase,
      required this.fetchCategoryByIdUseCase,
      required this.updateCategoryUseCase,
      required this.deleteCategoryUseCase})
      : super(const CategoriesInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<FetchCategoryByIdEvent>(_onFetchCategoryById);
    on<UpdateCategoryEvent>(_onUpdateCategory);
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

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const DeleteCategoryLoading());

    final result = await deleteCategoryUseCase(event.categoryId);

    result.fold(
      (error) => emit(DeleteCategoryError(message: error)),
      (successModel) => emit(DeleteCategoryLoaded(successModel: successModel)),
    );
  }

  Future<void> _onFetchCategoryById(
    FetchCategoryByIdEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const FetchCategoryByIdLoading());

    final result = await fetchCategoryByIdUseCase(event.categoryId);

    result.fold(
      (error) => emit(FetchCategoryByIdError(message: error)),
      (fetchCategoryByIdModel) => emit(FetchCategoryByIdLoaded(
          fetchCategoryByIdModel: fetchCategoryByIdModel)),
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(const UpdateCategoryLoading());

    final result = await updateCategoryUseCase(event.data);

    result.fold(
      (error) => emit(UpdateCategoryError(message: error)),
      (successModel) => emit(UpdateCategoryLoaded(successModel: successModel)),
    );
  }
}
