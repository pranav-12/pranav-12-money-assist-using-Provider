import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';

const categoryDbName = 'incomecategory-database';
// const expensecategoryDbName = 'expensecategory-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getIncomeCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(CategoryModel categoryModel);
  Future<void> resetAllCategory();
  Future<void> editCategory(CategoryModel value);
}

class CategoryDB with ChangeNotifier implements CategoryDbFunctions {
//for singleton the object
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }
  ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);


//inserCategory for inserting values into Database
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final incomecategoryDb = await Hive.openBox<CategoryModel>(categoryDbName);
    await incomecategoryDb.put(value.id, value);
    refreshUI();
  }


//editCategory for edit the values into the database
  @override
  Future<void> editCategory(CategoryModel value) async {
    final incomecategoryDb = await Hive.openBox<CategoryModel>(categoryDbName);
    await incomecategoryDb.put(value.id, value);
    refreshUI();
  }


//getIncomeCategory for get values from Database
  @override
  Future<List<CategoryModel>> getIncomeCategories() async {
    final incomecategoryDb = await Hive.openBox<CategoryModel>(categoryDbName);
    return incomecategoryDb.values.toList();
  }


//Refresh function for refresh
  Future<void> refreshUI() async {
    final allIncomeCategories = await getIncomeCategories();
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();

    //add list from getIncomeCategories into incomeCategoryListNotifier
    Future.forEach(allIncomeCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListNotifier.value.add(category);
      } else {
        expenseCategoryListNotifier.value.add(category);
      }
    });

    incomeCategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }


//deleteCategory for delete the datas from the database
  @override
  Future<void> deleteCategory(CategoryModel categoryModel) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.delete(categoryModel.id);
    refreshUI();
  }


//for reset all categories
  @override
  Future<void> resetAllCategory() async {
    final categoryIncomeDb = await Hive.openBox<CategoryModel>(categoryDbName);
    categoryIncomeDb.clear();
    categoryIncomeDb.clear();
  }
}
