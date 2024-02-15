import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';

class Debug {
  static bool isDebug = true;

  static void logMessage({
    required Object message,
    StackTrace? trace,
  }) {
    // var logger = Logger(filter: null, printer: PrettyPrinter(), output: null);
    // try {
    //   logger.d(message);
    // } catch (e) {
    //   logger.d(e);
    // }
    if (!isDebug) {
      return;
    }
    final text = message.toString();
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    final dateTimeNow =
        DateFormat('dd/MM/yyyy-HH:mm:ss').format(DateTime.now());
    if (kReleaseMode) {
      pattern
          .allMatches(text)
          .forEach((match) => debugPrint('${match.group(0)}'));
    } else {
      if (trace != null) {
        // final programInfo = CustomTrace(trace);
        // pattern.allMatches(text).forEach((match) =>
        //     debugPrint('${programInfo.traceString}:${match.group(0)}'));
        pattern
            .allMatches(text)
            .forEach((match) => debugPrint('$dateTimeNow: ${match.group(0)}'));
      } else {
        pattern
            .allMatches(text)
            .forEach((match) => debugPrint('$dateTimeNow: ${match.group(0)}'));
      }
    }
  }

  void removeWarning() {}
}

class CustomTrace {
  final StackTrace _trace;

  String? fileName;
  int? lineNumber;
  int? columnNumber;
  String get traceString =>
      'fileName: $fileName, lineNumber: $lineNumber, columnNumber: $columnNumber';

  CustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    /* The trace comes with multiple lines of strings, we just want the first line, which has the information we need */
    final traceString = _trace.toString().split('\n')[0];

    /* Search through the string and find the index of the file name by looking for the '.dart' regex */
    final indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z]+.dart'));

    final fileInfo = traceString.substring(indexOfFileName);

    final listOfInfos = fileInfo.split(':');

    /* Splitting fileInfo by the character ":" separates the file name, the line number and the column counter nicely.
      Example: main.dart:5:12
      To get the file name, we split with ":" and get the first index
      To get the line number, we would have to get the second index
      To get the column number, we would have to get the third index
    */

    fileName = listOfInfos[0];
    lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(')', '');
    columnNumber = int.parse(columnStr);
  }
}
