import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_event.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_event.dart';
import 'package:quan_ly_chi_tieu/routes/route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 3500),
      () {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.mainHomePage, (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Center(
              child: Image.asset("assets/save-money.gif",
                  width: 200, height: 200)),
        ),
      ),
    );
  }
}
