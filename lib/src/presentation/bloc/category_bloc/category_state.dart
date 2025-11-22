import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/fetch_category_by_id_model.dart';
import 'package:panimithra/src/data/models/fetch_category_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CategoriesLoaded extends CategoriesState {
  final int page;
  final int totalRecords;
  final FetchCategoryModel fetchCategoryModel;
  final List<CategoryItem>? data;

  const CategoriesLoaded({
    required this.page,
    required this.totalRecords,
    required this.fetchCategoryModel,
    this.data,
  });

  @override
  List<Object?> get props => [page, totalRecords, fetchCategoryModel, data];

  CategoriesLoaded copyWith({
    int? page,
    int? totalRecords,
    FetchCategoryModel? fetchCategoryModel,
    List<CategoryItem>? data,
  }) {
    return CategoriesLoaded(
      page: page ?? this.page,
      totalRecords: totalRecords ?? this.totalRecords,
      fetchCategoryModel: fetchCategoryModel ?? this.fetchCategoryModel,
      data: data ?? this.data,
    );
  }
}

class CreateCategoryLoading extends CategoriesState {
  const CreateCategoryLoading();
}

class CreateCategoryLoaded extends CategoriesState {
  final SuccessModel successModel;

  const CreateCategoryLoaded({required this.successModel});

  @override
  List<Object?> get props => [successModel];
}

class CreateCategoryError extends CategoriesState {
  final String message;

  const CreateCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteCategoryLoading extends CategoriesState {
  const DeleteCategoryLoading();
}

class DeleteCategoryLoaded extends CategoriesState {
  final SuccessModel successModel;

  const DeleteCategoryLoaded({required this.successModel});

  @override
  List<Object?> get props => [successModel];
}

class DeleteCategoryError extends CategoriesState {
  final String message;

  const DeleteCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class FetchCategoryByIdLoading extends CategoriesState {
  const FetchCategoryByIdLoading();
}

class FetchCategoryByIdLoaded extends CategoriesState {
  final FetchCategoryByIdModel fetchCategoryByIdModel;

  const FetchCategoryByIdLoaded({required this.fetchCategoryByIdModel});

  @override
  List<Object?> get props => [fetchCategoryByIdModel];
}

class FetchCategoryByIdError extends CategoriesState {
  final String message;

  const FetchCategoryByIdError({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateCategoryLoading extends CategoriesState {
  const UpdateCategoryLoading();
}

class UpdateCategoryLoaded extends CategoriesState {
  final SuccessModel successModel;

  const UpdateCategoryLoaded({required this.successModel});

  @override
  List<Object?> get props => [successModel];
}

class UpdateCategoryError extends CategoriesState {
  final String message;

  const UpdateCategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
