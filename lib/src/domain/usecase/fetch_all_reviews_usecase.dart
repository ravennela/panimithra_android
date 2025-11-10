import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/fetch_reviews_model.dart';
import 'package:panimithra/src/domain/repositories/review_repository.dart';

class FetchAllReviewsUseCase {
  final ReviewRepository repository;

  FetchAllReviewsUseCase({required this.repository});

  Future<Either<String, FetchReviewsModel>> call({
    required String serviceId,
    required int pageNo,
  }) async {
    return await repository.fetchAllReviews(
      serviceId: serviceId,
      pageNo: pageNo,
    );
  }
}
