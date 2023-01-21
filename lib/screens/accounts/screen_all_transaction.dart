import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mangement_project1/db/transactions/transaction_db.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';
import 'package:money_mangement_project1/provider/accounts_provider/accounts_provider.dart';
import 'package:money_mangement_project1/widgets/bottomnavigationbar.dart';
import 'package:provider/provider.dart';

import '../../models/transactions/transaction_model.dart';
import '../add/updatenotes.dart';
import 'methods_for_accounts_section.dart';

ValueNotifier<List<TransactionModel>> dateRangeList = ValueNotifier([]);

class ScreenAllTransaction extends StatelessWidget {
  const ScreenAllTransaction({super.key});
  @override
  Widget build(BuildContext context) {
    print('started');
    TransactionDB.instance.refresh();
    return Scaffold(
//Appbar
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Accounts',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10),
//dropdownButton for select filter as income and expense or all
          child: DropdownButtonHideUnderline(
            child: Consumer<ScreenAccountsProvider>(
              builder: (context, value, child) => DropdownButton(
                dropdownColor: Colors.black,
                value: value.dropdownValue,
                borderRadius: BorderRadius.circular(10),
                iconEnabledColor: Colors.white,
                style: const TextStyle(),
                items: [
                  DropdownMenuItem(
                    value: 1,
                    child: const Text('All'),
                    onTap: () {
                      value.changingListIntoFoundTransactionList(
                          TransactionDB.instance.transactionNotifier.value,
                          true);
                      // setState(() {
                      //   foundtransactionNotifier =
                      //       TransactionDB.instance.transactionNotifier.value;
                      value.dropdownValueforfiltersorting = 0;
                      // });
                    },
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: const Text('Income'),
                    onTap: () {
                      value
                          .changingListIntoFoundTransactionList(
                              TransactionDB.instance.incomeNotifier.value,
                              true);
                      // setState(() {
                      //   foundtransactionNotifier =
                      //       TransactionDB.instance.incomeNotifier.value;
                     value
                          .dropdownValueforfiltersorting = 0;
                      // });
                    },
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: const Text('Expense'),
                    onTap: () {
                     value
                          .changingListIntoFoundTransactionList(
                              TransactionDB.instance.expenseNotifier.value,
                              true);
                      // setState(() {
                      //   foundtransactionNotifier =
                      //       TransactionDB.instance.expenseNotifier.value;
                      value
                          .dropdownValueforfiltersorting = 0;
                      // });
                    },
                  )
                ],
                onChanged: (value1) {
                  // setState(() {
                  //   dropdownValue = value!;
                  // });
                  value
                      .dropDownValue(value1!, true, false);
                },
              ),
            ),
          ),
        ),
        leadingWidth: 100,
        actions: [
//dropdown button for using the filter as today , monthly ,all
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonHideUnderline(
              child: Consumer<ScreenAccountsProvider>(
                builder: (context, value, child) => 
                 DropdownButton(
                  dropdownColor: Colors.black,
                  value: value
                      .dropdownValueforfiltersorting,
                  borderRadius: BorderRadius.circular(5),
                  iconEnabledColor: Colors.white,
                  style: const TextStyle(),
                  items: [
                    DropdownMenuItem(
                      value: 0,
                      child: const Text('All'),
                      onTap: () {
                        
                        if (value
                                .dropdownValue ==
                            1) {
                          value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB
                                      .instance.transactionNotifier.value,
                                  true);
                        } else if (value
                                .dropdownValue ==
                            2) {
                          value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB.instance.incomeNotifier.value,
                                  true);
                        } else {
                          value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB.instance.expenseNotifier.value,
                                  true);
                        }
                        // setState(() {
                        //   foundtransactionNotifier =
                        //       TransactionDB.instance.transactionNotifier.value;
                        // });
                      },
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: const Text('Today'),
                      onTap: () {
                        // setState(() {
                        if (value
                                .dropdownValue ==
                            1) {
                          value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB.instance.todayAllNotifier.value,
                                  true);
                        } else if (value
                                .dropdownValue ==
                            2) {
                          value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB
                                      .instance.todayIncomeNotifier.value,
                                  true);
                        } else {
                         value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB
                                      .instance.todayExpenseNotifier.value,
                                  true);
                        }
                        // });
                      },
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: const Text('Monthly'),
                      onTap: () {
                        // setState(() {
                        if (value
                                .dropdownValue ==
                            1) {
                         value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB.instance.monthlyAllNotifier.value,
                                  true);
                        } else if (value
                                .dropdownValue ==
                            2) {
                          value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB
                                      .instance.monthlyIncomeNotifier.value,
                                  true);
                        } else {
                         value
                              .changingListIntoFoundTransactionList(
                                  TransactionDB
                                      .instance.monthlyExpenseNotifier.value,
                                  true);
                        }
                        // });
                      },
                    ),
                  ],
                  onChanged: (value1) {
                    // setState(() {
                    // dropdownValueforfiltersorting = value!;
                    // });
                    value
                        .dropDownValue(value1!, false, false);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
//container for display the Balance section and income and expense
          Container(
            padding: const EdgeInsets.all(25),
            color: Theme.of(context).primaryColor,
            child: ValueListenableBuilder(
                valueListenable: TransactionDB.instance.transactionNotifier,
                builder: (BuildContext context, List<TransactionModel> newlist,
                    Widget? _) {
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: double.infinity,
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Income',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  TransactionDB.instance
                                      .addTotalTransaction()[2]
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(width: 40),
                            Column(
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  TransactionDB.instance
                                      .addTotalTransaction()[0]
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(width: 40),
                            Column(
                              children: [
                                const Text(
                                  'Expense',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  TransactionDB.instance
                                      .addTotalTransaction()[1]
                                      .toString(),
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
//container for custom date range
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<ScreenAccountsProvider>(
                  builder: (context, value, child) => 
                 TextButton(
                    onPressed: () async {
                      value
                          .dropdownValue = 1;
                      value
                          .dropdownValueforfiltersorting = 0;
                      await parseDateForDateRange();
                      // setState(() {
                      if (dateRangeList.value.isNotEmpty) {
                      value
                            .changingListIntoFoundTransactionList(
                                dateRangeList.value, true);
                      } else {
                        value
                            .changingListIntoFoundTransactionList([], true);
                      }
                      // });
                    },
                    child: const Text(
                      'Custom Date',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                const Icon(Icons.edit),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
//for showing the list as listviewBuilder
          Expanded(
            child: Consumer<ScreenAccountsProvider>(
              builder: (context, value, child) => 
               ValueListenableBuilder(
                valueListenable: TransactionDB.instance.transactionNotifier,
                builder: (context, List<TransactionModel> newList, Widget? _) {
                  return value
                          .foundtransactionNotifier
                          .isNotEmpty
                      ? MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount:
                                value
                                    .foundtransactionNotifier
                                    .length,
                            itemBuilder: (context, index) {
                              final value1 =
                                 value
                                      .foundtransactionNotifier[index];
            
                              return Slidable(
                                key: Key(value1.id!),
                                startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        onPressed: (context) {
                                          deleteDialogFunc(value1);
                                        },
                                        icon: Icons.delete,
                                      )
                                    ]),
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: ListTile(
                                    onLongPress: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => UpdateNotes(
                                              transactionModel: value1,
                                              index: index),
                                        ),
                                      );
                                    },
                                    onTap: () {
                                      detailsPopUp(value1, context);
                                    },
                                    visualDensity: VisualDensity.comfortable,
                                    leading: value1.type == CategoryType.income
                                        ? const CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            child: Icon(
                                              Icons.call_received,
                                              color: Colors.green,
                                            ))
                                        : const CircleAvatar(
                                            backgroundColor: Colors.black12,
                                            child: Icon(
                                              Icons.call_made_outlined,
                                              color: Colors.red,
                                            )),
                                    subtitle: Text(parseDate(value1.date),
                                        style:
                                            const TextStyle(color: Colors.grey)),
                                    title: Text(
                                      value1.categoryModel.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: value1.type == CategoryType.income
                                        ? Text(
                                            '+ ₹ ${value1.amount.toString()}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            '- ₹ ${value1.amount.toString()}',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
            //for : if all datas list is empty show the no datas message
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
