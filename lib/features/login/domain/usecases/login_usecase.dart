import 'package:dartz/dartz.dart';
import 'package:earnlia/features/login/domain/repositories/base_login_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginUsecase extends Equatable {
  final BaseLoginRepository baseLoginRepository;

  const LoginUsecase(this.baseLoginRepository);

  Future<Either<FirebaseAuthException, UserCredential>> login(
      {required String email, required String password}) async {
    return await baseLoginRepository.login(email: email, password: password);
  }

  Future<Either<FirebaseAuthException, UserCredential>> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    return await baseLoginRepository.registerUser(
        email: email, password: password, name: name);
  }

  Future<Either<FirebaseAuthException, UserCredential>> googleLogin() async {
    return await baseLoginRepository.googleLogin();
  }

  Future<Either<FirebaseAuthException, UserCredential>> facebookLogin() async {
    return await baseLoginRepository.facebookLogin();
  }

  Future<Either<FirebaseAuthException, void>> signOut() async {
    return await baseLoginRepository.signOut();
  }

  @override
  List<Object?> get props => [baseLoginRepository];
}
