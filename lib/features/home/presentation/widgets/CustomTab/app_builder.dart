import 'package:appcheck/appcheck.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppBuilder extends StatefulWidget {
  final List<GameEntity> app;
  const AppBuilder({required this.app, Key? key}) : super(key: key);

  @override
  State<AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder> {
  final CarouselController buttonCarouselController = CarouselController();

  int carosalIndex = 0;
  bool? isAvailable;
  List<GameEntity> recommendedApps = [];
  List<GameEntity> otherApps = [];
  int appNotFoundCode = 0;
  void separeteLists() {
    recommendedApps =
        widget.app.where((element) => element.isRecommended).toList();
    otherApps = widget.app.where((element) => !element.isRecommended).toList();
  }

  Future<bool> getApp(GameEntity gameEntity) async {
    try {
      bool isAvailable = await AppCheck.isAppEnabled(gameEntity.package);

      return isAvailable;
    } on PlatformException {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    separeteLists();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    isAvailable = await getApp(recommendedApps[carosalIndex]);
                    if (isAvailable!) {
                      return C.toast(text: 'This App Already Exist');
                    }
                    // ignore: use_build_context_synchronously
                    C.appSheet(context, recommendedApps[carosalIndex]);
                  },
                  child: CarouselSlider(
                    items: [
                      for (var e in widget.app)
                        if (e.isRecommended) Image.network(e.gameImage)
                    ],
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          carosalIndex = index;
                        });
                      },
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 2.0,
                      initialPage: recommendedApps.length,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                AnimatedSmoothIndicator(
                  activeIndex: carosalIndex,
                  count: 2,
                  onDotClicked: (index) {
                    buttonCarouselController.animateToPage(index);
                  },
                  effect: const WormEffect(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text('Others',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(otherApps.length, (index) {
              return InkWell(
                onTap: () async {
                  isAvailable = await getApp(otherApps[index]);
                  if (isAvailable!) {
                    return C.toast(text: 'This App Already exist');
                  }
                  // ignore: use_build_context_synchronously
                  C.appSheet(context, otherApps[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 85.w,
                    height: 85.h,
                    padding: EdgeInsets.all(18.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.h),
                      image: DecorationImage(
                          image: NetworkImage(otherApps[index].gameImage),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              );
            })),
          ),
        ],
      ),
    );
  }
}
