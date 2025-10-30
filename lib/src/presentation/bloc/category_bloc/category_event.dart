import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends CategoriesEvent {
  final int page;

  const FetchCategoriesEvent({required this.page});

  @override
  List<Object?> get props => [page];
}

class CreateCategoryEvent extends CategoriesEvent {
  final Map<String, dynamic> data;

  const CreateCategoryEvent({required this.data});

  @override
  List<Object?> get props => [data];
}
