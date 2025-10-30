import 'package:dartz/dartz.dart';
import 'package:panimithra/src/data/models/login_model.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/typedef.dart';
import '../../entities/login.dart';
import '../../repositories/login_repository.dart';

class CreateloginLogin {
  final LoginRepository _repository;

  CreateloginLogin(this._repository);

  Future<Either<String, LoginModel>> call(Map<String, dynamic> data) async {
    return await _repository.createlogin(data);
  }
}
