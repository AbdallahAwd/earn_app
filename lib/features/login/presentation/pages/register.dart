import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/core/resources/strings.dart';
import 'package:earnlia/core/resources/styles.dart';
import 'package:earnlia/features/login/presentation/cubit/login_cubit.dart';
import 'package:earnlia/features/login/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routes/route.dart';
import '../../../../core/utils/button.dart';
import '../../../../core/utils/conponents.dart';
import '../../../../core/utils/textformfield.dart';

class Register extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is RegisterError) {
          C.snackBar(context, message: state.error, color: Colors.red);
        }
        if (state is FaceBookLoginError) {
          C.snackBar(context, message: state.error, color: Colors.red);
        }
        if (state is GoogleLoginError) {
          C.snackBar(context, message: state.error, color: Colors.red);
        }
        if (state is RegisterSuccess ||
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppStrings.registerText1,
                        style: AppStyles.bold(),
                      ),
                      Text(
                        AppStrings.registerText2,
                        style: AppStyles.semiBold(),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        AppStrings.registerText3,
                        style: AppStyles.normal(),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SocialButton(
                        text: AppStrings.googleButtonText,
                        onPressed: () {
                          LoginCubit.get(context)
                              .googleLoginOrSignUp(isSignUp: true);
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SocialButton(
                        onPressed: () {
                          LoginCubit.get(context)
                              .facebookLoginOrSignUp(isSignUp: true);
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
                        controller: nameController,
                        hintText: AppStrings.name,
                        icon: const Icon(Icons.account_circle),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please, Enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.h,
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
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        children: [
                          Text(
                            AppStrings.haveAccount,
                            style: AppStyles.normal(),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                    context, Routes.signIn);
                              },
                              child: const Text(AppStrings.signin))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: DefButton(
                          label: AppStrings.register,
                          isLoading: state is Loading,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).registerUser(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
