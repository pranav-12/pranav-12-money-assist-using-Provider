import 'package:flutter/cupertino.dart';

import '../db/categories/category_db.dart';
import '../models/categories/category_model.dart';

class AddNotesProvider with ChangeNotifier {
  CategoryType selectedCategoryType = CategoryType.income;
  bool swapNutrients = true;
  String? categoryId;
  TextEditingController dateController = TextEditingController();

  void dateControllerFunc(String text) {
    dateController.text = text;
    notifyListeners();
  }

  void changeValue(String value) {
    categoryId = value;
    notifyListeners();
  }

  void onToggle(CategoryType type) {
    selectedCategoryType = type;
    swapNutrients = !swapNutrients;
    categoryId = null;
    notifyListeners();
  }

  void addCategoryList(TextEditingController name) {
    final category = CategoryModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.text,
        type: selectedCategoryType);
    CategoryDB.instance.insertCategory(category);

    CategoryDB.instance.refreshUI();
    notifyListeners();
  }
}
