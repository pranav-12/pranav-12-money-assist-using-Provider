import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mangement_project1/db/transactions/transaction_db.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';

import '../../models/transactions/transaction_model.dart';
import '../add/updatenotes.dart';
import 'methods_for_accounts_section.dart';

class ScreenAllTransaction extends StatefulWidget {
  const ScreenAllTransaction({super.key});

  @override
  State<ScreenAllTransaction> createState() => _ScreenAllTransactionState();
}

ValueNotifier<List<TransactionModel>> dateRangeList = ValueNotifier([]);

class _ScreenAllTransactionState extends State<ScreenAllTransaction> {
  List<TransactionModel> newTransactionList =
      TransactionDB.instance.transactionNotifier.value;
  List<TransactionModel> foundtransactionNotifier = [];

  int dropdownValue = 1;
  int dropdownValueforfiltersorting = 0;

  @override
  void initState() {
    foundtransactionNotifier = newTransactionList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            child: DropdownButton(
              dropdownColor: Colors.black,
              value: dropdownValue,
              borderRadius: BorderRadius.circular(10),
              iconEnabledColor: Colors.white,
              style: const TextStyle(),
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: const Text('All'),
                  onTap: () {
                    setState(() {
                      foundtransactionNotifier =
                          TransactionDB.instance.transactionNotifier.value;
                      dropdownValueforfiltersorting = 0;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 2,
                  child: const Text('Income'),
                  onTap: () {
                    setState(() {
                      foundtransactionNotifier =
                          TransactionDB.instance.incomeNotifier.value;
                      dropdownValueforfiltersorting = 0;
                    });
                  },
                ),
                DropdownMenuItem(
                  value: 3,
                  child: const Text('Expense'),
                  onTap: () {
                    setState(() {
                      foundtransactionNotifier =
                          TransactionDB.instance.expenseNotifier.value;
                      dropdownValueforfiltersorting = 0;
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
          ),
        ),
        leadingWidth: 100,
        actions: [
//dropdown button for using the filter as today , monthly ,all
          Padding(
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
                     foundtransactionNotifier=   TransactionDB.instance.transactionNotifier.value;
                      });
                    },
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: const Text('Today'),
                    onTap: () {
                      setState(() {
                        if (dropdownValue == 1) {
                          foundtransactionNotifier =
                              TransactionDB.instance.todayAllNotifier.value;
                        } else if (dropdownValue == 2) {
                          foundtransactionNotifier =
                              TransactionDB.instance.todayIncomeNotifier.value;
                        } else {
                          foundtransactionNotifier =
                              TransactionDB.instance.todayExpenseNotifier.value;
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
                          foundtransactionNotifier =
                              TransactionDB.instance.monthlyAllNotifier.value;
                        } else if (dropdownValue == 2) {
                          foundtransactionNotifier = TransactionDB
                              .instance.monthlyIncomeNotifier.value;
                        } else {
                          foundtransactionNotifier = TransactionDB
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
                        height: MediaQuery.of(context).size.height * 0.1,
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
                TextButton(
                  onPressed: () async {
                    dropdownValue = 1;
                    dropdownValueforfiltersorting = 0;
                    await parseDateForDateRange();
                    setState(() {
                      if (dateRangeList.value.isNotEmpty) {
                        foundtransactionNotifier = dateRangeList.value;
                      } else {
                        return;
                      }
                    });
                  },
                  child: const Text(
                    'Custom Date',
                    style: TextStyle(color: Colors.white, fontSize: 15),
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
            child: ValueListenableBuilder(
              valueListenable: TransactionDB.instance.transactionNotifier,
              builder: (context, List<TransactionModel> newList, Widget? _) {
                return foundtransactionNotifier.isNotEmpty
                    ? MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          itemCount: foundtransactionNotifier.length,
                          itemBuilder: (context, index) {
                            final value = foundtransactionNotifier[index];

                            return Slidable(
                              key: Key(value.id!),
                              startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      onPressed: (context) {
                                        deleteDialogFunc(value);
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
                                          transactionModel: value,
                                            index: index),
                                      ),
                                    );
                                  },
                                  onTap: () {
                                    detailsPopUp(value, context);
                                  },
                                  visualDensity: VisualDensity.comfortable,
                                  leading: value.type == CategoryType.income
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
                                  subtitle: Text(parseDate(value.date),
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  title: Text(
                                    value.categoryModel.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: value.type == CategoryType.income
                                      ? Text(
                                          '+ ₹ ${value.amount.toString()}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          '- ₹ ${value.amount.toString()}',
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
        ],
      ),
    );
  }











  
}
