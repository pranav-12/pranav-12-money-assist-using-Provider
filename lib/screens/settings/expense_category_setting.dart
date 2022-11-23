import 'package:flutter/material.dart';
import 'package:money_mangement_project1/db/categories/category_db.dart';
import 'package:money_mangement_project1/screens/settings/update_pop_up_for_category.dart';

import '../../models/categories/category_model.dart';

class ExpenseCategorySettings extends StatefulWidget {
  const ExpenseCategorySettings({super.key});

  @override
  State<ExpenseCategorySettings> createState() =>
      _ExpenseCategorySettingsState();
}


class _ExpenseCategorySettingsState extends State<ExpenseCategorySettings> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDB().expenseCategoryListNotifier,
      builder: (BuildContext context, List<CategoryModel> newList, Widget? _) {
// for display the list
        return ListView.separated(
            itemBuilder: (context, index1) {
              final category = newList[index1];
              return Card(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  onLongPress: () {
                    setState(() {
                      updateScreenPopUp(category, index1);
                    });
                  },
                  trailing: IconButton(
                    onPressed: () =>
                        CategoryDB.instance.deleteCategory(category),
                    icon: const Icon(Icons.delete),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.black12,
                    child: Icon(
                      Icons.call_made,
                      color: Colors.red.shade500,
                    ),
                  ),
                  visualDensity: VisualDensity.standard,
                  onTap: () {},
                  title: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  tileColor: Colors.black12,
                  style: ListTileStyle.list,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
            itemCount: newList.length);
      },
    );
  }
}
