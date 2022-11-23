import 'package:flutter/material.dart';
import 'package:money_mangement_project1/db/categories/category_db.dart';
import 'package:money_mangement_project1/screens/settings/update_pop_up_for_category.dart';

import '../../models/categories/category_model.dart';

class IncomeCategorySettings extends StatefulWidget {
  const IncomeCategorySettings({super.key});

  @override
  State<IncomeCategorySettings> createState() => _IncomeCategorySettingsState();
}

class _IncomeCategorySettingsState extends State<IncomeCategorySettings> {
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: CategoryDB.instance.incomeCategoryListNotifier,
      builder: (BuildContext context, List<CategoryModel> newlist, Widget? _) {
// show the income list
        return ListView.separated(
            itemBuilder: (context, index1) {
              final category = newlist[index1];
              return Card(
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  onLongPress: () {
                   setState(() {
                      updateScreenPopUp(category,index1);
                   });
                  },
                  trailing: IconButton(
                    onPressed: () =>
                        CategoryDB.instance.deleteCategory(category),
                    icon: const Icon(Icons.delete),
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.black12,
                    child: Icon(
                      Icons.call_received,
                      color: Colors.green,
                    ),
                  ),
                  visualDensity: VisualDensity.standard,
                  onTap: () {},
                  title: Text(
                    category.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  tileColor: Colors.black12,
                  style: ListTileStyle.list,
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
            itemCount: newlist.length);
      },
    );
  }
}
