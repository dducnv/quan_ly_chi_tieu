import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_event.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_state.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

class CalculatePercentageOfANumberView extends StatefulWidget {
  const CalculatePercentageOfANumberView({Key? key}) : super(key: key);

  @override
  State<CalculatePercentageOfANumberView> createState() =>
      _CalculatePercentageOfANumberViewState();
}

class _CalculatePercentageOfANumberViewState
    extends State<CalculatePercentageOfANumberView> {
  final _controllerPercent = TextEditingController();
  final _controllerNumber = TextEditingController();

  void handleCalculate() {
    if (_controllerPercent.text == '' || _controllerNumber.text == '') {
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
          CalculatePercentageOfANumberEvent(
              number: double.parse(_controllerNumber.text.replaceAll(",", "")),
              percent:
                  double.parse(_controllerPercent.text.replaceAll(",", ""))),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tính nhanh"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handleCalculate();
        },
        child: const Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text("Tính % của một số",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  const Center(
                      child: Text("Công thức: a * x / 100",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal))),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    //change enter to next
                    textInputAction: TextInputAction.next,
                    autofocus: true,

                    controller: _controllerPercent,
                    onChanged: (value) {
                      value = formatNumber(value.replaceAll(',', ''));
                      _controllerPercent.value = TextEditingValue(
                        text: value,
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phần trăm (%)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _controllerNumber,
                    onFieldSubmitted: (value) {
                      handleCalculate();
                    },
                    onChanged: (value) {
                      value = formatNumber(value.replaceAll(',', ''));
                      _controllerNumber.value = TextEditingValue(
                        text: value,
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Số cần tính',
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<CalculatePercentageBloc, BaseState>(
                    buildWhen: (previous, current) =>
                        current is CalculatePercentageOfANumberState,
                    builder: (context, state) {
                      return Text(
                        "Kết quả: ${state is CalculatePercentageOfANumberState ? convertToMoneyWithoutSymbol(state.result) : "0"}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
