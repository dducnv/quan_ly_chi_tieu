import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_event.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_state.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/ui/pages/currency_conversion/currency_conversion_page.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/number_button_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

extension CurrencyConversionComponent on CurrencyConversionPageState {
  BoxConstraints constraints() {
    return BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > maxWidth
            ? maxWidth
            : MediaQuery.of(context).size.width);
  }

  String getFlagBycurrencyCode(String currencyCode) {
    return "https://wise.com/web-art/assets/flags/${currencyCode.toLowerCase()}.svg";
  }

  Future<dynamic> showBottonSheetSlectCountry(
    bool isSelectFirstCurrency,
  ) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            height: 400,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SvgPicture.network(
                    getFlagBycurrencyCode(items[index]["currencyCode"]),
                    height: 30,
                    width: 30,
                  ),
                  title: Text(items[index]["countryName"]),
                  subtitle: Text(items[index]["currencyCode"]),
                  onTap: () {
                    if (isSelectFirstCurrency) {
                      context.read<CurrencyConversionBloc>().add(
                          SelectFirstCurrencyEvent(
                              currency: items[index]["currencyCode"]));
                    } else {
                      context.read<CurrencyConversionBloc>().add(
                          SelectSecondCurrencyEvent(
                              currency: items[index]["currencyCode"]));
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        });
  }

  Widget showResultCurrencyConversion() {
    return BlocBuilder<CurrencyConversionBloc, BaseState>(
      buildWhen: (previous, current) =>
          current is HandleConversionState ||
          current is SelectFirstCurrencyState,
      builder: (context, state) {
        String result = context.read<CurrencyConversionBloc>().resultRate;
        String secondCurrency =
            context.watch<CurrencyConversionBloc>().secondCurrency;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 55,
              child: TextFont(
                text: convertToMoney(result == '' ? 0 : double.parse(result),
                    currency: secondCurrency),
                fontSize: 50,
                textAlign: TextAlign.end,
                fontWeight: FontWeight.bold,
                maxLines: 1,
                autoSizeText: true,
                minFontSize: 15,
                maxFontSize: 55,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget amountEnteredWidget() {
    return BlocBuilder<CurrencyConversionBloc, BaseState>(
      buildWhen: (previous, current) =>
          current is EnterAmountState || current is HandleConversionState,
      builder: (context, state) {
        HapticFeedback.selectionClick();

        String valueEntered =
            context.watch<CurrencyConversionBloc>().enteredAmount;
        String firstCurrency =
            context.watch<CurrencyConversionBloc>().firstCurrency;

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeInOutCubicEmphasized,
              transitionBuilder: (Widget child, Animation<double> animation) {
                final inAnimation = Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0))
                    .animate(animation);
                return ClipRect(
                  clipper: BottomClipper(),
                  child: SlideTransition(
                    position: inAnimation,
                    child: child,
                  ),
                );
              },
              child: AnimatedSize(
                key: const ValueKey("amountEntered"),
                duration: const Duration(milliseconds: 700),
                clipBehavior: Clip.none,
                curve: Curves.elasticOut,
                child: SizedBox(
                  height: 55,
                  child: TextFont(
                    text: valueEntered == ''
                        ? ""
                        : convertToMoney(double.parse(valueEntered),
                            currency: firstCurrency),
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    autoSizeText: true,
                    minFontSize: 15,
                    maxFontSize: 55,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget numberButtonWidgetsTopWidget() {
    return SizedBox(
      width: constraints().maxWidth,
      child: Row(
        children: <Widget>[
          NumberButtonWidget(
            constraints: constraints(),
            text: "7",
            addToAmount: (value) {
              context
                  .read<CurrencyConversionBloc>()
                  .add(EnterAmountEvent(amount: value));
            },
          ),
          NumberButtonWidget(
            constraints: constraints(),
            text: "8",
            addToAmount: (value) {
              context
                  .read<CurrencyConversionBloc>()
                  .add(EnterAmountEvent(amount: value));
            },
          ),
          NumberButtonWidget(
            constraints: constraints(),
            text: "9",
            addToAmount: (value) {
              context
                  .read<CurrencyConversionBloc>()
                  .add(EnterAmountEvent(amount: value));
            },
          ),
          NumberButtonWidget(
            constraints: constraints(),
            text: "<",
            color: const Color(0xFFff9f0a).withOpacity(0.6),
            addToAmount: (value) {
              context.read<CurrencyConversionBloc>().add(BlackSpaceEvent());
            },
            onLongPress: () {
              context
                  .read<CurrencyConversionBloc>()
                  .add(ClearAmountEnteredEvent());
            },
            child: const Icon(Icons.backspace_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget numberButtonWidgetsBottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: constraints().maxWidth * 0.75,
              child: Row(
                children: <Widget>[
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "4",
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "5",
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "6",
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: constraints().maxWidth * 0.75,
              child: Row(
                children: <Widget>[
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "1",
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "2",
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "3",
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: constraints().maxWidth * 0.75,
              child: Row(
                children: <Widget>[
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "0",
                    widthRatio: 0.5,
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                    animationScale: 0.93,
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "000",
                    addToAmount: (value) {
                      context
                          .read<CurrencyConversionBloc>()
                          .add(EnterAmountEvent(amount: value));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: [
            NumberButtonWidget(
              constraints: constraints(),
              text: "C",
              addToAmount: (value) {
                context
                    .read<CurrencyConversionBloc>()
                    .add(ClearAmountEnteredEvent());
              },
              color: const Color(0xFFff9f0a).withOpacity(0.6),
              child: const Center(
                child: Text(
                  "C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            NumberButtonWidget(
              animationScale: 0.96,
              constraints: constraints(),
              text: ">",
              addToAmount: (value) {
                context
                    .read<CurrencyConversionBloc>()
                    .add(ReverseCurrencyEvent());
              },
              heightRatio: 0.5,
              color: const Color(0xFFff9f0a).withOpacity(0.6),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
