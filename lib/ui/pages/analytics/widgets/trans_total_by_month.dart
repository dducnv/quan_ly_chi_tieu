import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/components/trans_total_components.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/app_button_custom_widget.dart';

class TransTotalByMonth extends StatefulWidget {
  final DateTime startDate;
  const TransTotalByMonth({Key? key, required this.startDate})
      : super(key: key);

  @override
  State<TransTotalByMonth> createState() => TransTotalByMonthState();
}

class TransTotalByMonthState extends State<TransTotalByMonth>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: database.getTotalIncomeAndExpenseByMonth(
          startDate: widget.startDate,
          endDate: DateTime(widget.startDate.year, widget.startDate.month + 1,
              widget.startDate.day - 1),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Không có giao dịch nào"));
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tổng giao dịch tháng ${widget.startDate.month}/ ${widget.startDate.year}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                                        text: convertToMoney(snapshot.data[
                                                'TransactionType.income'] ??
                                            0),
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
                                        text: convertToMoney(snapshot.data[
                                                'TransactionType.expense'] ??
                                            0),
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
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: AppButtonCustomWidget(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.6),
                        constraints: const BoxConstraints(),
                        text: "Xem chi tiết",
                        child: const Center(
                          child: Text(
                            "Xem chi tiết",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDetailTransactionPopup();
                        }),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
