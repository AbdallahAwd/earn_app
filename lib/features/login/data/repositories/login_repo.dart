import 'package:dartz/dartz.dart';
import 'package:earnlia/features/login/data/datasources/login_reomte_data_source.dart';
import 'package:earnlia/features/login/domain/repositories/base_login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository extends BaseLoginRepository {
  final BaseLoginRemoteDataSource baseLoginRemoteDataSource;

  LoginRepository(this.baseLoginRemoteDataSource);
  @override
  Future<Either<FirebaseAuthException, UserCredential>> facebookLogin() async {
    try {
      final result = await baseLoginRemoteDataSource.facebookLogin();
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthException(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<FirebaseAuthException, UserCredential>> googleLogin() async {
    try {
      final user = await baseLoginRemoteDataSource.googleLogin();
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthException(code: e.code, message: e.message!));
    }
  }

  @override
  Future<Either<FirebaseAuthException, UserCredential>> login(
      {required String email, required String password}) async {
    try {
      final result = await baseLoginRemoteDataSource.login(
          email: email, password: password);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return left(FirebaseAuthException(
        code: e.code,
        message: e.message,
      ));
    }
  }

  @override
  Future<Either<FirebaseAuthException, void>> signOut() async {
    try {
      return Right(await baseLoginRemoteDataSource.signOut());
    } on FacebookAuthCredential catch (e) {
      return Left(FirebaseAuthException(
          code: e.idToken!,
          message: 'sign Out Error just happen in data source'));
    }
  }

  @override
  Future<Either<FirebaseAuthException, UserCredential>> registerUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final result = await baseLoginRemoteDataSource.registerUser(
          name: name, email: email, password: password);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthException(code: e.code, message: e.message));
    }
  }
}
