import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseLoginRepository {
  Future<Either<FirebaseAuthException, UserCredential>> login(
      {required String email, required String password});
  Future<Either<FirebaseAuthException, UserCredential>> googleLogin();
  Future<Either<FirebaseAuthException, UserCredential>> facebookLogin();

  Future<Either<FirebaseAuthException, UserCredential>> registerUser({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<FirebaseAuthException, void>> signOut();
}
