import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/faq_model.dart';
import 'package:panimithra/src/domain/repositories/users_repository.dart';

class FetchFaqUseCase {
  final UserRepository repository;

  FetchFaqUseCase(this.repository);

  Future<Either<String, List<FaqModel>>> call() async {
    return await repository.fetchFaq();
  }
}
