// Subcategory Events
import 'package:equatable/equatable.dart';

abstract class SubcategoryEvent extends Equatable {
  const SubcategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubcategoriesEvent extends SubcategoryEvent {
  final String categoryId;
  final int page;

  const FetchSubcategoriesEvent({
    required this.categoryId,
    required this.page,
  });

  @override
  List<Object?> get props => [categoryId, page];
}

class CreateSubcategoryEvent extends SubcategoryEvent {
  final Map<String, dynamic> data;
  final String categoryId;

  const CreateSubcategoryEvent({required this.data, required this.categoryId});

  @override
  List<Object?> get props => [data];
}

class DeleteSubcategoryEvent extends SubcategoryEvent {
  final String subcategoryId;

  const DeleteSubcategoryEvent({required this.subcategoryId});

  @override
  List<Object?> get props => [subcategoryId];
}

class FetchSubcategoryByIdEvent extends SubcategoryEvent {
  final String subcategoryId;

  const FetchSubcategoryByIdEvent(this.subcategoryId);

  @override
  List<Object?> get props => [subcategoryId];
}

class UpdateSubcategoryEvent extends SubcategoryEvent {
  final Map<String, dynamic> data;

  const UpdateSubcategoryEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
