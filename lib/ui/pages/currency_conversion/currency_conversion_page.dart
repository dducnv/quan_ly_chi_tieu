import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/currency_conversion_bloc/currency_conversion_state.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';
import 'package:quan_ly_chi_tieu/ui/pages/currency_conversion/components/currency_conversion_component.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/app_button_custom_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class CurrencyConversionPage extends StatefulWidget {
  const CurrencyConversionPage({Key? key}) : super(key: key);

  @override
  CurrencyConversionPageState createState() => CurrencyConversionPageState();
}

class CurrencyConversionPageState extends State<CurrencyConversionPage> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String formattedOutput = "";
  double maxWidth = 370;
  FocusNode focusNodeTextInput = FocusNode();
  List items = [];
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/countries.json');
    final data = await json.decode(response);
    setState(() {
      items = data;
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoxConstraints constraints = BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > maxWidth
            ? maxWidth
            : MediaQuery.of(context).size.width);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              bottom: true,
              left: false,
              right: false,
              top: true,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 50,
                          width: constraints.maxWidth,
                          child: BlocBuilder<CurrencyConversionBloc, BaseState>(
                            buildWhen: (previous, current) =>
                                current is SelectFirstCurrencyState,
                            builder: (context, state) {
                              return AppButtonCustomWidget(
                                constraints: constraints,
                                text: "USD",
                                onPressed: () {
                                  showBottonSheetSlectCountry(true);
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.network(
                                        getFlagBycurrencyCode(
                                            state is SelectFirstCurrencyState
                                                ? state.currency
                                                : "USD"),
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        state is SelectFirstCurrencyState
                                            ? state.currency
                                            : "USD",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: amountEnteredWidget(),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 50,
                          width: constraints.maxWidth,
                          child: BlocBuilder<CurrencyConversionBloc, BaseState>(
                            buildWhen: (previous, current) =>
                                current is SelectSecondCurrencyState,
                            builder: (context, state) {
                              return AppButtonCustomWidget(
                                constraints: constraints,
                                text: "VND",
                                onPressed: () {
                                  showBottonSheetSlectCountry(false);
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.network(
                                        getFlagBycurrencyCode(
                                            state is SelectSecondCurrencyState
                                                ? state.currency
                                                : "VND"),
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        state is SelectSecondCurrencyState
                                            ? state.currency
                                            : "VND",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                            width: constraints.maxWidth,
                            child: showResultCurrencyConversion()),
                      )
                    ],
                  ),
                ),
                Text(
                  "Cập nhật lúc 00:00 ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                numberButtonWidgetsTopWidget(),
                numberButtonWidgetsBottomWidget(),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      Debug.logMessage(message: 'Couldn\'t check connectivity status : $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        Debug.logMessage(message: "Có kết nối mạng");
        break;
      case ConnectivityResult.mobile:
        break;
      case ConnectivityResult.ethernet:
        break;
      case ConnectivityResult.vpn:
        break;
      case ConnectivityResult.none:
        Debug.logMessage(message: "Không có kết nối mạng");
        AppPopUp.showPopup(
            context: context,
            isShowButtonSelect: false,
            textCancel: "Đã hiểu",
            childMessage: const Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextFont(
                text: "Không có kết nối mạng, vui lòng kiểm tra lại",
                fontSize: 16,
              ),
            ));
        break;
      default:
        break;
    }
  }
}

class BottomClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0.0,
      size.height - 250,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
