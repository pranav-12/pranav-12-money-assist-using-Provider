import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mangement_project1/db/categories/category_db.dart';
import 'package:money_mangement_project1/screens/add/updatenotes.dart';

import '../../db/transactions/transaction_db.dart';
import '../../models/categories/category_model.dart';
import '../../models/transactions/transaction_model.dart';

class ScreenHome extends StatelessWidget {
  final editNameController = TextEditingController();
  final String? nameEdit = 'User name';

  //for show the day night quotes
  final String message =
      DateTime.now().hour < 12 ? "Good morning" : "Good afternoon";
  final Image set = DateTime.now().hour < 12
      ? Image.asset('assets/sun.png')
      : Image.asset('assets/sun (2).png');

  ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUI();
    TransactionDB.instance.refresh();
    return Scaffold(
//Appbar
      appBar: AppBar(
        leadingWidth: 60,
        toolbarHeight: 60,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor, child: set),
        ),
        title: Text(
          message,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        actions: [
          Text(
            dateTime(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
//container for decorate
            Container(
              height: 80,
              width: double.infinity,
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  children: [
//show the balance of total list
                    ValueListenableBuilder(
                        valueListenable:
                            TransactionDB.instance.transactionNotifier,
                        builder: (BuildContext context,
                            List<TransactionModel> newlist, Widget? _) {
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 20, bottom: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                                color: Theme.of(context).primaryColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '₹ ${TransactionDB.instance.addTotalTransaction()[0]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: TransactionDB.instance
                                                  .addTotalTransaction()[0] <
                                              0
                                          ? Colors.red
                                          : Colors.black),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
//for transaction text
            const Padding(
              padding: EdgeInsets.only(top: 140, left: 5),
              child: Text(
                'Transactions :',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
// for show the list as listbuilder
            Padding(
              padding: const EdgeInsets.only(top: 170),
              child: Container(
                decoration: const BoxDecoration(),
                child: ValueListenableBuilder(
                  valueListenable: TransactionDB.instance.transactionNotifier,
                  builder: (BuildContext context,
                      List<TransactionModel> newList, Widget? _) {
                    return TransactionDB
                            .instance.transactionNotifier.value.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount:
                                (newList.length < 5 ? newList.length : 5),
                            itemBuilder: (context, index) {
                              final value = newList[index];
                              return Card(
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
                                  subtitle: Text(
                                    parseDate(value.date),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
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
                              );
                            },
                          )
//if transaction list is empty show the message
                        : Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Center(
                              child: Column(
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
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Home methods starts*/

// pop up the Details
  detailsPopUp(TransactionModel value, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(15),
          backgroundColor: Colors.white,
          children: [
            const Text(
              'Details :',
              style: TextStyle(
                  fontFamily: 'Serif',
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Date : ${parseDate(value.date)}',
              style: const TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'TransactionType : ${value.type.name}',
              style: const TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Category : ${value.categoryModel.name}',
              style: const TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Notes : ${value.notes}',
              style: const TextStyle(
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              'Amount : ${value.amount}',
              style: value.type == CategoryType.income
                  ? const TextStyle(
                      color: Colors.green,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)
                  : const TextStyle(
                      color: Colors.red,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    style: const ButtonStyle(),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            )
          ],
        );
      },
    );
  }

// for parse the date
  String parseDate(DateTime dates) {
    final date = DateFormat.yMMMd().format(dates);
    return date;
  }

//for parse the date for show the top right side show date
  String dateTime() {
    final dates = DateTime.now();
    final dateFormat = DateFormat.MMMd().format(dates);
    final splitedDate = dateFormat.split(' ');
    return '${splitedDate.last} - ${splitedDate.first} ';
  }

// delete function for delete the list
  deleteDialogFunc(value, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.grey.shade200,
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                TransactionDB.instance.deleteTransaction(value);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
  }
}
