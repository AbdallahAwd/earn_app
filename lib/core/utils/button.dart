import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefButton extends StatelessWidget {
  final String label;
  final double width;
  final VoidCallback onPressed;
  final double? height;
  final bool isLoading;
  const DefButton(
      {Key? key,
      required this.label,
      this.width = double.infinity,
      this.height,
      required this.onPressed,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 65.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.9],
          colors: AppColors.gradiantColor,
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  )),
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: AppStyles.medium().copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
