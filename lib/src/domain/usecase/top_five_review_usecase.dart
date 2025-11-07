import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/top_five_rating_model.dart';
import 'package:panimithra/src/domain/repositories/review_repository.dart';

class GetTopFiveRatingsUseCase {
  final ReviewRepository reviewRepository;

  GetTopFiveRatingsUseCase({required this.reviewRepository});

  Future<Either<String, TopFiveRatingModel>> call(
      {required String serviceId}) async {
    return await reviewRepository.getTopFiveRatingsRepo(serviceId: serviceId);
  }
}
