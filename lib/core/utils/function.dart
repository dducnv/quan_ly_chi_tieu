import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:url_launcher/url_launcher.dart';

extension CapExtension on String {
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get allCaps => toUpperCase();
  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalizeFirst)
      .join(" ");
}

String convertToPercent(double amount,
    {double? finalNumber, int? numberDecimals}) {
  int numberDecimalsGet = numberDecimals ??
      (finalNumber == null
          ? getDecimalPlaces(amount) > 2
              ? 2
              : getDecimalPlaces(amount)
          : getDecimalPlaces(finalNumber) > 2
              ? 2
              : getDecimalPlaces(finalNumber));

  String roundedAmount = amount.toStringAsFixed(numberDecimalsGet);

  return "$roundedAmount%";
}

int getDecimalPlaces(double number) {
  final decimalString = number.toString();
  final decimalIndex = decimalString.indexOf('.');

  if (decimalIndex == -1) {
    return 0;
  } else {
    final decimalPlaces = decimalString.length - decimalIndex - 1;
    final trailingZeros =
        decimalString.substring(decimalIndex + 1).replaceAll('0', '');
    return trailingZeros.isEmpty ? 0 : decimalPlaces;
  }
}

String removeLastCharacter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text.substring(0, text.length - 1);
}

int countDecimalDigits(String value) {
  int decimalIndex = value.indexOf('.');
  if (decimalIndex == -1) {
    return 0;
  }

  int count = 0;
  for (int i = decimalIndex + 1; i < value.length; i++) {
    count++;
  }
  return count;
}

bool hasDecimalPoints(double? value) {
  if (value == null) return false;
  String stringValue = value.toString();
  int dotIndex = stringValue.indexOf('.');

  if (dotIndex != -1) {
    for (int i = dotIndex + 1; i < stringValue.length; i++) {
      if (stringValue[i] != '0') {
        return true;
      }
    }
  }

  return false;
}

String getMonth(int monthIndex) {
  DateTime dateTime = DateTime(DateTime.now().year, monthIndex + 1);
  String monthName = DateFormat(
    'MMMM', /*navigatorKey.currentContext?.locale.toString()*/
  ).format(dateTime);
  return monthName;
}

String getWordedTime(DateTime dateTime) {
  return DateFormat.jm('vn_VN').format(dateTime);
}

checkYesterdayTodayTomorrow(DateTime date) {
  DateTime now = DateTime.now();
  if (date.day == now.day && date.month == now.month && date.year == now.year) {
    return "Hôm nay";
  }
  DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
  if (date.day == tomorrow.day &&
      date.month == tomorrow.month &&
      date.year == tomorrow.year) {
    return "Ngày mai";
  }
  DateTime yesterday = now.subtract(const Duration(days: 1));
  if (date.day == yesterday.day &&
      date.month == yesterday.month &&
      date.year == yesterday.year) {
    return "Hôm qua";
  }

  return false;
}

// e.g. Today/Yesterday/Tomorrow/Tuesday/ Mar 15
String getWordedDateShort(
  DateTime date, {
  includeYear = false,
  showTodayTomorrow = true,
}) {
  if (showTodayTomorrow && checkYesterdayTodayTomorrow(date) != false) {
    return checkYesterdayTodayTomorrow(date);
  }

  const locale = '';

  if (includeYear) {
    return DateFormat.yMMMd(locale).format(date);
  } else {
    return DateFormat.MMMd(locale).format(date);
  }
}

// e.g. Today/Yesterday/Tomorrow/Tuesday/ March 15
String getWordedDateShortMore(DateTime date,
    {includeYear = false, includeTime = false, includeTimeIfToday = false}) {
  if (checkYesterdayTodayTomorrow(date) != false) {
    if (includeTimeIfToday) {
      return checkYesterdayTodayTomorrow(date) +
          " - " +
          DateFormat('h:mm aaa', locale).format(date);
    } else {
      return checkYesterdayTodayTomorrow(date);
    }
  }

  if (includeYear) {
    return "${DateFormat.MMMMd(locale).format(date)}, ${DateFormat.y(locale).format(date)}";
  } else if (includeTime) {
    return "${DateFormat.MMMMd(locale).format(date)}, ${DateFormat.y(locale).format(date)} - ${DateFormat('h:mm aaa', locale).format(date)}";
  }
  return DateFormat.MMMMd(locale).format(date);
}

String getTimeAgo(DateTime time) {
  final duration = DateTime.now().difference(time);
  if (duration.inDays >= 7) {
    return getWordedDateShortMore(
      time,
      includeTime: false,
      includeTimeIfToday: true,
    );
  } else if (duration.inDays >= 1) {
    if (duration.inDays == 1) {
      return '1 ngày trước';
    }
    return '${duration.inDays} ngày trước';
  } else if (duration.inHours >= 1) {
    if (duration.inHours == 1) {
      return '1 giờ trước';
    }
    return '${duration.inHours} giờ trước';
  } else if (duration.inMinutes >= 1) {
    if (duration.inMinutes == 1) {
      return '1 phút trước';
    }
    return '${duration.inMinutes} phút trước';
  }
  return 'Vừa xong';
}

final localeMap = {
  'USD': 'en_US',
  'VND': 'vi_VN',
  'CNY': 'zh_CN', // Chinese Yuan
  'MYR': 'ms_MY', // Malaysian Ringgit
  'JPY': 'ja_JP', // Japanese Yen
  'KRW': 'ko_KR', // South Korean Won
  'TWD': 'zh_TW', // New Taiwan Dollar
  'GBP': 'en_GB',
  'IDR': 'id_ID', // Indonesian Rupiah
  'SGD': 'en_SG', // Singapore Dollar
  'INR': 'hi_IN', // Indian Rupee
  'LAK': 'lo_LA', // Lao Kip
  'THB': 'th_TH', // Thai Baht
  'RUB': 'ru_RU',
  'AUD': 'en_AU', // Australian Dollar
  'NZD': 'en_NZ', // New Zealand Dollar
};

