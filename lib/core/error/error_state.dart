import 'package:earnlia/features/login/presentation/cubit/login_cubit.dart';

class LoginErrorState extends LoginState {
  final String error;
  const LoginErrorState(this.error);
}
