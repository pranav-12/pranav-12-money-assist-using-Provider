import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_mangement_project1/db/categories/category_db.dart';
import 'package:money_mangement_project1/models/transactions/transaction_model.dart';

import '../../models/categories/category_model.dart';

const transactionDbName = 'Income-transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel transactionModel);
  Future<List<TransactionModel>> getTransaction();
  Future<void> deleteTransaction(TransactionModel transactionModel);
  Future<void> resetAll();
}

class TransactionDB with ChangeNotifier implements TransactionDbFunctions {
//for singleton
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }


//for adding values into Database as category type
  @override
  Future<void> addTransaction(TransactionModel transactionModel) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.put(transactionModel.id, transactionModel);
  }


//for get the values from the database
  @override
  Future<List<TransactionModel>> getTransaction() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionDB.values.toList();
  }


//for delete the values from the databases
  @override
  Future<void> deleteTransaction(TransactionModel transactionModel) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.delete(transactionModel.id);
    refresh();
  }


// for edit the notes
  Future<void> editTransaction(TransactionModel transModel, index) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.put(transModel.id, transModel);
    refresh();
  }


//for resetAll : clear full transactionDB
  @override
  Future<void> resetAll() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);

    transactionDB.clear();

    CategoryDB.instance.resetAllCategory();
  }


//for refresh the Ui

  ValueNotifier<List<TransactionModel>> transactionNotifier = ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> incomeNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseNotifier = ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> todayIncomeNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> todayAllNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> todayExpenseNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> monthlyAllNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthlyIncomeNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthlyExpenseNotifier =
      ValueNotifier([]);

  Future<void> refresh() async {
    //get separated database values
    final allTransaction = await getTransaction();
    transactionNotifier.value.clear();
    allTransaction.sort((first, second) => second.date.compareTo(first.date));
    transactionNotifier.value.addAll(allTransaction);

    // for set values into chart list to show the chart
    incomeNotifier.value.clear();
       expenseNotifier.value.clear();

    await Future.forEach(allTransaction, (TransactionModel transaction) {
      if (transaction.type == CategoryType.income) {
        incomeNotifier.value.add(transaction);
      } else {
        expenseNotifier.value.add(transaction);
      }
    });

    transactionNotifier.notifyListeners();

    incomeNotifier.notifyListeners();
    expenseNotifier.notifyListeners();

//today sort
    todayIncomeNotifier.value.clear();
    todayExpenseNotifier.value.clear();
    todayAllNotifier.value.clear();

    //set values into todayIncome
    await Future.forEach(allTransaction, (TransactionModel transaction) {
      if (transaction.date ==
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        todayIncomeNotifier.value.add(transaction);
        todayAllNotifier.value.add(transaction);
      }
      
    });

    todayExpenseNotifier.notifyListeners();
    todayIncomeNotifier.notifyListeners();
    todayAllNotifier.notifyListeners();

//monthly sort
    monthlyAllNotifier.value.clear();
    monthlyIncomeNotifier.value.clear();
    monthlyExpenseNotifier.value.clear();

    //set values into monthlyIncome
    await Future.forEach(allTransaction, (TransactionModel transaction) {
      if (transaction.date.month == DateTime.now().month) {
        monthlyIncomeNotifier.value.add(transaction);
        monthlyAllNotifier.value.add(transaction);
      }
      
    });

    monthlyAllNotifier.notifyListeners();
    monthlyIncomeNotifier.notifyListeners();
    monthlyExpenseNotifier.notifyListeners();
  }

//for separate add income total and expense total
  List totalAllNotifier = [];

  List addTotalTransaction() {
    double? newExpenseAmount = 0;
    double? newincomeAmount = 0;
    double? total = 0;
    for (var i = 0; i < monthlyAllNotifier.value.length; i++) {
      var values = monthlyAllNotifier.value[i];

      if (values.type == CategoryType.income) {
        newincomeAmount = newincomeAmount! + values.amount;
      } else {
        newExpenseAmount = newExpenseAmount! + values.amount;
      }
      total = newincomeAmount! - newExpenseAmount!;
    }
    totalAllNotifier.add(newincomeAmount);
    totalAllNotifier.add(newExpenseAmount);

    return [total!, newExpenseAmount!, newincomeAmount!];
  }
}
