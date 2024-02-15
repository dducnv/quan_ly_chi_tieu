import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

class TransHisCardWidget extends StatelessWidget {
  const TransHisCardWidget(
      {Key? key, required this.dateOfTrans, this.transHisData})
      : super(key: key);
  final DateTime dateOfTrans;
  final List<TransactionsHistoryData>? transHisData;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionsHistoryData>>(
        stream: database.getTransactionWithDay(dateOfTrans),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }
            List<TransactionsHistoryData> transactionList =
                snapshot.data!.toList();
            double totalIncome = 0;
            double totalExpense = 0;
            for (var element in transactionList) {
              if (element.type == TransactionType.expense.toString()) {
                totalExpense += element.amount;
              } else {
                totalIncome += element.amount;
              }
            }
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${DateFormat.EEEE(locale).format(dateOfTrans)}, ${dateOfTrans.day}/${dateOfTrans.month}/${dateOfTrans.year}",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 35, 33, 33),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      const Color(0xFF329932).withOpacity(0.2)),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "+ ",
                                        style: TextStyle(
                                          color: Color(0xFF329932),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: convertToMoney(totalIncome),
                                        style: const TextStyle(
                                          color: Color(0xFF329932),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Theme.of(context)
                                    .colorScheme
                                    .errorContainer
                                    .withOpacity(0.4),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "-",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: convertToMoney(totalExpense),
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true, // Vô hiệu hóa cuộn
                    itemCount: transactionList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          onLongPress: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => AlertDialog(
                            //     title: const Text("Xóa giao dịch"),
                            //     content: const Text(
                            //         "Bạn có chắc chắn muốn xóa giao dịch này?"),
                            //     actions: [
                            //       TextButton(
                            //         onPressed: () {
                            //           Navigator.pop(context);
                            //         },
                            //         child: const Text("Hủy"),
                            //       ),
                            //       TextButton(
                            //         onPressed: () {
                            //           Navigator.pop(context);
                            //         },
                            //         child: const Text("Xóa"),
                            //       ),
                            //     ],
                            //   ),
                            // );
                            AppPopUp.showPopup(
                                context: context,
                                isShowButtonSelect: false,
                                textCancel: "Đã hiểu",
                                childMessage: const Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: TextFont(
                                    text:
                                        "Chức năng xoá giao dịch đang được phát triển",
                                    fontSize: 16,
                                  ),
                                ));
                          },
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: transactionList[index].type ==
                                      TransactionType.expense.toString()
                                  ? Theme.of(context)
                                      .colorScheme
                                      .errorContainer
                                      .withOpacity(0.4)
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withOpacity(0.4),
                            ),
                            child: Center(
                              child: transactionList[index].type ==
                                      TransactionType.expense.toString()
                                  ? const Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.arrow_drop_up_rounded,
                                      color: Color(0xFF329932),
                                    ),
                            ),
                          ),
                          title: Text(
                            transactionList[index].name,
                            style: TextStyle(
                              color: transactionList[index].type ==
                                      TransactionType.expense.toString()
                                  ? Colors.red
                                  : const Color(0xFF329932),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            "${transactionList[index].dateCreated.hour}:${transactionList[index].dateCreated.minute}",
                            style: TextStyle(
                              color: transactionList[index].type ==
                                      TransactionType.expense.toString()
                                  ? Colors.red
                                  : const Color(0xFF329932),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          trailing: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: transactionList[index].type ==
                                          TransactionType.expense.toString()
                                      ? "- "
                                      : "+ ",
                                  style: TextStyle(
                                    color: transactionList[index].type ==
                                            TransactionType.expense.toString()
                                        ? Colors.red
                                        : const Color(0xFF329932),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: convertToMoney(
                                      transactionList[index].amount),
                                  style: TextStyle(
                                    color: transactionList[index].type ==
                                            TransactionType.expense.toString()
                                        ? Colors.red
                                        : const Color(0xFF329932),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                  )
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
