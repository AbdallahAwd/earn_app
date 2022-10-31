import 'package:earnlia/core/resources/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final Color backgroundColor;
  final String imagePath;
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialButton(
      {Key? key,
      this.backgroundColor = Colors.white,
      this.imagePath = AppAssets.google,
      this.isLoading = false,
      required this.text,
      this.textColor = Colors.black,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65.h,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (isLoading)
              SizedBox(
                  height: 20.w,
                  width: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 0.8,
                  )),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 16.sp, color: textColor, fontFamily: 'Montserrat'),
            ),
            Image.asset(
              imagePath,
              width: 25.w,
            )
          ],
        ),
      ),
    );
  }
}
