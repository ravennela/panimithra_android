// Subcategory BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/domain/usecase/create_subcategory_usecase.dart';
import 'package:panimithra/src/domain/usecase/delete_subcategory_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_subcategory_byid_usecase.dart';
import 'package:panimithra/src/domain/usecase/fetch_subcategory_usecase.dart';
import 'package:panimithra/src/domain/usecase/update_subcategory_usecase.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_event.dart';
import 'package:panimithra/src/presentation/bloc/subcategory_bloc/sub_category_state.dart';

class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  final FetchSubcategoriesUseCase fetchSubcategoriesUseCase;
  final CreateSubcategoryUseCase createSubcategoryUseCase;
  final DeleteSubcategoryUseCase deleteSubcategoryUseCase;
  final FetchSubcategoryByIdUsecase fetchSubcategoryByIdUseCase;
  final UpdateSubCategoryUseCase updateSubCategoryUseCase;
  SubcategoryBloc(
      {required this.fetchSubcategoriesUseCase,
      required this.createSubcategoryUseCase,
      required this.deleteSubcategoryUseCase,
      required this.fetchSubcategoryByIdUseCase,
      required this.updateSubCategoryUseCase})
      : super(const SubcategoryInitial()) {
    on<FetchSubcategoriesEvent>(_onFetchSubcategories);
    on<CreateSubcategoryEvent>(_onCreateSubcategory);
    on<DeleteSubcategoryEvent>(_onDeleteSubcategory);
    on<FetchSubcategoryByIdEvent>(_onFetchSubcategoryById);
    on<UpdateSubcategoryEvent>(_onUpdateSubcategory);
  }

  // ------------------------------------------------------
  // Fetch Subcategories (Paginated)
  // ------------------------------------------------------
  Future<void> _onFetchSubcategories(
    FetchSubcategoriesEvent event,
    Emitter<SubcategoryState> emit,
  ) async {
    if (event.page == 0) {
      emit(const SubcategoryLoading());
    }

    final result = await fetchSubcategoriesUseCase(
      categoryId: event.categoryId,
      page: event.page,
    );

    result.fold(
      (error) => emit(SubcategoryError(message: error)),
      (fetchSubcategoryModel) {
        List<SubcategoryItem> newData = fetchSubcategoryModel.data ?? [];

        if (event.page > 0 && state is SubcategoryLoaded) {
          final current = state as SubcategoryLoaded;
          if (current.categoryId == event.categoryId) {
            newData = [...(current.data ?? []), ...newData];
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
      (error) => emit(CreateSubcategoryError(message: error)),
      (successModel) =>
          emit(CreateSubcategoryLoaded(successModel: successModel)),
    );
  }

  // ------------------------------------------------------
  // Delete Subcategory
  // ------------------------------------------------------
  Future<void> _onDeleteSubcategory(
    DeleteSubcategoryEvent event,
    Emitter<SubcategoryState> emit,
  ) async {
    emit(const DeleteSubcategoryLoading());

    final result = await deleteSubcategoryUseCase(event.subcategoryId);

    result.fold(
      (error) => emit(DeleteSubcategoryError(message: error)),
      (successModel) =>
          emit(DeleteSubcategoryLoaded(successModel: successModel)),
    );
  }

  Future<void> _onUpdateSubcategory(
    UpdateSubcategoryEvent event,
    Emitter<SubcategoryState> emit,
  ) async {
    emit(const UpdateSubcategoryLoading());

    final data = await updateSubCategoryUseCase(event.data);

    data.fold(
      (error) => emit(UpdateSubcategoryError(message: error)),
      (successModel) =>
          emit(UpdateSubcategoryLoaded(successModel: successModel)),
    );
  }

  Future<void> _onFetchSubcategoryById(
    FetchSubcategoryByIdEvent event,
    Emitter<SubcategoryState> emit,
  ) async {
    emit(const FetchSubcategoryByIdLoading());

    final result = await fetchSubcategoryByIdUseCase(event.subcategoryId);

    result.fold(
      (error) => emit(FetchSubcategoryByIdError(message: error)),
      (subcategoryItem) =>
          emit(FetchSubcategoryByIdLoaded(subcategory: subcategoryItem)),
    );
  }
}
