import 'package:flutter/material.dart';
import 'package:money_mangement_project1/db/categories/category_db.dart';
import 'package:money_mangement_project1/screens/settings/add_category_popup.dart';
import 'package:money_mangement_project1/screens/settings/expense_category_setting.dart';
import 'package:money_mangement_project1/screens/settings/income_category_setting.dart';

class CategoriesSettings extends StatefulWidget {
  const CategoriesSettings({super.key});

  @override
  State<CategoriesSettings> createState() => _CategoriesSettingsState();
}

class _CategoriesSettingsState extends State<CategoriesSettings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          splashColor: Colors.black,
          tooltip: 'Add',
          onPressed: () {
            showCategoryAddPop(context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          )),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Category Settings',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                indicatorColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.blueGrey,
                labelColor: Colors.black,
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Income',
                  ),
                  Tab(text: 'Expense'),
                ]),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  IncomeCategorySettings(),
                  ExpenseCategorySettings()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
