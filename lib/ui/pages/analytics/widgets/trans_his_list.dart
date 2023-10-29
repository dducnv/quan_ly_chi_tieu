import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/widgets/trans_his_card_widget.dart';

class TransHisList extends StatelessWidget {
  const TransHisList(
      {required this.startDate, Key? key, required this.scrollController})
      : super(key: key);
  final DateTime startDate;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DateTime?>>(
        stream: database.getUniqueDatesTransactionsHistory(
          start: startDate,
          end: DateTime(startDate.year, startDate.month + 1, startDate.day - 1),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Không có giao dịch nào"));
            }
            List<Widget> transactionsWidgets = [];
            DateTime previousDate = DateTime(1900);
            for (DateTime? dateNullable in snapshot.data!.reversed) {
              DateTime date = dateNullable ?? DateTime.now();
              if (previousDate.day == date.day &&
                  previousDate.month == date.month &&
                  previousDate.year == date.year) {
                continue;
              }
              // return SliverToBoxAdapter(
              //   child: GhostTransactions(i: random.nextInt(100)),
              // );
              previousDate = date;
              transactionsWidgets.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TransHisCardWidget(
                    dateOfTrans: date,
                  ),
                ),
              );
            }
            return ListView(
              controller: scrollController,
              shrinkWrap: true,
              children: transactionsWidgets,
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

getUniqueDate(List<dynamic> list) {
  DateTime previousDate = DateTime(1900);

  for (DateTime? dateNullable in list.reversed) {
    DateTime date = dateNullable ?? DateTime.now();
    if (previousDate.day == date.day &&
        previousDate.month == date.month &&
        previousDate.year == date.year) {
      continue;
    }
    previousDate = date;
    return date;
  }
}
