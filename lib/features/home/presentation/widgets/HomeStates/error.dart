import 'package:earnlia/core/routes/route.dart';
import 'package:earnlia/core/services/cache.dart';
import 'package:earnlia/core/utils/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorBody extends StatelessWidget {
  final String error;
  const ErrorBody({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error,
              color: Colors.white,
              size: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(error),
            const SizedBox(
              height: 20,
            ),
            DefButton(
                height: 60.h,
                width: 155.w,
                label: 'Try again',
                onPressed: () {
                  Cache.removeData('uId');
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.initialRoute, (route) => false);
                })
          ],
        ),
      ),
    );
  }
}
