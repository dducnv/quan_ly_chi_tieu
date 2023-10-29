import 'package:flutter/material.dart';

class CaculatePercenMenuModel {
  String name;
  String recipe;
  String conditionName;
  Color? color;
  CaculatePercenMenuModel(
      {required this.name,
      required this.recipe,
      required this.conditionName,
      this.color});
}

class CaculatePercenMenuByCategory {
  String name;
  List<CaculatePercenMenuModel> listMenu;
  CaculatePercenMenuByCategory({required this.name, required this.listMenu});
}
