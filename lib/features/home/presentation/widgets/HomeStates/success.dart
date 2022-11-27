import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/services/cache.dart';
import 'package:earnlia/core/utils/extentions.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/strings.dart';
import '../../../../../core/resources/styles.dart';
import '../../../../../core/utils/conponents.dart';
import '../CustomTab/custom_tab.dart';
import '../earn_item.dart';

class Success extends StatefulWidget {
  final HomeState state;
  const Success({Key? key, required this.state}) : super(key: key);

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  final String day = DateTime.now().weekday.daysOfTheWeek();
  List<ChartSeries<AppStatistics, String>> getSeries() {
    return <ChartSeries<AppStatistics, String>>[
      SplineSeries<AppStatistics, String>(
          dataSource: <AppStatistics>[
            AppStatistics(
              weekDays: 'Mon',
              min: widget.state.user!.usage.monday,
            ),
            AppStatistics(
              weekDays: 'Tues',
              min: widget.state.user!.usage.tuesday,
            ),
            AppStatistics(
              weekDays: 'Wedes',
              min: widget.state.user!.usage.wednesday,
            ),
            AppStatistics(
              weekDays: 'Thurs',
              min: widget.state.user!.usage.thursday,
            ),
            AppStatistics(
              weekDays: 'Fri',
              min: widget.state.user!.usage.friday,
            ),
            AppStatistics(
              weekDays: 'Satur',
              min: widget.state.user!.usage.saturday,
            ),
            AppStatistics(
              weekDays: 'Sun',
              min: widget.state.user!.usage.sunday,
            ),
          ],
          xValueMapper: (AppStatistics sales, _) => sales.weekDays,
          yValueMapper: (AppStatistics sales, _) => sales.min,
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'Earnlia')
    ];
  }

  int lastDate = 0;
  int currentDate = 0;
  List<String> isRewordDone = [];

  @override
  void initState() {
    lastDate = widget.state.user!.lastBalanceUpdate.formateDateToNum();
    currentDate =
        Cache.getData(key: 'currentDate') ?? C.formattedDate.formateDateToNum();
    initList();
    chechDate();
    super.initState();
  }

  void initList() async {
    isRewordDone =
        Cache.getStrings('isRewordsDone') ?? ['true', 'false', 'false'];
  }

  void chechDate() {
    if (currentDate > lastDate) {
      Cache.setStrings('isRewordsDone', ['true', 'false', 'false']);
    } else {
      Cache.setStrings('isRewordsDone', ['false', 'false', 'false']);
    }
  }

  @override
  Widget build(BuildContext context) {
    int time = HomeCubit.get(context).usageTime;

    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Hi, ${widget.state.user!.name}! 👋',
                style: AppStyles.normal(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: Colors.black.withOpacity(0.8),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                height: 125.h,
                width: double.infinity,
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(22.sm)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.yourBalance,
                      style: AppStyles.normal(),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppAssets.C,
                          width: 41.w,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(intl.NumberFormat.decimalPattern()
                                .format(HomeCubit.get(context).balance)),
                            Text(
                              '${HomeCubit.get(context).balance.fromCtoUSD()} USD',
                              style: const TextStyle(
                                  color: Colors.black26, fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(22)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: SfCartesianChart(
                  enableAxisAnimation: true,
                  backgroundColor: AppColors.opWhite,
                  title: ChartTitle(
                      text: 'Statistics', textStyle: AppStyles.normal()),
                  primaryXAxis: CategoryAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 1,
                      labelPosition: ChartDataLabelPosition.outside,
                      labelAlignment: LabelAlignment.center,
                      tickPosition: TickPosition.outside,
                      majorGridLines: const MajorGridLines(width: 0)),
                  primaryYAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.none,
                    labelPosition: ChartDataLabelPosition.outside,
                    labelAlignment: LabelAlignment.center,
                    tickPosition: TickPosition.outside,
                    opposedPosition: false,
                    minimum: 0,
                    maximum: 60,
                    interval: 5,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: getSeries(),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EarnItem(
                    amount: 300,
                    lottieAsset: AppAssets.nGift,
                    onPressed: () async {
                      HomeCubit.get(context).getUser();

                      HomeCubit.get(context).updateBalance(amount: 300);
                      setState(() {
                        HomeCubit.get(context).balance += 300;
                        currentDate -= 1;
                        Cache.setData(key: 'currentDate', value: currentDate);
                      });
                      isRewordDone[0] = 'false';
                      isRewordDone[1] = 'true';

                      C.toast(text: 'Done');
                    },
                    isEnabled: time > 3 && isRewordDone[0] == 'true',
                  ),
                  EarnItem(
                      amount: 500,
                      lottieAsset: AppAssets.gift,
                      onPressed: () {
                        HomeCubit.get(context).updateBalance(amount: 500);
                        setState(() {
                          HomeCubit.get(context).balance += 500;
                        });

                        isRewordDone[1] = 'false';
                        isRewordDone[2] = 'true';
                      },
                      isEnabled: time > 8 && isRewordDone[1] == 'true'),
                  EarnItem(
                      amount: 1000,
                      lottieAsset: AppAssets.tGift,
                      onPressed: () {
                        HomeCubit.get(context).updateBalance(amount: 1000);
                        setState(() {
                          HomeCubit.get(context).balance += 1000;
                        });
                        isRewordDone[2] = 'false';

                        Cache.setStrings('isRewordsDone', isRewordDone);
                      },
                      isEnabled: time > 15 && isRewordDone[2] == 'true'),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              CustomTab(state: widget.state),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class AppStatistics {
  final String weekDays;
  final num min;
  // final num secondSeriesYValue;

  AppStatistics({
    required this.weekDays,
    required this.min,
  });
}
