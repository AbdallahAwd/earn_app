import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/resources/strings.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../domain/entities/reword.dart';
import 'earn_builder.dart';
import 'app_builder.dart';

class CustomTab extends StatefulWidget {
  final HomeState state;
  final String? op1;
  final String? op2;
  final List<Widget>? children;

  const CustomTab({
    Key? key,
    required this.state,
    this.op1,
    this.op2,
    this.children,
  }) : super(key: key);

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        (_pageController.position.viewportDimension);
      });

    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.opWhite, borderRadius: BorderRadius.circular(20)),
      height: 450,
      child: StreamBuilder<List<RewordEntity>>(
          stream: HomeCubit.get(context).getRewords(),
          builder: (context, snapshot1) {
            final List<RewordEntity> reword = snapshot1.data ?? [];

            return StreamBuilder<List<GameEntity>>(
                stream: HomeCubit.get(context).getGames(),
                builder: (context, snapshot2) {
                  final List<GameEntity> app = snapshot2.data ?? [];

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffD9D9D9),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _pageController.jumpToPage(0);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width -
                                            100) /
                                        2,
                                    height: 40.h,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    decoration: BoxDecoration(
                                        color: currentIndex == 0
                                            ? Colors.blue
                                            : Colors.transparent,
                                        gradient: LinearGradient(
                                            colors: [
                                              const Color(0xff00A19F),
                                              const Color(0xff0F0489)
                                                  .withOpacity(0.8)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7.0.h),
                                      child: Text(widget.op1 ?? 'Earn',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: currentIndex == 0
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 18.sp)),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _pageController.jumpToPage(1);
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(22),
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width -
                                            100) /
                                        2,
                                    height: 40.h,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: currentIndex == 1
                                          ? Colors.blue
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [
                                            const Color(0xff00A19F),
                                            const Color(0xff0F0489)
                                                .withOpacity(0.8)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7.0.h),
                                      child: Text(widget.op2 ?? 'Apps',
                                          style: TextStyle(
                                              color: currentIndex == 0
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 18.sp)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (snapshot1.hasData)
                          SizedBox(
                            height: 375.h,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (val) {
                                setState(() {
                                  currentIndex = val;
                                });
                              },
                              scrollDirection: Axis.horizontal,
                              children: widget.children ??
                                  [
                                    if (reword.isNotEmpty)
                                      ListView.separated(
                                          itemCount: reword.length,
                                          physics: reword.length > 3
                                              ? const BouncingScrollPhysics()
                                              : const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, index) =>
                                              EarnBuilder(
                                                rewordEntity: reword[index],
                                                isEmptyWidget: reword.isEmpty,
                                                index: index,
                                              )),
                                    if (reword.isEmpty)
                                      Lottie.asset(AppAssets.sad),
                                    AppBuilder(
                                      app: app,
                                    ),
                                  ],
                            ),
                          ),
                        if (snapshot1.hasError)
                          Column(
                            children: <Widget>[
                              const Icon(
                                Icons.error,
                                size: 80,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                snapshot1.error.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                });
          }),
    );
  }

  Widget isEmptyWidget() => Column(
        children: <Widget>[
          Lottie.asset(AppAssets.sad),
          const Text(AppStrings.noOffers)
        ],
      );
}
