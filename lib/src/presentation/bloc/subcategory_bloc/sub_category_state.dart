// Subcategory States
import 'package:equatable/equatable.dart';
import 'package:panimithra/src/data/models/sub_category_model.dart';
import 'package:panimithra/src/data/models/success_model.dart';

abstract class SubcategoryState extends Equatable {
  const SubcategoryState();

  @override
  List<Object?> get props => [];
}

class SubcategoryInitial extends SubcategoryState {
  const SubcategoryInitial();
}

class SubcategoryLoading extends SubcategoryState {
  const SubcategoryLoading();
}

class SubcategoryError extends SubcategoryState {
  final String message;

  const SubcategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SubcategoryLoaded extends SubcategoryState {
  final String categoryId;
  final int page;
  final int totalRecords;
  final FetchSubcategoryModel fetchSubcategoryModel;
  final List<SubcategoryItem>? data;

  const SubcategoryLoaded({
    required this.categoryId,
    required this.page,
    required this.totalRecords,
    required this.fetchSubcategoryModel,
    this.data,
  });

  @override
  List<Object?> get props =>
      [categoryId, page, totalRecords, fetchSubcategoryModel, data];

  SubcategoryLoaded copyWith({
    String? categoryId,
    int? page,
    int? totalRecords,
    FetchSubcategoryModel? fetchSubcategoryModel,
    List<SubcategoryItem>? data,
  }) {
    return SubcategoryLoaded(
      categoryId: categoryId ?? this.categoryId,
      page: page ?? this.page,
      totalRecords: totalRecords ?? this.totalRecords,
      fetchSubcategoryModel:
          fetchSubcategoryModel ?? this.fetchSubcategoryModel,
      data: data ?? this.data,
    );
  }
}

class CreateSubcategoryLoading extends SubcategoryState {
  const CreateSubcategoryLoading();
}

class CreateSubcategoryLoaded extends SubcategoryState {
  final SuccessModel successModel;

  const CreateSubcategoryLoaded({required this.successModel});

  @override
  List<Object?> get props => [successModel];
}

class CreateSubcategoryError extends SubcategoryState {
  final String message;

  const CreateSubcategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
