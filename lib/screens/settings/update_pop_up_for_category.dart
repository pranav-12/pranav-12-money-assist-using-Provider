// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';
import 'package:money_mangement_project1/widgets/bottomnavigationbar.dart';

import '../../db/categories/category_db.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
final _formKey = GlobalKey<FormState>();
Future<void> updateScreenPopUp(CategoryModel categoryModel, index) async {
  TextEditingController textEditingController = TextEditingController();

  textEditingController.text = categoryModel.name;
  selectedCategoryNotifier.value = categoryModel.type;

  showDialog(
    context: navigatorKey.currentContext!,
    builder: (ctx) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Update category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Category Name is empty';
                  }
                  return null;
                },
                controller: textEditingController,
                decoration: const InputDecoration(
                    hintText: 'Category Name', border: OutlineInputBorder()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: const [
                UpDateCateryPopUp(title: 'Income', type: CategoryType.income),
                UpDateCateryPopUp(title: 'Expense', type: CategoryType.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(navigatorKey.currentContext!).primaryColor),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final name = textEditingController.text;

                  final type = selectedCategoryNotifier.value;
                  final category1 = CategoryModel(
                    id: categoryModel.id,
                    name: name,
                    type: type,
                  );
                 
                    CategoryDB.instance.editCategory(category1);
                    CategoryDB.instance.refreshUI();
            

                  textEditingController.clear();
                  Navigator.of(navigatorKey.currentContext!).pop();
                }
              },
              child: const Text('Update'),
            ),
          )
        ],
      );
    },
  );
}

class UpDateCateryPopUp extends StatelessWidget {
  final String title;
  final CategoryType type;

  const UpDateCateryPopUp({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
              activeColor: type==CategoryType.income?Colors.green:Colors.red,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title),
      ],
    );
  }
}
