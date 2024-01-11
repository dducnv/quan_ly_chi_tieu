import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/core/local/global_db.dart';
import 'package:quan_ly_chi_tieu/core/utils/function.dart';
import 'package:quan_ly_chi_tieu/models/trans_chart_model.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';
import 'package:quan_ly_chi_tieu/ui/pages/analytics/widgets/trans_total_by_month.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/popup_custom.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

extension AnalyticComponent on TransTotalByMonthState {
  Future<void> showDetailTransactionPopup() {
    return AppPopUp.showBottomSheet(
      context: context,
      child: StreamBuilder<dynamic>(
        stream: database.getTotalTransactionGroupByCategoryName(
          startDate: widget.startDate,
          endDate: DateTime(widget.startDate.year, widget.startDate.month + 1,
              widget.startDate.day - 1),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("Không có giao dịch nào"));
            }
            List<TransChartModel> showingSectionsCount = [];
            List<TransChartModel> showingSectionsAmount = [];

            for (dynamic item in snapshot.data) {
              showingSectionsCount
                  .add(TransChartModel(item['name'], item['count']));
            }

            for (dynamic item in snapshot.data) {
              showingSectionsAmount
                  .add(TransChartModel(item['name'], item['total']));
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: TabBar(
                          controller: tabController,
                          tabs: const [
                            Tab(
                                text: "Biểu đồ theo số lượng",
                                icon: Icon(Icons.pie_chart_outline)),
                            Tab(
                                text: "Biểu đồ theo tổng tiền",
                                icon: Icon(Icons.bar_chart_outlined)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: SfCircularChart(
                                title: ChartTitle(
                                  text: "Biểu đồ thống kê số tổng số giao dịch",
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                legend: const Legend(
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                series: [
                                  PieSeries<TransChartModel, String>(
                                    dataSource: showingSectionsCount,
                                    xValueMapper: (TransChartModel data, _) =>
                                        data.name,
                                    yValueMapper: (TransChartModel data, _) =>
                                        data.value,
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: SfCartesianChart(
                                  zoomPanBehavior: zoomPan,
                                  enableMultiSelection: true,
                                  plotAreaBorderWidth: 0,
                                  title: ChartTitle(
                                    text:
                                        "Biểu đồ thống kê tổng tiền giao dịch",
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    isVisible: false,
                                    numberFormat: NumberFormat.simpleCurrency(
                                        locale: 'vi_VN'),
                                    labelStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  primaryXAxis: CategoryAxis(
                                    majorGridLines:
                                        const MajorGridLines(width: 0),
                                  ),
                                  series: <ChartSeries<TransChartModel,
                                      String>>[
                                    ColumnSeries<TransChartModel, String>(
                                      dataSource: showingSectionsAmount,
                                      xValueMapper: (TransChartModel data, _) =>
                                          data.name,
                                      yValueMapper: (TransChartModel data, _) =>
                                          data.value,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.4)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: snapshot.data[index]['type'] ==
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
                                    child: snapshot.data[index]['type'] ==
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
                                  snapshot.data[index]['name'],
                                  style: TextStyle(
                                    color: snapshot.data[index]['type'] ==
                                            TransactionType.expense.toString()
                                        ? Colors.red
                                        : const Color(0xFF329932),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  "${snapshot.data[index]['count']} giao dịch",
                                  style: TextStyle(
                                    color: snapshot.data[index]['type'] ==
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
                                        text: snapshot.data[index]['type'] ==
                                                TransactionType.expense
                                                    .toString()
                                            ? "- "
                                            : "+ ",
                                        style: TextStyle(
                                          color: snapshot.data[index]['type'] ==
                                                  TransactionType.expense
                                                      .toString()
                                              ? Colors.red
                                              : const Color(0xFF329932),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: convertToMoney(
                                            snapshot.data[index]['total']),
                                        style: TextStyle(
                                          color: snapshot.data[index]['type'] ==
                                                  TransactionType.expense
                                                      .toString()
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
