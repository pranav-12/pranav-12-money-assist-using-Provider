import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_mangement_project1/db/transactions/transaction_db.dart';
import 'package:money_mangement_project1/models/transactions/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScreenStatistic extends StatefulWidget {
  const ScreenStatistic({super.key});

  @override
  State<ScreenStatistic> createState() => _ScreenStatisticState();
}

class _ScreenStatisticState extends State<ScreenStatistic> {
  List<TransactionModel> newTransactionList =
      TransactionDB.instance.transactionNotifier.value;
  List<TransactionModel> charttransactionNotifier = [];

  int dropdownValue = 0;
  int dropdownValueforfiltersorting = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// appbar
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Statistics',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leadingWidth: 100,
        actions: [
// dropdown button for filter as today,monthly,all
          dropdownValue != 0
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      dropdownColor: Colors.black,
                      value: dropdownValueforfiltersorting,
                      borderRadius: BorderRadius.circular(5),
                      iconEnabledColor: Colors.white,
                      style: const TextStyle(),
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: const Text('All'),
                          onTap: () {
                            setState(() {
                              charttransactionNotifier = TransactionDB
                                  .instance.transactionNotifier.value;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: const Text('Today'),
                          onTap: () {
                            setState(() {
                              if (dropdownValue == 1) {
                                charttransactionNotifier = TransactionDB
                                    .instance.todayIncomeNotifier.value;
                              } else if (dropdownValue == 2) {
                                charttransactionNotifier = TransactionDB
                                    .instance.todayExpenseNotifier.value;
                              }
                            });
                          },
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: const Text('Monthly'),
                          onTap: () {
                            setState(() {
                              if (dropdownValue == 1) {
                                charttransactionNotifier = TransactionDB
                                    .instance.monthlyIncomeNotifier.value;
                              } else if (dropdownValue == 2) {
                                charttransactionNotifier = TransactionDB
                                    .instance.monthlyExpenseNotifier.value;
                              }
                            });
                          },
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropdownValueforfiltersorting = value!;
                        });
                      },
                    ),
                  ),
                )
              : const SizedBox()
        ],
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
// dropdownbutton for filter as all ,income,expense
          child: DropdownButtonHideUnderline(
              child: DropdownButtonHideUnderline(
            child: DropdownButton(
              dropdownColor: Colors.black,
              value: dropdownValue,
              borderRadius: BorderRadius.circular(5),
              iconEnabledColor: Colors.white,
              style: const TextStyle(),
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: const Text('All'),
                  onTap: () {
                    setState(() {
                      charttransactionNotifier =
                          TransactionDB.instance.transactionNotifier.value;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 1,
                  child: const Text('Income'),
                  onTap: () {
                    setState(() {
                      charttransactionNotifier =
                          TransactionDB.instance.incomeNotifier.value;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 2,
                  child: const Text('Expense'),
                  onTap: () {
                    setState(() {
                      charttransactionNotifier =
                          TransactionDB.instance.expenseNotifier.value;
                    });
                  },
                )
              ],
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
            ),
          )),
        ),
      ),
      body: dropdownValue != 0
          ? ValueListenableBuilder(
              valueListenable: TransactionDB.instance.transactionNotifier,
              builder: (context, value, child) {
// showing the list as a pie chart
                return charttransactionNotifier.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Text(
                              charttransactionNotifier ==
                                      TransactionDB
                                          .instance.incomeNotifier.value
                                  ? 'Income Statistics'
                                  : 'Expense Statistics',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: SfCircularChart(
                              enableMultiSelection: true,
                              legend: Legend(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                backgroundColor: Colors.black12,
                                isResponsive: true,
                                position: LegendPosition.right,
                                toggleSeriesVisibility: true,
                                isVisible: true,
                                overflowMode: LegendItemOverflowMode.scroll,
                              ),
                              series: <CircularSeries>[
                                PieSeries<TransactionModel, String>(
                                  explode: true,
                                  dataSource: charttransactionNotifier,
                                  xValueMapper: (TransactionModel data, _) =>
                                      data.notes,
                                  yValueMapper: (TransactionModel data, _) {
                                    //  data.amount;
                                    return data.amount;
                                  },
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
// if the income expense data is empty show the message
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_to_photos,
                              size: 50,
                              color: Colors.black12,
                            ),
                            Text('No Transaction available!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black26,
                                ))
                          ],
                        ),
                      );
              })
// show the all pie chart
          : TransactionDB.instance.transactionNotifier.value.isNotEmpty
              ? Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Text(
                        'Overall Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 130),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 0,
                                sectionsSpace: 2,
                                sections: [
                                  PieChartSectionData(
                                      titleStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      title: TransactionDB.instance
                                          .addTotalTransaction()[1]
                                          .toString(),
                                      value: TransactionDB.instance
                                          .addTotalTransaction()[1],
                                      color: Colors.greenAccent,
                                      radius: 100),
                                  PieChartSectionData(
                                      titleStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      title: TransactionDB.instance
                                          .addTotalTransaction()[2]
                                          .toString(),
                                      value: TransactionDB.instance
                                          .addTotalTransaction()[2],
                                      color: Colors.redAccent.shade100,
                                      radius: 100),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 120,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            Colors.redAccent.shade100,
                                        radius: 8,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Income',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: const [
                                      CircleAvatar(
                                        backgroundColor: Colors.greenAccent,
                                        radius: 8,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Expense',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
// if the all pie chart data is empty the message will show
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_to_photos,
                        size: 50,
                        color: Colors.black12,
                      ),
                      Text(
                        'No Transaction available!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black26,
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
