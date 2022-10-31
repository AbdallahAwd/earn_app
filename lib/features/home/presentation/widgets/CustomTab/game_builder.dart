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
                    Image.network(widget.game[currentIndex].gameImage),
                  ],
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                        print(index);
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
          SizedBox(
            height: 85.h,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          'https://play-lh.googleusercontent.com/N0UxhBVUmx8s7y3F7Kqre2AcpXyPDKAp8nHjiPPoOONc_sfugHCYMjBpbUKCMlK_XUs=w240-h480-rw',
                          width: 40,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
                itemCount: 10),
          )
        ],
      ),
    );
  }
}
