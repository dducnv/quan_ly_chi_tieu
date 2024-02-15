import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_event.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_state.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

class PercentageBetweenTwoNumbersView extends StatefulWidget {
  const PercentageBetweenTwoNumbersView({Key? key}) : super(key: key);

  @override
  State<PercentageBetweenTwoNumbersView> createState() =>
      _PercentageBetweenTwoNumbersViewState();
}

class _PercentageBetweenTwoNumbersViewState
    extends State<PercentageBetweenTwoNumbersView> {
  final _controllerFirstNumber = TextEditingController();
  final _controllerSecondNumber = TextEditingController();

  void handleCalculate() {
    if (_controllerFirstNumber.text == '' ||
        _controllerSecondNumber.text == '') {
      AppPopUp.showPopup(
          context: context,
          isShowButtonSelect: false,
          textCancel: "Đã hiểu",
          childMessage: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: TextFont(
              text: "Bạn chưa nhập đủ số cần tính",
              fontSize: 16,
            ),
          ));
      return;
    }
    context.read<CalculatePercentageBloc>().add(
          CalculatePercentageBetweenTwoNumbersEvent(
              firstNumber:
                  double.parse(_controllerFirstNumber.text.replaceAll(",", "")),
              secondNumber: double.parse(
                  _controllerSecondNumber.text.replaceAll(",", ""))),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent.withOpacity(0),
        title: const Text("Tính nhanh"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Tính'),
        icon: const Icon(Icons.calculate),
        onPressed: () {
          handleCalculate();
        },
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(10)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Center(
                child: Text("Tính % giữa hai số",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            const Center(
                child: Text("Công thức: (a - b) / b * 100",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal))),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: _controllerFirstNumber,
              onChanged: (value) {
                if (value.isEmpty) {
                  return;
                }
                value = formatNumber(value.replaceAll(',', ''));
                _controllerFirstNumber.value = TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                );
              },
              style: const TextStyle(fontSize: 18),
              textInputAction: TextInputAction.next,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số thứ nhất',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(fontSize: 18),
              controller: _controllerSecondNumber,
              onChanged: (value) {
                if (value.isEmpty) {
                  return;
                }
                value = formatNumber(value.replaceAll(',', ''));
                _controllerSecondNumber.value = TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                );
              },
              textInputAction: TextInputAction.done,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số thứ hai',
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<CalculatePercentageBloc, BaseState>(
              buildWhen: (previous, current) =>
                  current is CalculatePercentageBetweenTwoNumbersState,
              builder: (context, state) {
                return Text(
                  "Kết quả: ${state is CalculatePercentageBetweenTwoNumbersState ? "${convertToMoneyWithoutSymbol(state.result)}%" : "0%"}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
          ]),
        ),
      )),
    );
  }
}
