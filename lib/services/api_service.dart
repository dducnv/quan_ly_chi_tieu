import 'package:dio/dio.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';

class ApiService {
  Future<dynamic> get(String url) async {
    try {
      Debug.logMessage(message: "-------------------------------------");
      Debug.logMessage(message: "ApiService get url: $url");
      Debug.logMessage(message: "-------------------------------------");
      final response = await Dio().get(url);
      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }
}
