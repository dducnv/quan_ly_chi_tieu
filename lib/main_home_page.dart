import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_event.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_event.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/calculate_percentage_page.dart';
import 'package:quan_ly_chi_tieu/ui/pages/currency_conversion/currency_conversion_page.dart';
import 'package:quan_ly_chi_tieu/ui/pages/home/home_page.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/bottom_navigation_bar_widget.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  MainHomePageState createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage> {
  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetBalanceEvent());
    context.read<HomeBloc>().add(GetSpendingLimitEvent());
    context.read<HomeBloc>().add(GetListCategoryTransaction());
    context.read<CurrencyConversionBloc>().add(GetDefaultCurrencyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFfffbfe), //i like transaparent :-)
          systemNavigationBarColor: Color(0xFFf3edf6), // navigation bar color
          statusBarIconBrightness: Brightness.dark, // status bar icons' color
          systemNavigationBarIconBrightness:
              Brightness.dark, //navigation bar icons' color
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBarWidget(
            onChanged: (index) {
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          ),
          body: SafeArea(
            bottom: false,
            right: false,
            left: false,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                HomePage(),
                CurrencyConversionPage(),
                CalculatePercentagePage()
              ],
            ),
          ),
        ));
  }
}
