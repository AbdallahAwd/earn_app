import 'package:earnlia/features/home/presentation/pages/home.dart';
import 'package:earnlia/features/login/presentation/pages/register.dart';
import 'package:earnlia/features/login/presentation/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../features/login/presentation/pages/welcome.dart';

class Routes {
  static const String initialRoute = '/welcome';
  static const String signIn = '/signin';
  static const String register = '/register';
  static const String home = '/home';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initialRoute:
        return PageTransition(
          type: PageTransitionType.leftToRight,
          child: const Welcome(),
        );
      case Routes.signIn:
        return PageTransition(
            child: Signin(), type: PageTransitionType.rightToLeft);
      case Routes.register:
        return PageTransition(
            child: Register(), type: PageTransitionType.rightToLeft);
      case Routes.home:
        return PageTransition(
            child: const Home(), type: PageTransitionType.rightToLeft);
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                body: Center(child: Text('No Route Exist  ${settings.name}'))));
    }
  }
}
