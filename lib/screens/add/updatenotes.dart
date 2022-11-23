import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_mangement_project1/db/transactions/transaction_db.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';

import 'package:money_mangement_project1/screens/settings/add_category_popup.dart';
import 'package:money_mangement_project1/widgets/bottomnavigationbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../db/categories/category_db.dart';
import '../../models/transactions/transaction_model.dart';

class UpdateNotes extends StatefulWidget {
  static const routeName = 'add-notes';
  final TransactionModel transactionModel;
  final int index;

  const UpdateNotes(
      {super.key, required this.transactionModel, required this.index});

  @override
  State<UpdateNotes> createState() => _UpdateNotesState();
}

class _UpdateNotesState extends State<UpdateNotes> {
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _categoryId;
  List<bool> togglebutton = List.generate(2, (index) => false);
  TextEditingController dateController = TextEditingController();
  final _notesTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
  CategoryType? selectedCategoryType;
  DateTime? pickedDate;
  CategoryModel? selectedCategoryModel;
  bool _toggleValue = true;

//this is for creating the bool value _toggleValue
  bool categorybool(TransactionModel transaction) {
    if (transaction.type == CategoryType.income) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    pickedDate = widget.transactionModel.date;
    dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate!);
    _toggleValue = categorybool(widget.transactionModel);
    selectedCategoryType = widget.transactionModel.categoryModel.type;
    _amountTextEditingController.text =
        widget.transactionModel.amount.toInt().toString();
    _notesTextEditingController.text = widget.transactionModel.notes;
    CategoryDB.instance.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//container for adding color for background
    return Scaffold(
      extendBody: true,

      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: selectedCategoryType == CategoryType.income
            ? const Text('Update Income')
            : const Text('Update Expense'),
      ),
//Listview
      body: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
//toggleSwitch for select the Category
                child: ToggleSwitch(
                  activeBorders: [Border.all(width: 2)],
                  initialLabelIndex: _toggleValue ? 0 : 1,
                  totalSwitches: 2,
                  onToggle: (index) {
                    setState(() {
                      if (_toggleValue == false) {
                        selectedCategoryType = CategoryType.income;
                        _toggleValue = !_toggleValue;
                        _categoryId = null;
                      } else {
                        selectedCategoryType = CategoryType.expense;
                        _toggleValue = !_toggleValue;
                        _categoryId = null;
                      }
                    });
                  },
                  activeBgColor: [Theme.of(context).primaryColor],
                  icons: const [
                    Icons.call_received,
                    Icons.call_made_rounded,
                  ],
                  iconSize: 25,
                  cornerRadius: 20,
                  activeFgColor: Colors.white,
                  inactiveFgColor: Colors.black,
                  animate: true,
                  inactiveBgColor: Colors.blueGrey,
                  labels: const ['Income', 'Expense'],
                  fontSize: 15,
                  minHeight: 40,
                  minWidth: 130,
                ),
              ),
            ),

//outer Container for holding all the dropdownButton and textformfield
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Container(
                  height: 500,

                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                  ),
//put the dates and category dropdown and textformfield
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Column(
                      children: [
//for select the  Date
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'select date';
                            }
                            return null;
                          },
                          readOnly: true,
                          controller: dateController,
                          keyboardType: TextInputType.none,
                          onTap: _showDatePicker,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_month_outlined),
                            enabledBorder: OutlineInputBorder(),
                            labelText: 'Date',
                            hintText: 'Select Date',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
//row for contains the CategoryDropdownbutton and add the Category
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
//Category Text
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Text(
                                    'Category : ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
//dropdownButton for categoryType
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      borderRadius: BorderRadius.circular(15),
                                      value: _categoryId,
                                      iconSize: 35,
                                      iconEnabledColor: Colors.black,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      dropdownColor: const Color.fromARGB(
                                          255, 130, 192, 204),
                                      hint: const Text(
                                        '<Select>',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      items: (selectedCategoryType ==
                                                  CategoryType.income
                                              ? CategoryDB()
                                                  .incomeCategoryListNotifier
                                              : CategoryDB()
                                                  .expenseCategoryListNotifier)
                                          .value
                                          .map(
                                            (e) => DropdownMenuItem(
                                              onTap: () {
                                                selectedCategoryModel = e;
                                              },
                                              value: e.id,
                                              child: Text(e.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _categoryId = value;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),

//IconButton for add Categories
                            IconButton(
                              iconSize: 35,
                              color: selectedCategoryType == CategoryType.income
                                  ? Colors.white
                                  : Colors.black,
                              onPressed: () {
                                showCategoryAddPop(context);
                              },
                              icon: const Icon(Icons.add_circle_outline_sharp),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
//textformfield for Amount
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid section';
                            }
                            return null;
                          },
                          controller: _amountTextEditingController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '₹',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            labelText: 'Amount',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
//textFormfield for notes
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Invalid section';
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          controller: _notesTextEditingController,
                          maxLength: 15,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            border: OutlineInputBorder(),
                            labelText: 'Note',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
//elevatedButton for save these forms and datas into Db
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 15,
                                backgroundColor: Colors.blueGrey),
                            onPressed: () {
                              updateTransaction();
                            },
                            child: const Text('Save'))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

/*updateNotes Methods starts*/

//for pick the date into Datecalender widget
  _showDatePicker() async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate!);
      });
    }
  }

//this function for checking validator and if its true add the datas into database
  Future<void> updateTransaction() async {
    if (_amountTextEditingController.text.isEmpty &&
        _notesTextEditingController.text.isEmpty &&
        dateController.text.isEmpty &&
        _categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: const Text(
            'Please fill the blank area',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      );
    } else {
      if (_formKey.currentState!.validate() && _categoryId != null) {
        final parsedAmount = double.tryParse(_amountTextEditingController.text);
        final model = TransactionModel(
            id: widget.transactionModel.id,
            notes: _notesTextEditingController.text,
            amount: parsedAmount!,
            categoryModel: selectedCategoryModel!,
            date:
                pickedDate == null ? widget.transactionModel.date : pickedDate!,
            type: selectedCategoryType!);
        await TransactionDB.instance.addTransaction(model);
        Navigator.of(navigatorKey.currentContext!).pop();
        TransactionDB.instance.refresh();
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: const Text(
              'Details Added SuccessFully',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        );
      }
    }
  }

//for pop up the category type
  Future<void> showCategoryAddPop(BuildContext context) async {
    final formkey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Add category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formkey,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Category name is empty';
                    } else {
                      return null;
                    }
                  },
                  textCapitalization: TextCapitalization.words,
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
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
                  if (formkey.currentState!.validate()) {
                    final type = selectedCategoryNotifier.value;
                    final category = CategoryModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        name: textEditingController.text,
                        type: type);
                    CategoryDB.instance.insertCategory(category);
                    textEditingController.clear();
                    setState(() {
                      CategoryDB.instance.refreshUI();
                    });
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
}
