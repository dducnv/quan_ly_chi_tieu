import 'package:flutter/cupertino.dart';
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
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: textController,
                        focusNode: focusNodeTextInput,
                        onChanged: (value) {
                          searchTerm = value;
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      textController.clear();
                      searchTerm = null;
                      focusNodeTextInput.unfocus();
                    },
                    icon: const Icon(Icons.clear),
                  )
                ],
              )
            ]),
          )),
    );
  }
}
