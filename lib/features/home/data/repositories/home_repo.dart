import 'package:dartz/dartz.dart';
import 'package:earnlia/core/error/failuer.dart';
import 'package:earnlia/features/home/data/datasources/home_data_source.dart';
import 'package:earnlia/features/home/domain/repositories/base_get_user_repo.dart';
import 'package:earnlia/features/login/data/models/usage.dart';
import 'package:earnlia/features/login/domain/entities/login_entity.dart';

class HomeRepository extends BaseHomeRepository {
  final BaseUserDataSource _baseUserDataSource;

  HomeRepository(this._baseUserDataSource);

  @override
  Future<Either<DataBaseFailure, LogInEntity>> getUser() async {
    try {
      return Right(await _baseUserDataSource.getUser());
    } on DataBaseFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<DataBaseFailure, void>> updateUsage(
      {required Usage usage}) async {
    try {
      var update = await _baseUserDataSource.updateUsageOfToday(usage: usage);
      return Right(update);
    } on DataBaseFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<DataBaseFailure, void>> updateBalance(
      {required int balance, required int amount}) async {
    try {
      return Right(await _baseUserDataSource.updateBalance(
          balance: balance, amount: amount));
    } on DataBaseFailure catch (e) {
      throw DataBaseFailure(e.message);
    }
  }
}
