import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/transactions_history_page.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';

extension TransHistoryComponents on TransactionsHistoryPageState {
  Future<void> showPopupSearchTransHis() {
    return AppPopUp.showBottomSheet(
      context: context,
      child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                TextField(
                  maxLength: 40,
                  focusNode: focusNodeTextInput,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm",
                    counterText: "",
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ]),
            ),
          )),
    );
  }
}
