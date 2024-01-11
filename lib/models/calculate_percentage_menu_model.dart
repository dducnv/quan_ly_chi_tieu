import 'package:flutter/material.dart';

class CaculatePercenMenuModel {
  String name;
  String recipe;
  String routeName;
  Color? color;
  CaculatePercenMenuModel(
      {required this.name,
      required this.recipe,
      required this.routeName,
      this.color});
}

class CaculatePercenMenuByCategory {
  String name;
  List<CaculatePercenMenuModel> listMenu;
  CaculatePercenMenuByCategory({required this.name, required this.listMenu});
}
