// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';

import '../../db/categories/category_db.dart';


ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);


// for pop up the adding the category
Future<void> showCategoryAddPop(context) async {
  TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Category Name is empty';
                  } else {
                    return null;
                  }
                },
                controller: textEditingController,
                decoration: const InputDecoration(
                    hintText: 'Category Name', border: OutlineInputBorder(),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: const [
                AddCateryPopUp(title: 'Income', type: CategoryType.income),
                AddCateryPopUp(title: 'Expense', type: CategoryType.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final name = textEditingController.text;

                  final type = selectedCategoryNotifier.value;
                  final category = CategoryModel(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      name: name,
                      type: type);
                  CategoryDB.instance.insertCategory(category);
                  textEditingController.clear();
                  CategoryDB.instance.refreshUI();
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Add'),
            ),
          )
        ],
      );
    },
  );
}

class AddCateryPopUp extends StatelessWidget {
  final String title;
  final CategoryType type;

  const AddCateryPopUp({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
              activeColor:
                  type == CategoryType.income ? Colors.green : Colors.red,
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
