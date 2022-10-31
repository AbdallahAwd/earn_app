import 'package:earnlia/features/login/domain/usecases/login_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/error_state.dart';
import '../../../../core/services/locator.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);

  void login({required String email, required String password}) async {
    emit(Loading());
    final result =
        await LoginUsecase(sl()).login(email: email, password: password);
    result.fold(
        (l) => emit(LoginError(l.message!)), (r) => emit(LoginSuccess()));
  }

  void registerUser(
      {required String email,
      required String password,
      required String name}) async {
    emit(Loading());
    final result = await LoginUsecase(sl())
        .registerUser(email: email, password: password, name: name);
    result.fold((l) => emit(RegisterError(l.message!)),
        (r) => emit(RegisterSuccess(r)));
  }

  void googleLoginOrSignUp({bool isSignUp = false}) async {
    emit(LoadingGoogle());
    final result = await LoginUsecase(sl()).googleLogin();
    result.fold((l) => emit(GoogleLoginError(l.message!)),
        (r) => emit(GoogleLoginSuccess()));
  }

  void facebookLoginOrSignUp({bool isSignUp = false}) async {
    emit(LoadingFacebook());
    final result = await LoginUsecase(sl()).facebookLogin();
    result.fold((l) => emit(FaceBookLoginError(l.message!)),
        (r) => emit(FaceBookLoginSuccess()));
  }

  void signOut() async {
    final out = await LoginUsecase(sl()).signOut();
    out.fold(
        (l) => emit(SignOutError(l.message!)), (r) => emit(SignOutSuccess()));
  }
}
