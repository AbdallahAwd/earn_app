import 'package:earnlia/core/resources/assets.dart';
import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/utils/extentions.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:info_popup/info_popup.dart';

import '../../../../core/resources/styles.dart';
import '../../../../core/utils/conponents.dart';

class WithDraw extends StatefulWidget {
  final HomeState state;

  const WithDraw({required this.state, Key? key}) : super(key: key);

  @override
  State<WithDraw> createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double cToUSD;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _controller.forward();
    cToUSD = widget.state.user!.balance.fromCtoUSD();
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Withdraw Funds',
                  style: AppStyles.normal(color: Colors.white),
                ),
                const SizedBox(
                  width: 20,
                ),
                const InfoPopupWidget(
                  contentTitle:
                      'All Payments are processed manually & it can take up to 2 days',
                  arrowTheme: InfoPopupArrowTheme(
                    color: Colors.black,
                    arrowDirection: ArrowDirection.up,
                  ),
                  contentTheme: InfoPopupContentTheme(
                    infoContainerBackgroundColor: Colors.black,
                    infoTextStyle: TextStyle(color: Colors.white, fontSize: 10),
                    contentPadding: EdgeInsets.all(8),
                    contentBorderRadius: BorderRadius.all(Radius.circular(10)),
                    infoTextAlign: TextAlign.center,
                  ),
                  dismissTriggerBehavior: PopupDismissTriggerBehavior.anyWhere,
                  areaBackgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Divider(),
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 140.h,
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.opWhite,
                  borderRadius: BorderRadius.circular(22)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Available Funds',
                        style: AppStyles.normal(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${cToUSD.toStringAsFixed(2)} USD',
                        style: AppStyles.medium(),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Payment threshold',
                        style: AppStyles.small(),
                      ),
                      Text(
                        'USD 25',
                        style: AppStyles.small(),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        height: 100.h,
                        width: 100.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          value: _controller.value >= cToUSD.cPersentage() / 100
                              ? cToUSD.cPersentage() / 100
                              : _controller.value,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Positioned(
                          bottom: 35.sm,
                          left: 16.sp,
                          child: Text(
                              '${_controller.value >= cToUSD.cPersentage() / 100 ? cToUSD.cPersentage().toStringAsFixed(2) : (_controller.value * 100).toStringAsFixed(1)}%'))
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Select a payment method to withdraw your funds:',
              style: AppStyles.small(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //paypal
                InkWell(
                  onTap: () {
                    C.showPaypalDialog(context,
                        user: HomeCubit.get(context).model);
                  },
                  borderRadius: BorderRadius.circular(22),
                  enableFeedback: true,
                  child: Container(
                    width: 180.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                        color: AppColors.opWhite,
                        borderRadius: BorderRadius.circular(22)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          AppAssets.paypal,
                          width: 60.w,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Paypal',
                          style: AppStyles.normal(),
                        ),
                      ],
                    ),
                  ),
                ),
                //bank
                InkWell(
                  onTap: () {
                    C.showBankDialog(context,
                        user: HomeCubit.get(context).model);
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 180.w,
                    height: 140.h,
                    decoration: BoxDecoration(
                        color: AppColors.opWhite,
                        borderRadius: BorderRadius.circular(22)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          AppAssets.bank,
                          width: 60.w,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Bank',
                          style: AppStyles.normal(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
