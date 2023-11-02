import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_bloc.dart';
import 'package:quan_ly_chi_tieu/main_home_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/analytic_bloc/analytic_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/core/common/user_management.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/core/local/database/platform/shared.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/routes/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting("vi_VN", null);
  Intl.defaultLocale = "vi_VN";

  database = constructDb('expense_management_db');
  tz.initializeTimeZones();

  tz.setLocalLocation(tz.getLocation("Asia/Ho_Chi_Minh"));
  try {
    await database.getBalance();
    await database.getSpendingLimit();
    await database.getCategory();
  } catch (e) {
    await database.initCategory();
    await database.createOrUpdateBalance(
        BalanceData(id: 1, dateCreated: DateTime.now(), amount: 1000));

    await database.createOrUpdateSpendingLimit(SpendingLimitData(
        id: 1,
        dateCreated: DateTime.now(),
        dateCreatedUntil: DateTime.now(),
        amount: 0));
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BaseBloc>(create: (context) => BaseBloc()),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<AnalyticBloc>(
          create: (context) => AnalyticBloc(),
        ),
        BlocProvider<CalculatePercentageBloc>(
            create: (context) => CalculatePercentageBloc()),
        BlocProvider<CurrencyConversionBloc>(
            create: (context) => CurrencyConversionBloc())
      ],
      child: MaterialApp(
        color: Colors.white,
        title: 'Quản lý chi tiêu',
        locale: const Locale('vi', 'VN'),
        navigatorKey: UserManagement().navigatorKey,
        debugShowCheckedModeBanner: false,
        themeAnimationDuration: const Duration(milliseconds: 700),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          applyElevationOverlayColor: false,
          primaryColor: const Color(0xFFc2e7ff),
          typography: Typography.material2014(),
        ),
        onGenerateRoute: AppRouter.generateRoute,
        home: const MainHomePage(),
      ),
    );
  }
}
