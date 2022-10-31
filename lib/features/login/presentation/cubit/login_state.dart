part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class Loading extends LoginState {}

class LoadingGoogle extends LoginState {}

class LoadingFacebook extends LoginState {}

//email based
class LoginError extends LoginErrorState {
  const LoginError(super.error);
}

class LoginSuccess extends LoginState {}

//reigter
class RegisterError extends LoginErrorState {
  const RegisterError(super.error);
}

class RegisterSuccess extends LoginState {
  final UserCredential user;

  const RegisterSuccess(this.user);
}

//google
class GoogleLoginError extends LoginErrorState {
  const GoogleLoginError(super.error);
}

class GoogleLoginSuccess extends LoginState {}

//facebook
class FaceBookLoginError extends LoginErrorState {
  const FaceBookLoginError(super.error);
}

class FaceBookLoginSuccess extends LoginState {}

//signout
class SignOutSuccess extends LoginState {}

class SignOutError extends LoginErrorState {
  const SignOutError(super.error);
}
