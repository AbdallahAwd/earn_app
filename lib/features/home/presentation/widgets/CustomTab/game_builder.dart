import 'package:carousel_slider/carousel_slider.dart';
import 'package:earnlia/features/home/domain/entities/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GameBuilder extends StatefulWidget {
  final List<GameEntity> game;
  const GameBuilder({required this.game, Key? key}) : super(key: key);

  @override
  State<GameBuilder> createState() => _GameBuilderState();
}

class _GameBuilderState extends State<GameBuilder> {
  final CarouselController buttonCarouselController = CarouselController();

  int currentIndex = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                CarouselSlider(
                  items: [
                    for (var e in widget.game)
                      if (e.isRecommended) Image.network(e.gameImage),
                  ],
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 2.0,
                    initialPage: widget.game.length,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
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
              children: [
                for (var e in widget.game)
                  if (!e.isRecommended)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 85.w,
                        height: 85.h,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                              image: NetworkImage(e.gameImage),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
