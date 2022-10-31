import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class EarnItem extends StatelessWidget {
  final String lottieAsset;
  final int amount;
  final bool? isEnabled;
  final VoidCallback onPressed;

  const EarnItem(
      {Key? key,
      required this.lottieAsset,
      required this.amount,
      this.isEnabled = true,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled!
          ? onPressed
          : () {
              if (HomeCubit.get(context).usageTime > 15) {
                return;
              }
              C.toast(text: 'Please spend more time', color: Colors.amber);
            },
      child: Stack(
        children: [
          Container(
            width: 110.w,
            height: 170.h,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.h,
                ),
                const Text(
                  'Today\'s rewords',
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
                Lottie.asset(
                  lottieAsset,
                  repeat: true,
                  animate: isEnabled,
                  width: 110.w,
                ),
                Text(
                  '$amount',
                  style: const TextStyle(color: Colors.amber, fontSize: 20),
                ),
              ],
            ),
          ),
          if (!isEnabled!)
            Container(
              width: 110.w,
              height: 170.h,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12)),
            ),
        ],
      ),
    );
  }
}
