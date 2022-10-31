import 'package:earnlia/core/utils/extentions.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:earnlia/features/home/presentation/widgets/HomeStates/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/resources/colors.dart';
import '../../../login/data/models/usage.dart';
import '../widgets/HomeStates/error.dart';
import '../widgets/HomeStates/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String day = DateTime.now().weekday.daysOfTheWeek();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: AppColors.pColorSwatch));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.gradiantColor,
        ),
      ),
      child: BlocProvider(
        create: (context) => HomeCubit()
          ..getUser()
          ..getUsage(),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.states == States.success) {
              DateTime? lastPressed;
              return WillPopScope(
                onWillPop: () async {
                  final now = DateTime.now();

                  const maxDuration = Duration(seconds: 2);
                  final isWarning = lastPressed == null ||
                      now.difference(lastPressed!) > maxDuration;

                  if (isWarning) {
                    HomeCubit.get(context).getUsage();
                    lastPressed = DateTime.now();
                    Usage usages = state.user!.usage;
                    int time = HomeCubit.get(context).usageTime;

                    Fluttertoast.showToast(msg: 'Tap Again to exit');
                    HomeCubit.get(context).usageOfToday(
                        usage: Usage(
                            monday: day == 'Monday' ? time : usages.monday,
                            tuesday: day == 'Tuesday' ? time : usages.tuesday,
                            wednesday:
                                day == 'Wednesday' ? time : usages.wednesday,
                            thursday:
                                day == 'Thursday' ? time : usages.thursday,
                            friday: day == 'Friday' ? time : usages.friday,
                            saturday:
                                day == 'Saturday' ? time : usages.saturday,
                            sunday: day == 'Sunday' ? time : usages.sunday));

                    return false;
                  } else {
                    return true;
                  }
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Builder(builder: (context) {
                    HomeCubit.get(context).getUsage();
                    return Success(state: state);
                  }),
                ),
              );
            } else if (state.states == States.error) {
              return ErrorBody(
                error: state.error,
              );
            } else {
              return const LoadingBody();
            }
          },
        ),
      ),
    );
  }
}
