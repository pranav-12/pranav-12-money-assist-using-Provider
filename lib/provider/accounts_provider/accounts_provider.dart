import 'package:flutter/cupertino.dart';

import '../../db/transactions/transaction_db.dart';
import '../../models/transactions/transaction_model.dart';

class ScreenAccountsProvider with ChangeNotifier {
  
  
  // final List<TransactionModel> newTransactionList =
  //     TransactionDB.instance.transactionNotifier.value;
  List<TransactionModel> foundtransactionNotifier =
      TransactionDB.instance.transactionNotifier.value;

  List<TransactionModel> charttransactionNotifier =
      TransactionDB.instance.transactionNotifier.value;

  int dropdownValue = 1;
  int dropdownValueforfiltersorting = 0;

  int dropdownValueForStatic = 0;
  int dropdownValueforfiltersortingForStatic = 0;

  void changingListIntoFoundTransactionList(
      List<TransactionModel> newList, bool foundTransaction1) {
        
    if (foundTransaction1 == true) {
      foundtransactionNotifier = newList;
      notifyListeners();
    } else {
      charttransactionNotifier = newList;
      notifyListeners();
    }
  }

  void dropDownValue(
      dropdownValue1, bool dropdownvalue1, bool dropdownForStatic) {
    if (dropdownForStatic == false) {
      if (dropdownvalue1 == true) {
        dropdownValue = dropdownValue1;
        notifyListeners();
      } else {
        dropdownValueforfiltersorting = dropdownValue1;
        notifyListeners();
      }
    } else {
      if (dropdownvalue1 == true) {
        dropdownValueForStatic = dropdownValue1;
        notifyListeners();
      } else {
        dropdownValueforfiltersortingForStatic = dropdownValue1;
        notifyListeners();
      }
    }
  }
}
