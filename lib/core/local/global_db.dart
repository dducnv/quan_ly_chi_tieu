import 'package:package_info_plus/package_info_plus.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';

String currencyApiKey = '0cf6ddbb42c906d3887063fc';
String currencyApiUrl =
    'https://v6.exchangerate-api.com/v6/$currencyApiKey/latest/';

double MAX_AMOUNT = 999999999999999;
int DEFAULT_LIMIT = 5000;
late ExpenseManagementDb database;

String locale = 'vi_VN';
late PackageInfo packageInfoGlobal;

late int numberLogins;