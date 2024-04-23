import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/base_bloc/base_state.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_event.dart';
import 'package:quan_ly_chi_tieu/bloc/home_bloc/home_state.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/core/utils/debug.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/main_home_page.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';
import 'package:quan_ly_chi_tieu/routes/route_path.dart';
import 'package:quan_ly_chi_tieu/ui/pages/home/home_page.dart';
import 'package:quan_ly_chi_tieu/ui/pages/home/widgets/increase_limit.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/app_button_custom_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/home_mesage.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/number_button_widget.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/tappable.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

extension HomeComponent on HomePageState {
  BoxConstraints constraints() {
    return BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > maxWidth
            ? maxWidth
            : MediaQuery.of(context).size.width);
  }

  Widget balanceShowAppbar() {
    return BlocBuilder<HomeBloc, BaseState>(
      buildWhen: (previous, current) =>
          current is GetBalanceState ||
          current is SaveSpendingLimitState ||
          current is GetSpendingLimitState ||
          current is SaveTransactionState,
      builder: (context, state) {
        String balanceAmount = context.read<HomeBloc>().balanceAmount;
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const TextFont(
                    text: "Số dư hiện tại",
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                content: TextFont(
                  text: balanceAmount.isEmpty
                      ? "0.00"
                      : "${convertToMoney(double.parse(balanceAmount))} ",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.black,
                ),
                const SizedBox(width: 5),
                AnimatedSize(
                  duration: const Duration(milliseconds: 700),
                  clipBehavior: Clip.none,
                  curve: Curves.elasticOut,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 900),
                    switchInCurve: const ElasticOutCurve(0.6),
                    switchOutCurve: const ElasticInCurve(0.6),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final inAnimation = Tween<Offset>(
                              begin: const Offset(0.0, 1),
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
                    child: TextFont(
                      key: ValueKey(balanceAmount),
                      text: balanceAmount.isEmpty
                          ? "0.00"
                          : convertToMoney(double.parse(balanceAmount)),
                      textAlign: TextAlign.left,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget amountRemainingWidget() {
    return Tappable(
        color: Colors.transparent,
        onTap: () {
          addSpendingLimitsBottomSheet();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              children: [
                HomeMessage(
                    onClose: () {},
                    show: false,
                    title: "Over budget!",
                    message:
                        "You overspent on your allowance. It is recommended to reset your allowance when your term ends to track how much you overspent."),
                HomeMessage(
                    onClose: () {},
                    show: false,
                    title: "Budget Achieved!",
                    message:
                        "Congratulations on finishing your allowance with money to spare! Reset your allowance by tapping the amount below."),
                HomeMessage(
                    onClose: () {},
                    show: false,
                    title: "Term Completed Over Budget",
                    message:
                        "Your budget term has ended but overspent. Adjust your spending habits or budget goals for the next cycle. Reset your allowance by tapping the amount below."),
                BlocBuilder<HomeBloc, BaseState>(
                  buildWhen: (previous, current) =>
                      current is GetBalanceState ||
                      current is GetSpendingLimitState ||
                      current is SaveTransactionState ||
                      current is SaveSpendingLimitState,
                  builder: (context, state) {
                    String spendingLimit =
                        context.watch<HomeBloc>().spendingLimit;
                    return spendingLimit.isNotEmpty
                        ? showSpendingLimit()
                        : showTotalExpense();
                  },
                ),
              ],
            ))
          ],
        ));
  }

  Widget showSpendingLimit() {
    return StreamBuilder<SpendingLimitData>(
      stream: database.watchSpendingLimit(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const SizedBox();
        }
        Debug.logMessage(message: "Data SpendingLimit ${snapshot.data}");
        return StreamBuilder<double?>(
          stream: database.totalSpendAfterDay(snapshot.data!.dateCreated),
          builder: (context, snapshotTotalSpent) {
            Debug.logMessage(
                message: "Data TotalSpent ${snapshotTotalSpent.data}");
            double amount =
                snapshot.data!.amount - (snapshotTotalSpent.data ?? 0);
            int moreDays = (snapshot.data!.dateCreatedUntil
                        .difference(DateTime.now())
                        .inHours /
                    24)
                .ceil();
            if (moreDays < 0) moreDays = 0;
            moreDays = moreDays.abs();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  AnimatedSize(
                    duration: const Duration(milliseconds: 700),
                    clipBehavior: Clip.none,
                    curve: Curves.elasticOut,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 900),
                      switchInCurve: const ElasticOutCurve(0.6),
                      switchOutCurve: const ElasticInCurve(0.6),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final inAnimation = Tween<Offset>(
                                begin: const Offset(0.0, 1),
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
                      child: SizedBox(
                        key: ValueKey(snapshotTotalSpent.data),
                        height: 67,
                        child: TextFont(
                          text: convertToMoney(amount < 0 ? 0 : amount),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          autoSizeText: true,
                          minFontSize: 15,
                          maxFontSize: 40,
                          maxLines: 2,
                          translate: false,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: amount < 0
                          ? TextFont(
                              key: ValueKey(amount),
                              text:
                                  "${convertToMoney(amount.abs())} chi tiêu quá mức :((",
                              textColor: Theme.of(context).colorScheme.error,
                              fontSize: 15,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            )
                          : TextFont(
                              key: ValueKey(amount),
                              text:
                                  "${convertToMoney(amount.abs() / moreDays)}/ngày cho $moreDays ngày",
                              fontSize: 17,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              textColor: Theme.of(context).colorScheme.tertiary,
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget showTotalExpense() {
    return StreamBuilder<double?>(
      stream: database.getTotalExpenseByDay(DateTime.now()),
      builder: (context, snapshot) {
        updateHeadline(
          title: convertToMoney(double.parse(
              snapshot.data == null ? "0" : snapshot.data.toString())),
          amount: double.parse(
              snapshot.data == null ? "0" : snapshot.data.toString()),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 3),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: TextFont(
                    text: "Tổng chi tiêu hôm nay",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black,
                    translate: false,
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 700),
                clipBehavior: Clip.none,
                curve: Curves.elasticOut,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 900),
                  switchInCurve: const ElasticOutCurve(0.6),
                  switchOutCurve: const ElasticInCurve(0.6),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    final inAnimation = Tween<Offset>(
                            begin: const Offset(0.0, 1),
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
                  child: SizedBox(
                    key: ValueKey(snapshot.data ?? 0.0),
                    height: 55,
                    child: TextFont(
                        text: snapshot.data == null
                            ? "0.00"
                            : "-${convertToMoney(double.parse(snapshot.data.toString()))}",
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        autoSizeText: true,
                        minFontSize: 15,
                        maxFontSize: 45,
                        maxLines: 2,
                        translate: false,
                        textColor: snapshot.data == null
                            ? Colors.black
                            : snapshot.data != null
                                ? Colors.red
                                : Colors.black),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: TextFont(
                    text: "Thêm giới hạn chi tiêu",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.grey,
                    translate: false,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget showBalance(String balanceAmount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 700),
            clipBehavior: Clip.none,
            curve: Curves.elasticOut,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 900),
              switchInCurve: const ElasticOutCurve(0.6),
              switchOutCurve: const ElasticInCurve(0.6),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final inAnimation = Tween<Offset>(
                        begin: const Offset(0.0, 1),
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
              child: SizedBox(
                key: ValueKey(balanceAmount),
                height: 67,
                child: TextFont(
                    text: balanceAmount.isEmpty
                        ? "0.00"
                        : convertToMoney(double.parse(balanceAmount)),
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    autoSizeText: true,
                    minFontSize: 15,
                    maxFontSize: 55,
                    maxLines: 2,
                    translate: false,
                    textColor: balanceAmount.isEmpty
                        ? Colors.black
                        : double.parse(balanceAmount) < 0
                            ? Colors.red
                            : Colors.black),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: TextFont(
                text: "Thêm giới hạn chi tiêu",
                fontSize: 15,
                fontWeight: FontWeight.bold,
                textColor: Colors.grey,
                translate: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget amountEnteredWidget() {
    return BlocBuilder<HomeBloc, BaseState>(
      buildWhen: (previous, current) => current is EnterValueState,
      builder: (context, state) {
        HapticFeedback.selectionClick();
        String valueEntered = context.watch<HomeBloc>().amountEntered;
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.elasticOut,
                  switchOutCurve: Curves.easeInOutCubicEmphasized,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
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
                      height: 50,
                      child: TextFont(
                        text: valueEntered == ''
                            ? ""
                            : convertToMoney(double.parse(valueEntered)),
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        autoSizeText: true,
                        minFontSize: 15,
                        maxFontSize: 45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        );
      },
    );
  }

  Widget transactionNameFieldWidget() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        TextField(
          controller: textController,
          focusNode: focusNodeTextInput,
          textAlign: TextAlign.right,
          maxLength: 60,
          scrollPadding: const EdgeInsets.all(10),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            hintText: "Tên giao dịch",
            counterText: "",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget funcTopButtonWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          child: NumberButtonWidget(
            constraints: constraints(),
            text: '',
            widthRatio: 0.5,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            addToAmount: (value) {
              Navigator.pushNamed(context, RoutePaths.transactionsHistoryPage,
                  arguments: {});
            },
            animationScale: 0.93,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 5),
                TextFont(
                  text: "Thống kê",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: NumberButtonWidget(
              constraints: constraints(),
              text: "add",
              color: const Color(0xFF329932).withOpacity(0.6),
              widthRatio: 0.5,
              addToAmount: (value) {
                if (context.read<HomeBloc>().amountEntered.isEmpty ||
                    double.parse(context.read<HomeBloc>().amountEntered) <= 0) {
                  AppPopUp.showPopup(
                      context: context,
                      isShowButtonSelect: false,
                      textCancel: "Đã hiểu",
                      childMessage: const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFont(
                          text: "Bạn chưa nhập số tiền",
                          fontSize: 16,
                        ),
                      ));
                  return;
                }
                popupEnterTransitionName(TransactionType.income);
              },
              animationScale: 0.93,
              child: const Center(
                child: TextFont(
                  text: "Thêm thu nhập",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),
              )),
        ),
      ],
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
              context.read<HomeBloc>().add(EnterValueEvent(value));
            },
          ),
          NumberButtonWidget(
            constraints: constraints(),
            text: "8",
            addToAmount: (value) {
              context.read<HomeBloc>().add(EnterValueEvent(value));
            },
          ),
          NumberButtonWidget(
            constraints: constraints(),
            text: "9",
            addToAmount: (value) {
              context.read<HomeBloc>().add(EnterValueEvent(value));
            },
          ),
          NumberButtonWidget(
            constraints: constraints(),
            text: "<",
            color: const Color(0xFFff9f0a).withOpacity(0.6),
            addToAmount: (value) {
              context.read<HomeBloc>().add(BlackSpaceEvent());
            },
            onLongPress: () {
              context.read<HomeBloc>().add(ClearAmountEnteredEvent());
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
                      context.read<HomeBloc>().add(EnterValueEvent(value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "5",
                    addToAmount: (value) {
                      context.read<HomeBloc>().add(EnterValueEvent(value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "6",
                    addToAmount: (value) {
                      context.read<HomeBloc>().add(EnterValueEvent(value));
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
                      context.read<HomeBloc>().add(EnterValueEvent(value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "2",
                    addToAmount: (value) {
                      context.read<HomeBloc>().add(EnterValueEvent(value));
                    },
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "3",
                    addToAmount: (value) {
                      context.read<HomeBloc>().add(EnterValueEvent(value));
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
                      context.read<HomeBloc>().add(EnterValueEvent(value));
                    },
                    animationScale: 0.93,
                  ),
                  NumberButtonWidget(
                    constraints: constraints(),
                    text: "000",
                    addToAmount: (value) {
                      context.read<HomeBloc>().add(EnterValueEvent(value));
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
                context.read<HomeBloc>().add(ClearAmountEnteredEvent());
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
                if (context.read<HomeBloc>().amountEntered.isEmpty ||
                    double.parse(context.read<HomeBloc>().amountEntered) <= 0) {
                  AppPopUp.showPopup(
                      context: context,
                      isShowButtonSelect: false,
                      textCancel: "Đã hiểu",
                      childMessage: const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextFont(
                          text: "Bạn chưa nhập số tiền",
                          fontSize: 16,
                        ),
                      ));
                  return;
                }
                popupEnterTransitionName(TransactionType.expense);
              },
              heightRatio: 0.5,
              color: const Color(0xFFff9f0a).withOpacity(0.6),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.check_rounded,
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

  Future<dynamic> popupEnterTransitionName(TransactionType typeOfTransaction) {
    return AppPopUp.showPopup(
      onPressedSelect: () {
        HapticFeedback.mediumImpact();

        String transitionNameEntered = context.read<HomeBloc>().transitionName;

        if (transitionNameEntered.isNotEmpty) {
          if (typeOfTransaction == TransactionType.income) {
            context.read<HomeBloc>().add(IncrementBalanceEvent());
          } else if (typeOfTransaction == TransactionType.expense) {
            context.read<HomeBloc>().add(SaveTransactionEvent());
          }
          Navigator.pop(context);
          return;
        }

        AppPopUp.showPopup(
            context: context,
            isShowButtonSelect: false,
            textCancel: "Đã hiểu",
            childMessage: const Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextFont(
                text: "Bạn chưa nhập tên giao dịch",
                fontSize: 16,
              ),
            ));
      },
      onPressedCancel: () {
        textController.text = "";
        context.read<HomeBloc>().add(QuickSelectTransactionNameEvent(""));
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
      },
      context: context,
      titleWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocListener<HomeBloc, BaseState>(
              listener: (context, state) {
                if (state is SaveTransactionState) {
                  textController.text = "";
                }
                if (state is QuickSelectTransactionNameState) {
                  textController.text = state.value;
                  textController.selection = TextSelection.fromPosition(
                      TextPosition(offset: textController.text.length));
                }
              },
              child: TextField(
                controller: textController,
                focusNode: focusNodeTextInput,
                onChanged: (value) {
                  context
                      .read<HomeBloc>()
                      .add(EnterTransactionNameEvent(textController.text));
                },
                maxLength: 60,
                scrollPadding: const EdgeInsets.all(10),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Tên giao dịch",
                  counterText: "",
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: AppButtonCustomWidget(
                      constraints: const BoxConstraints(maxWidth: 50),
                      text: "+",
                      onPressed: () {
                        popupAddCategory(typeOfTransaction);
                      }),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextFont(
                          text: "Chọn nhanh",
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      BlocBuilder<HomeBloc, BaseState>(
                        buildWhen: (previous, current) =>
                            current is GetListCategoryTransactionState,
                        builder: (context, state) {
                          List<CategoryTransactionData> listCategory =
                              context.read<HomeBloc>().listCategoryTransaction;

                          listCategory = listCategory
                              .where((x) => x.type
                                  .toLowerCase()
                                  .contains(typeOfTransaction.name))
                              .toList();
                          return SizedBox(
                            height: 150,
                            child: ListView(
                              primary: true,
                              children: <Widget>[
                                Wrap(
                                  spacing: 4.0,
                                  runSpacing: 0.0,
                                  children: List<Widget>.generate(
                                      listCategory
                                          .length, // place the length of the array here
                                      (int index) {
                                    return ActionChip(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        onPressed: () {
                                          context.read<HomeBloc>().add(
                                              QuickSelectTransactionNameEvent(
                                                  listCategory[index].name));
                                        },
                                        elevation: 6.0,
                                        shadowColor: Colors.grey[60],
                                        padding: const EdgeInsets.all(6.0),
                                        iconTheme: IconThemeData(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        label: Text(listCategory[index].name));
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> popupAddCategory(TransactionType typeOfTransaction) {
    TransactionType typeOfTransactionSelected = typeOfTransaction;
    return AppPopUp.showPopup(
      title: "Thêm danh mục",
      context: context,
      onPressedSelect: () {
        if (textAddCategoryController.text.isEmpty) {
          AppPopUp.showPopup(
              context: context,
              isShowButtonSelect: false,
              textCancel: "Đã hiểu",
              childMessage: const Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextFont(
                  text: "Bạn chưa nhập tên danh mục",
                  fontSize: 16,
                ),
              ));
          return;
        }
        context.read<HomeBloc>().add(SaveCategoryTransactionEvent(
              name: textAddCategoryController.text,
              type: typeOfTransactionSelected.name,
            ));
        textAddCategoryController.text = "";
        Navigator.pop(context);
      },
      textSelect: "Thêm",
      childMessage: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textAddCategoryController,
              maxLength: 60,
              scrollPadding: const EdgeInsets.all(10),
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Tên giao dịch",
                counterText: "",
                hintStyle: TextStyle(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text("Chọn kiểu danh mục",
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<HomeBloc, BaseState>(
              buildWhen: (previous, current) =>
                  current is SelectTypeOfCategoryState,
              builder: (context, state) {
                if (state is SelectTypeOfCategoryState) {
                  typeOfTransactionSelected = state.value;
                }
                return Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(
                            SelectTypeOfCategoryEvent(TransactionType.income));
                      },
                      child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                              border: typeOfTransactionSelected ==
                                      TransactionType.income
                                  ? Border.all(
                                      color: const Color(0xFF329932), width: 1)
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF329932).withOpacity(0.2)),
                          child: const Center(
                              child: Center(
                            child: Text(
                              "Thu nhập",
                              style: TextStyle(color: Color(0xFF329932)),
                            ),
                          ))),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        context.read<HomeBloc>().add(
                            SelectTypeOfCategoryEvent(TransactionType.expense));
                      },
                      child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            border: typeOfTransactionSelected ==
                                    TransactionType.expense
                                ? Border.all(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 1)
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .errorContainer
                                .withOpacity(0.4),
                          ),
                          child: Center(
                            child: Text(
                              "Chi tiêu",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          )),
                    )),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> addSpendingLimitsBottomSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 350),
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const IncreaseLimit());
      },
    );
  }
}
