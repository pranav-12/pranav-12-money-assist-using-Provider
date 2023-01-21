// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_mangement_project1/screens/accounts/screen_all_transaction.dart';

import '../../db/transactions/transaction_db.dart';
import '../../models/categories/category_model.dart';
import '../../models/transactions/transaction_model.dart';
import '../../widgets/bottomnavigationbar.dart';

//for showing the list details
detailsPopUp(TransactionModel value, context) {
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
                fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'TransactionType : ${value.type.name}',
            style: const TextStyle(
                fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Category : ${value.categoryModel.name}',
            style: const TextStyle(
                fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Notes : ${value.notes}',
            style: const TextStyle(
                fontFamily: 'Serif', fontWeight: FontWeight.bold, fontSize: 18),
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

//for configuring  the delete option to show the pop up
deleteDialogFunc(value) {
  showDialog(
    context: navigatorKey.currentContext!,
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
              ))
        ],
      );
    },
  );
}

//separate the date as parse
String parseDate(DateTime dates) {
  final date = DateFormat.yMMMd().format(dates);
  return date;
}

//for show and select  pickDateRange
Future<void> parseDateForDateRange() async {
  dateRangeList.value.clear();
  var daterange = DateTimeRange(
    start: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 6),
    end:
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );
  DateTimeRange? picked = await showDateRangePicker(
      context: navigatorKey.currentContext!,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      initialDateRange: daterange);
  if (picked != null) {
    final allTrans = await TransactionDB.instance.getTransaction();

    await Future.forEach(allTrans, (TransactionModel transaction) {
      if (transaction.date.isAfter(
            picked.start.subtract(
              const Duration(days: 1),
            ),
          ) &&
          transaction.date.isBefore(
            picked.end.add(
              const Duration(days: 1),
            ),
          )) {
        dateRangeList.value.add(transaction);
        dateRangeList.notifyListeners();
      } else {
        return;
      }
    });
  }
}
