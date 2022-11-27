import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/features/home/domain/entities/reword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as intl;

import 'package:shimmer/shimmer.dart';

import '../../../../../core/utils/conponents.dart';

class EarnBuilder extends StatelessWidget {
  final RewordEntity rewordEntity;
  final bool isEmptyWidget;
  final int index;
  const EarnBuilder(
      {Key? key,
      required this.rewordEntity,
      required this.index,
      required this.isEmptyWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isEmptyWidget) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: InkWell(
          onTap: () {
            C.earnDialog(context, rewordEntity, index: index);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reword:',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          children: [
                            Text(
                              intl.NumberFormat.decimalPattern()
                                  .format(rewordEntity.amount),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              AppAssets.C,
                              width: 18,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (rewordEntity.isRecommended)
                          Stack(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.amber,
                                highlightColor: Colors.white,
                                child: Container(
                                  width: 110.w,
                                  height: 30.h,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              Positioned(
                                left: 10.sm,
                                top: 7.sm,
                                child: const Text('Recommended',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black)),
                              )
                            ],
                          ),
                      ],
                    ),
                    Column(
                      children: [
                        if (rewordEntity.isRecommended)
                          Image.asset(
                            AppAssets.star,
                            width: 30,
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Lottie.asset(AppAssets.sad);
    }
  }
}
