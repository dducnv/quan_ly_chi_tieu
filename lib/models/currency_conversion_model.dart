class CurrencyConversionModel {
  String? result;
  String? baseCode;
  Map<String, dynamic>? conversionRates;

  CurrencyConversionModel({
    this.result,
    this.baseCode,
    this.conversionRates,
  });

  factory CurrencyConversionModel.fromJson(Map<String, dynamic> json) =>
      CurrencyConversionModel(
        result: json["result"],
        baseCode: json["base_code"],
        conversionRates: Map.from(json["conversion_rates"]!)
            .map((k, v) => MapEntry<String, dynamic>(k, v?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "base_code": baseCode,
        "conversion_rates": Map.from(conversionRates!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
