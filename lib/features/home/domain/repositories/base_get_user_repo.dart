import 'package:dartz/dartz.dart';
import 'package:earnlia/core/error/failuer.dart';
import 'package:earnlia/features/login/data/models/usage.dart';
import 'package:earnlia/features/login/domain/entities/login_entity.dart';

abstract class BaseHomeRepository {
  Future<Either<DataBaseFailure, LogInEntity>> getUser();

  Future<Either<DataBaseFailure, void>> updateUsage({required Usage usage});

  Future<Either<DataBaseFailure, void>> updateBalance(
      {required int balance, required int amount});
}
