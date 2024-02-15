import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_event.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/tappable.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

class IncreaseLimit extends StatefulWidget {
  const IncreaseLimit({Key? key}) : super(key: key);

  @override
  _IncreaseLimitState createState() => _IncreaseLimitState();
}

DateTime dayInAMonth() {
  return DateTime(
      DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
}

class _IncreaseLimitState extends State<IncreaseLimit> {
  double selectedAmount = 0;
  DateTime selectedUntilDate = dayInAMonth();
  DateTime selectedOnDate = DateTime.now();
  Future<void> _selectUntilDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedUntilDate,
        firstDate: DateTime.now().add(const Duration(days: 0)),
        lastDate: DateTime.now().add(const Duration(days: 500)));
    if (picked != null && picked != selectedUntilDate) {
      setState(() {
        selectedUntilDate = picked;
      });
    }
  }

  Future<void> _selectOnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedOnDate,
        firstDate: DateTime.now().add(const Duration(days: -30)),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedOnDate) {
      setState(() {
        selectedOnDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String getBalance = context.read<HomeBloc>().balanceAmount;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 5),
          child: TextFont(
            text: "Đặt giới hạn chi tiêu",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextFont(
            text:
                "Đặt giới hạn chi tiêu để nhắc nhở bạn khi chi tiêu vượt quá giới hạn.",
            fontSize: 15,
            maxLines: 8,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          runSpacing: 2,
          children: [
            const TextFont(text: "Giới hạn"),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: IntrinsicWidth(
                  child: TextFormField(
                    autofocus: true,
                    onChanged: (value) {
                      if (getDecimalSeparator() == ",") {
                        value = value.replaceAll(",", ".");
                      } else if (getDecimalSeparator() == ".") {
                        value = value.replaceAll(",", "");
                      }
                      setState(() {
                        selectedAmount = double.tryParse(value) ?? 0;
                      });
                    },
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 14,
                      ),
                      hintText: "0",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const TextFont(text: "Từ ngày"),
            const SizedBox(width: 5),
            Tappable(
              borderRadius: 15,
              color: Colors.transparent,
              onTap: () {
                _selectOnDate(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                ),
                child: TextFont(
                  text: DateFormat('d / M , yyyy').format(selectedOnDate),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextFont(text: "Đến ngày"),
                Tappable(
                  borderRadius: 15,
                  color: Colors.transparent,
                  onTap: () {
                    _selectUntilDate(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                    ),
                    child: TextFont(
                      text: DateFormat('d / M, yyyy').format(selectedUntilDate),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: selectedAmount <= 0 ? 0.3 : 1,
              child: OutlinedButton(
                  onPressed: () async {
                    if (selectedAmount <= 0) {
                    } else if (double.parse(getBalance) < selectedAmount) {
                      AppPopUp.showPopup(
                          context: context,
                          message:
                              "Số dư của bạn không đủ bạn chỉ còn $getBalance ",
                          isShowButtonCancel: false,
                          onPressedSelect: () {
                            Navigator.pop(context);
                          });
                    } else {
                      context.read<HomeBloc>().add(SaveSpendingLimitEvent(
                          amount: selectedAmount,
                          startDate: selectedOnDate,
                          endDate: selectedUntilDate));

                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.check)),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

bool containsMoreThanOneDecimalSeparator(String input) {
  List<String> charList = input.split(getDecimalSeparator());
  return charList.length > 2;
}
