import 'package:earnlia/core/utils/conponents.dart';
import 'package:earnlia/core/utils/extentions.dart';
import 'package:earnlia/features/home/presentation/cubit/home_cubit.dart';
import 'package:earnlia/features/home/presentation/pages/invite.dart';
import 'package:earnlia/features/home/presentation/pages/profile.dart';
import 'package:earnlia/features/home/presentation/pages/withdraw.dart';
import 'package:earnlia/features/home/presentation/widgets/HomeStates/success.dart';
import 'package:earnlia/core/resources/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';
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

  int cIndex = 0;
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
          ..getInvitedPeople(),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            List<Widget> items = [
              Success(state: state),
              WithDraw(state: state),
              Invite(state: state),
              Profile(
                state: state,
              ),
            ];
            if (state.states == States.success) {
              DateTime? lastPressed;
              return WillPopScope(
                  onWillPop: () async {
                    final now = DateTime.now();
                    List<String> lastOnline =
                        state.user!.lastBalanceUpdate.split('-');
                    int lastDay = int.parse(lastOnline[2]);
                    int thisDay = C.formattedDate.formateDate();

                    const maxDuration = Duration(seconds: 2);
                    final isWarning = lastPressed == null ||
                        now.difference(lastPressed!) > maxDuration;

                    if (isWarning) {
                      HomeCubit.get(context).getUsage();
                      lastPressed = DateTime.now();
                      Usage usages = state.user!.usage;
                      int time = HomeCubit.get(context).usageTime;
                      Fluttertoast.showToast(msg: 'Tap Again to exit');
                      if (lastDay + 7 >= thisDay) {
                        HomeCubit.get(context).usageOfToday(
                            usage: Usage(
                                monday: 0,
                                tuesday: 0,
                                wednesday: 0,
                                thursday: 0,
                                friday: 0,
                                saturday: 0,
                                sunday: 0));
                      }
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
                      HomeCubit.get(context).getUser();

                      return items[cIndex];
                    }),
                    bottomNavigationBar: SweetNavBar(
                      paddingGradientColor: const LinearGradient(
                          colors: AppColors.gradiantColor,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      currentIndex: cIndex,
                      paddingBackgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      items: [
                        SweetNavBarItem(
                            sweetIcon: const Icon(Icons.home_outlined),
                            sweetActive: const Icon(MyFlutterApp.home),
                            iconColors: AppColors.gradiantColor,
                            sweetLabel: 'Home'),
                        SweetNavBarItem(
                            sweetIcon: const Icon(MyFlutterApp.money_out),
                            sweetActive: const Icon(MyFlutterApp.money),
                            iconColors: AppColors.gradiantColor,
                            sweetLabel: 'Withdrow'),
                        SweetNavBarItem(
                            sweetIcon: const Icon(MyFlutterApp.message_out),
                            sweetActive: const Icon(MyFlutterApp.message),
                            iconColors: AppColors.gradiantColor,
                            sweetLabel: 'Invite'),
                        SweetNavBarItem(
                            sweetIcon: const Icon(MyFlutterApp.person_out),
                            sweetActive: const Icon(Icons.account_circle),
                            iconColors: AppColors.gradiantColor,
                            sweetLabel: 'Profile'),
                      ],
                      onTap: (index) {
                        setState(() {
                          cIndex = index;
                        });
                      },
                    ),
                  ));
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
