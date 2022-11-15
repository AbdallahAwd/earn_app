import 'package:earnlia/bloc_onserver.dart';
import 'package:earnlia/core/resources/colors.dart';
import 'package:earnlia/core/services/cache.dart';
import 'package:earnlia/core/services/locator.dart';
import 'package:earnlia/features/login/presentation/cubit/login_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routes/route.dart';
import 'features/home/presentation/pages/home.dart';
import 'features/login/presentation/pages/welcome.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  await Cache.init();

  ServiceLocator.init();
  final String? uId = Cache.getData(key: 'uId');

  Bloc.observer = MyBlocObserver();

  runApp(MyApp(uId));
}

class MyApp extends StatelessWidget {
  final String? uId;
  const MyApp(this.uId, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LoginCubit())],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: const Size(428, 926),
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Earnlia',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: const Color(0xff00A19F),
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  centerTitle: true,
                ),
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: AppColors.pColorSwatch,
                textTheme: TextTheme(
                  bodyText2:
                      TextStyle(fontSize: 24.sp, fontFamily: 'Montserrat'),
                )),
            onGenerateRoute: AppRoutes.generateRoute,
            home: uId != null ? const Home() : const Welcome(),
          );
        },
      ),
    );
  }
}
