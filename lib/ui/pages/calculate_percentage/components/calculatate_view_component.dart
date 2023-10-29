import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_event.dart';
import 'package:quan_ly_chi_tieu/bloc/calculate_percentage_bloc/calculate_percentage_state.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/data/home_data.dart';
import 'package:quan_ly_chi_tieu/ui/pages/calculate_percentage/views/calcutate_view_page.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/app_button_custom_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

extension CaculateViewConponent on CalcutateViewPageState {
  Widget switchWidgetWithCondition(String conditionSwitchWidget) {
    switch (conditionSwitchWidget) {
      case calculatePercentageOfANumber:
        return calculatePercentageOfANumberWidget();
      case calculatePercentageBetweenTwoNumbers:
        return calculatePercentageBetweenTwoNumbersWidget();
      case calculatePercentageIncreaseDecreaseOfANumber:
        return calculatePercentageIncreaseDecreaseOfANumberWidget();
      default:
        return calculatePercentageOfANumberWidget();
    }
  }

  // Tính % của một số
  Widget calculatePercentageOfANumberWidget() {
    double number = 0;
    double percent = 0;
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            const Center(
                child: Text("Tính % của một số",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
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
              onChanged: (value) {
                if (value.isEmpty) {
                  percent = 0;
                  return;
                }
                percent = double.parse(value);
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
              onChanged: (value) {
                if (value.isEmpty) {
                  number = 0;
                  return;
                }
                number = double.parse(value);
              },
              onFieldSubmitted: (value) {
                if (number == 0 || percent == 0 || value.isEmpty) {
                  number = 0;
                  return;
                }
                context.read<CalculatePercentageBloc>().add(
                      CalculatePercentageOfANumberEvent(
                          number: number, percent: percent),
                    );
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số cần tính',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 50,
              child: AppButtonCustomWidget(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  text: "Tính",
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  onPressed: () {
                    if (percent == 0 || number == 0) {
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
                              number: number, percent: percent),
                        );
                  },
                  child: const Center(
                    child: Text(
                      "Tính",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
            ),
            const SizedBox(height: 20),
            BlocBuilder<CalculatePercentageBloc, BaseState>(
              buildWhen: (previous, current) =>
                  current is CalculatePercentageOfANumberState,
              builder: (context, state) {
                return Text(
                  "Kết quả: ${state is CalculatePercentageOfANumberState ? state.result : "0"}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ));
  }

  // Tính % giữa hai số
  Widget calculatePercentageBetweenTwoNumbersWidget() {
    double firstNumber = 0;
    double secondNumber = 0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        const Center(
            child: Text("Tính % giữa hai số",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        const Center(
            child: Text("Công thức: (a - b) / b * 100",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal))),
        const SizedBox(height: 20),
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          //change enter to next
          onChanged: (value) {
            if (value.isEmpty) {
              firstNumber = 0;
              return;
            }
            firstNumber = double.parse(value);
          },
          textInputAction: TextInputAction.next,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Số thứ nhất',
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          onChanged: (value) {
            if (value.isEmpty) {
              secondNumber = 0;
              return;
            }
            secondNumber = double.parse(value);
          },
          textInputAction: TextInputAction.done,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Số thứ hai',
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 50,
          child: AppButtonCustomWidget(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
              text: "Tính",
              constraints: const BoxConstraints(minWidth: double.infinity),
              onPressed: () {
                if (firstNumber == 0 || secondNumber == 0) {
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
                          firstNumber: firstNumber, secondNumber: secondNumber),
                    );
              },
              child: const Center(
                child: Text(
                  "Tính",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )),
        ),
        const SizedBox(height: 20),
        BlocBuilder<CalculatePercentageBloc, BaseState>(
          buildWhen: (previous, current) =>
              current is CalculatePercentageBetweenTwoNumbersState,
          builder: (context, state) {
            return Text(
              "Kết quả: ${state is CalculatePercentageBetweenTwoNumbersState ? state.result + "%" : "0%"}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          },
        ),
      ]),
    );
  }

  // Tính % tăng và giảm của một số
  Widget calculatePercentageIncreaseDecreaseOfANumberWidget() {
    double number = 0;
    double percent = 0;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          const Center(
              child: Text("Tính % tăng và giảm của một số",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          const Center(
              child: Text("Công thức: a +|- (a * x / 100)",
                  style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.normal))),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            //change enter to next
            textInputAction: TextInputAction.next,
            autofocus: true,
            onChanged: (value) {
              if (value.isEmpty) {
                number = 0;
                return;
              }
              number = double.parse(value);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Số cần tính',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              if (value.isEmpty) {
                percent = 0;
                return;
              }
              percent = double.parse(value);
            },
            onFieldSubmitted: (value) {
              context.read<CalculatePercentageBloc>().add(
                    CalculatePercentageIncreaseDecreaseOfANumber(
                        number: number, percent: percent, isIncrease: true),
                  );
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phần trăm (%) tăng hoặc giảm',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  child: AppButtonCustomWidget(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.6),
                      text: "Tính tăng",
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      onPressed: () {
                        if (percent == 0 || number == 0) {
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
                                  number: number,
                                  percent: percent,
                                  isIncrease: true),
                            );
                      },
                      child: const Center(
                        child: Text(
                          "Tính tăng",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  child: AppButtonCustomWidget(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.6),
                      text: "Tính giảm",
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      onPressed: () {
                        if (percent == 0 || number == 0) {
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
                                  number: number,
                                  percent: percent,
                                  isIncrease: false),
                            );
                      },
                      child: const Center(
                        child: Text(
                          "Tính giảm",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      )),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<CalculatePercentageBloc, BaseState>(
            buildWhen: (previous, current) =>
                current is CalculatePercentageIncreaseDecreaseOfANumberState,
            builder: (context, state) {
              return Text(
                "Kết quả: ${state is CalculatePercentageIncreaseDecreaseOfANumberState ? state.result : "0"}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),
        ],
      ),
    );
  }
}
