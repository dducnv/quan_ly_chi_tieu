import 'package:flutter/foundation.dart';

enum HomeIndexTab { quan_ly_chi_tieu, chuyen_doi_tien_te, tinh_phan_tram }

enum TransactionType { income, expense }

extension HomeIndexTabEx on HomeIndexTab {
  int get inInt => HomeIndexTab.values.indexOf(this);
  String get inString => describeEnum(this);
}
