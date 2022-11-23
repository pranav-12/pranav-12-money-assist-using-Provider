import 'package:hive/hive.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  final String notes;
  @HiveField(1)
  late final double amount;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final CategoryType type;
  @HiveField(4)
  final CategoryModel categoryModel;
  @HiveField(5)
  final String? id;
  TransactionModel(
      {required this.id,
      required this.notes,
      required this.amount,
      required this.categoryModel,
      required this.date,
      required this.type});
}
