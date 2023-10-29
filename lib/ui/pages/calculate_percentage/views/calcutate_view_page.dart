import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/components/calculatate_view_component.dart';

class CalcutateViewPage extends StatefulWidget {
  final String conditionSwitchWidget;
  final String title;
  const CalcutateViewPage(
      {Key? key, required this.conditionSwitchWidget, required this.title})
      : super(key: key);

  @override
  CalcutateViewPageState createState() => CalcutateViewPageState();
}

class CalcutateViewPageState extends State<CalcutateViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: switchWidgetWithCondition(widget.conditionSwitchWidget),
        )));
  }
}
