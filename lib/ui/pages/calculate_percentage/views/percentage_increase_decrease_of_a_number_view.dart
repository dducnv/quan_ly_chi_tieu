import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_event.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_state.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

class PercentageIncreaseDecreaseOfANumberView extends StatefulWidget {
  const PercentageIncreaseDecreaseOfANumberView({Key? key}) : super(key: key);

  @override
  State<PercentageIncreaseDecreaseOfANumberView> createState() =>
      _PercentageIncreaseDecreaseOfANumberViewState();
}

class _PercentageIncreaseDecreaseOfANumberViewState
    extends State<PercentageIncreaseDecreaseOfANumberView> {
  final _controllerNumber = TextEditingController();
  final _controllerPercent = TextEditingController();

  void handleCalculate({
    required bool isIncrease,
  }) {
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
          CalculatePercentageIncreaseDecreaseOfANumber(
              number: double.parse(_controllerNumber.text.replaceAll(",", "")),
              percent:
                  double.parse(_controllerPercent.text.replaceAll(",", "")),
              isIncrease: isIncrease),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: FloatingActionButton.extended(
              label: const Text('Tính giảm'),
              onPressed: () {
                handleCalculate(
                  isIncrease: false,
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FloatingActionButton.extended(
              label: const Text('Tính tăng'),
              onPressed: () {
                handleCalculate(
                  isIncrease: true,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
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
                    child: Text("Tính % tăng và giảm của một số",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(height: 10),
                const Center(
                    child: Text("Công thức: a +|- (a * x / 100)",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal))),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(fontSize: 18),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  //change enter to next
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  controller: _controllerNumber,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      return;
                    }
                    value = formatNumber(value.replaceAll(',', ''));
                    _controllerNumber.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Số cần tính',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(fontSize: 18),
                  controller: _controllerPercent,
                  textInputAction: TextInputAction.done,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      return;
                    }
                    value = formatNumber(value.replaceAll(',', ''));
                    _controllerPercent.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                  onFieldSubmitted: (value) {
                    handleCalculate(
                      isIncrease: true,
                    );
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phần trăm (%) tăng hoặc giảm',
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<CalculatePercentageBloc, BaseState>(
                  buildWhen: (previous, current) => current
                      is CalculatePercentageIncreaseDecreaseOfANumberState,
                  builder: (context, state) {
                    return Text(
                      "Kết quả: ${state is CalculatePercentageIncreaseDecreaseOfANumberState ? convertToMoneyWithoutSymbol(state.result) : "0"}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
