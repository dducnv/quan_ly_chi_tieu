import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';
import 'package:quan_ly_chi_tieu/main_home_page.dart';
import 'package:quan_ly_chi_tieu/routes/route_path.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/transactions_history_page.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/views/calcutate_view_page.dart';
import 'package:quan_ly_chi_tieu/ui/pages/setting/setting_page.dart';
import 'package:quan_ly_chi_tieu/ui/pages/splash_screen/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Debug.logMessage(message: 'generateRoute: ${settings.name}');
    Widget? widget;
    switch (settings.name) {
      case RoutePaths.splashScreen:
        widget = const SplashScreen();
        break;
      case RoutePaths.mainHomePage:
        widget = const MainHomePage();
        break;
      case RoutePaths.transactionsHistoryPage:
        widget = const TransactionsHistoryPage();
        break;
      case RoutePaths.calculatePercentageViewPage:
        final args = settings.arguments as Map<String, dynamic>;
        widget = CalcutateViewPage(
          conditionSwitchWidget: args['conditionSwitchWidget'],
          title: args['title'],
        );
        break;
      case RoutePaths.settingScreen:
        widget = const SettingPage();
        break;
      default:
        widget = const Scaffold(
          body: SizedBox(
            child: Center(child: Text('Page not found')),
          ),
        );
    }
    return Platform.isIOS
        ? CupertinoPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => widget!)
        : PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, a1, a2) => widget!,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
  }
}