String convertToMoney(double amount, {String? currency}) {
  final locale = currency != null ? localeMap[currency] : 'vi_VN';
  final formatCurrency = NumberFormat.simpleCurrency(locale: locale);
  final formattedAmount = formatCurrency.format(amount);
  return formattedAmount;
}

String convertToMoneyWithoutSymbol(double amount, {String? currency}) {
  final locale = currency != null ? localeMap[currency] : 'en';
  final formatCurrency = NumberFormat.currency(locale: locale, symbol: '');

  return formatCurrency.format(amount);
}

String formatNumber(String s) =>
    NumberFormat.decimalPattern('en').format(int.parse(s));

//e.g. Today/Yesterday/Tomorrow/Tuesday/ Thursday, September 15
getWordedDate(DateTime date,
    {bool includeMonthDate = false, bool includeYearIfNotCurrentYear = true}) {
  DateTime now = DateTime.now();

  String extraYear = "";
  if (includeYearIfNotCurrentYear && now.year != date.year) {
    extraYear = ", ${date.year}";
  }

  if (checkYesterdayTodayTomorrow(date) != false) {
    return checkYesterdayTodayTomorrow(date) +
        (includeMonthDate
            ? ", ${DateFormat.MMMMd(locale).format(date)}$extraYear"
            : "");
  }

  if (includeMonthDate == false &&
      now.difference(date).inDays < 4 &&
      now.difference(date).inDays > 0) {
    String weekday = DateFormat('EEEE', locale).format(date);
    return weekday + extraYear;
  }
  return DateFormat.MMMMEEEEd(locale).format(date).toString() + extraYear;
}

setTextInput(inputController, value) {
  inputController.value = TextEditingValue(
    text: value,
    selection: TextSelection.fromPosition(
      TextPosition(offset: value.length),
    ),
  );
}

//get the current period of a repetitive budget

double getPercentBetweenDates(DateTimeRange timeRange, DateTime currentTime) {
  int millisecondDifference = timeRange.end.millisecondsSinceEpoch -
      timeRange.start.millisecondsSinceEpoch +
      const Duration(days: 1).inMilliseconds;
  double percent = (currentTime.millisecondsSinceEpoch -
          timeRange.start.millisecondsSinceEpoch) /
      millisecondDifference;
  return percent * 100;
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day + 1);
  return (to.difference(from).inHours / 24).round();
}

String pluralString(bool condition, String string) {
  if (condition) {
    return string;
  } else {
    return "${string}s";
  }
}

bool isNumber(dynamic value) {
  if (value == null) {
    return false;
  }
  return num.tryParse(value.toString()) != null;
}

bool getIsKeyboardOpen(context) {
  return EdgeInsets.zero !=
      EdgeInsets.fromViewPadding(
          View.of(context).viewInsets, View.of(context).devicePixelRatio);
}

double getKeyboardHeight(context) {
  return EdgeInsets.fromViewPadding(
          View.of(context).viewInsets, View.of(context).devicePixelRatio)
      .bottom;
}

List<String> extractLinks(String text) {
  RegExp regExp = RegExp(r'(http(s)?://)?(www\.)?\S+\.(com|ca)(?![0-9.])');
  Iterable<RegExpMatch> matches = regExp.allMatches(text);
  List<String> links = [];
  for (RegExpMatch match in matches) {
    links.add(match.group(0)!);
  }
  return links;
}

double? getAmountFromString(String inputString) {
  bool isNegative = false;
  if (inputString.contains("-") ||
      inputString.contains("—") ||
      inputString.contains("−") ||
      inputString.contains("–") ||
      inputString.contains("‐") ||
      inputString.contains("−") ||
      inputString.contains("⁃") ||
      inputString.contains("‑") ||
      inputString.contains("‒") ||
      inputString.contains("–") ||
      inputString.contains("—") ||
      inputString.contains("―")) {
    isNegative = true;
  }
  if (getDecimalSeparator() == ",") {
    inputString = inputString.replaceAll(",", ".");
  } else {
    inputString = inputString.replaceAll(",", "");
  }
  RegExp regex = RegExp(r'[0-9]+(?:\.[0-9]+)?');
  String? match = regex.stringMatch(inputString);

  if (match != null) {
    double amount = double.tryParse(match) ?? 0.0;
    amount = amount.abs();
    if (isNegative) {
      amount = amount * -1;
    }
    return amount;
  }
  return null;
}

enum PlatformOS {
  isIOS,
  isAndroid,
  web,
}

dynamic nullIfIndexOutOfRange(List list, index) {
  if (list.length - 1 < index || index < 0) {
    return null;
  } else {
    return list[index];
  }
}

double getDeviceAspectRatio(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  final double aspectRatio = size.height / size.width;
  return aspectRatio;
}

String getDecimalSeparator() {
  return numberFormatSymbols[Platform.localeName.split("-")[0]]?.DECIMAL_SEP ??
      ".";
}

NumberFormat getNumberFormat({int? decimals}) {
  return NumberFormat.currency(
    decimalDigits: decimals ?? 2,
    locale: Platform.localeName,
    symbol: "",
  );
}

void openUrl(String link) async {
  if (await canLaunchUrl(Uri.parse(link))) {
    await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
  }
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  String date = DateFormat('yyyy-MM-dd_HH:mm:ss').format(DateTime.now()); // 2021-12-31_10:59:59 

  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback_${date}.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}
