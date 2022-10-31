import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/resources/strings.dart';
import 'package:earnlia/core/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/cache.dart';
import '../../../../core/services/location.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  void getLocationService() async {
    if (Cache.getData(key: 'location') == null) {
      await UserLocation().getLocation();
    }
  }

  @override
  void initState() {
    getLocationService();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animationController.addListener(() {
      setState(() {
        if (animationController.isCompleted) {
          Navigator.pushNamed(context, Routes.signIn);
        }
      });
    });
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 100.h,
          ),
          Image.asset(
            AppAssets.welcome,
            width: 400.w,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
            child: Text(
              AppStrings.weclomeScreen,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
          SizedBox(
            height: 80.h,
          ),
          Stack(
            children: [
              Container(
                width: 350.w,
                height: 84.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                        tileMode: TileMode.decal,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AppColors.gradiantColor)),
              ),
              Positioned(
                  right: animationController.value == 0
                      ? 50.sm
                      : (animationController.value * 160 * 1.4).sm,
                  top: 30.sm,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.register);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              Positioned(
                left: animationController.value * 180.sm,
                child: GestureDetector(
                  onTap: () {
                    animationController.forward();
                  },
                  onHorizontalDragUpdate: (details) {
                    int sensitivity = 8;
                    if (details.delta.dx > sensitivity) {
                      animationController.forward();
                    } else if (details.delta.dx < -sensitivity) {
                      animationController.reverse();
                    }
                  },
                  child: Container(
                    width: 175.w,
                    height: 84.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white),
                    child: const Center(child: Text('Sign in')),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
