import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';
import 'package:quan_ly_chi_tieu/routes/route_path.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/transactions_history_page.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/views/calculate_percentage_of_a_number_view.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/views/find_second_number_from_first_number_percent_view.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/views/percentage_between_two_numbers_view.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/views/percentage_increase_decrease_of_a_number_view.dart';
import 'package:quan_ly_chi_tieu/ui/pages/setting/setting_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Debug.logMessage(message: 'generateRoute: ${settings.name}');
    Widget? widget;
    switch (settings.name) {
      case RoutePaths.transactionsHistoryPage:
        widget = const TransactionsHistoryPage();
        break;

      case RoutePaths.settingScreen:
        widget = const SettingPage();
        break;

      //calculate percentage

      case RoutePaths.calculatePercentageOfANumber:
        widget = const CalculatePercentageOfANumberView();
        break;

      case RoutePaths.calculatePercentageBetweenTwoNumbersView:
        widget = const PercentageBetweenTwoNumbersView();
        break;

      case RoutePaths.calculatePercentageIncreaseDecreaseOfANumber:
        widget = const PercentageIncreaseDecreaseOfANumberView();
        break;

      case RoutePaths.calculateFindSecondNumberFromFirstNumberPercentView:
        widget = const FindSecondNumberFromFirstNumberPercentView();
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
