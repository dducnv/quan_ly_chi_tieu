import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';
import 'package:quan_ly_chi_tieu/models/currency_conversion_model.dart';
import 'package:quan_ly_chi_tieu/services/api_service.dart';

extension CurrencyService on ApiService {
  Future<CurrencyConversionModel> getConversionRatesByCurrencyCode({
    String? currencyCode,
  }) async {
    currencyCode = currencyCode ?? 'USD';
    dynamic response = await get(
      currencyApiUrl + currencyCode,
    );
    Debug.logMessage(
        message:
            "CurrencyService getConversionRatesByCurrencyCode response: $response");
    return CurrencyConversionModel.fromJson(response);
  }
}
