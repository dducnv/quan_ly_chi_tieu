import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:url_launcher/url_launcher.dart';

class NetworkUtils {
  static bool _certificateCheck(X509Certificate cert, String host, int port) =>
      true;

  static Future<bool> isNetworkAvailable() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  static Future<void> launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
