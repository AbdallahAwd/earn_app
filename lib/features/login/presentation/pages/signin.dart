import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/core/resources/strings.dart';
import 'package:earnlia/core/resources/styles.dart';
import 'package:earnlia/features/login/presentation/cubit/login_cubit.dart';
import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/features/login/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/route.dart';
import '../../../../core/utils/button.dart';
import '../../../../core/utils/textformfield.dart';

class Signin extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Signin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          C.snackBar(context, message: state.error);
        }
        if (state is FaceBookLoginError) {
          C.snackBar(context, message: state.error);
        }
        if (state is GoogleLoginError) {
          C.snackBar(context, message: state.error);
        }
        if (state is LoginSuccess ||
            state is GoogleLoginSuccess ||
            state is FaceBookLoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.signUpText,
                      style: AppStyles.bold(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      AppStrings.signUpText2,
                      style: AppStyles.semiBold(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      AppStrings.signUpText3,
                      style: AppStyles.normal(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SocialButton(
                      text: AppStrings.googleButtonText,
                      isLoading: state is LoadingGoogle,
                      onPressed: () {
                        LoginCubit.get(context)
                            .googleLoginOrSignUp(isSignUp: false);
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    SocialButton(
                      isLoading: state is LoadingFacebook,
                      onPressed: () {
                        LoginCubit.get(context)
                            .facebookLoginOrSignUp(isSignUp: false);
                      },
                      backgroundColor: const Color(0xff163189),
                      text: AppStrings.facebookButtonText,
                      imagePath: AppAssets.facebook,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    DefTextformfield(
                      controller: emailController,
                      hintText: AppStrings.email,
                      icon: const Icon(Icons.email),
                      validator: (String? value) {
                        if (!value!.isEmail()) {
                          return 'Please, Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    DefTextformfield(
                      controller: passwordController,
                      hintText: AppStrings.password,
                      isObsecure: true,
                      icon: const Icon(Icons.lock_person_outlined),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please, Enter a  Password';
                        }
                        if (value.isNotEmpty && !value.isStrongPassword()) {
                          return 'Plaese use Uppercase letter at least 1';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.forgetPassword,
                          style: AppStyles.copyWith(
                            color: Colors.grey,
                          ),
                        )),
                    SizedBox(
                      height: 50.h,
                    ),
                    Row(
                      children: [
                        Text(
                          AppStrings.dontHaveAccount,
                          style: AppStyles.normal(),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                  context, Routes.register);
                            },
                            child: const Text(AppStrings.register))
                      ],
                    ),
                    DefButton(
                      label: AppStrings.signin,
                      isLoading: state is Loading,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          LoginCubit.get(context).login(
                              email: emailController.text.trim(),
                              password: passwordController.text);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

extension Validation on String {
  bool isEmail() => contains(RegExp('[a-zA-Z0-9]+[@][a-z]+[.][a-z]'));
  bool isStrongPassword() => contains(RegExp('[A-Z]'));
}
