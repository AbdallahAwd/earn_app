import 'package:dartz/dartz.dart';
import 'package:earnlia/core/error/failuer.dart';
import 'package:earnlia/features/login/domain/entities/login_entity.dart';

import '../../../login/data/models/usage.dart';
import '../repositories/base_get_user_repo.dart';

class HomeUseCase {
  final BaseHomeRepository _baseGetUserRepository;

  HomeUseCase(this._baseGetUserRepository);

  Future<Either<dynamic, LogInEntity>> getUser() async {
    return await _baseGetUserRepository.getUser();
  }

  Future<Either<DataBaseFailure, void>> usageOfToday(
      {required Usage usage}) async {
    return await _baseGetUserRepository.updateUsage(usage: usage);
  }

  Future<Either<DataBaseFailure, void>> updateBalance(
      {required int balance, required int amount}) async {
    return await _baseGetUserRepository.updateBalance(
        amount: amount, balance: balance);
  }
}
