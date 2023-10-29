import 'package:drift/drift.dart';
import 'package:quan_ly_chi_tieu/core/local/database/expense_management_db.dart';
import 'package:quan_ly_chi_tieu/resource/enum.dart';

List<CategoryTransactionCompanion> listCategory = [
  CategoryTransactionCompanion(
      name: const Value("Vay nợ"),
      type: Value(TransactionType.income.toString())),
  CategoryTransactionCompanion(
      name: const Value("Nhận lương"),
      type: Value(TransactionType.income.toString())),
  CategoryTransactionCompanion(
      name: const Value("Nhận thưởng"),
      type: Value(TransactionType.income.toString())),
  CategoryTransactionCompanion(
      name: const Value("Tiền tiêu vặt"),
      type: Value(TransactionType.income.toString())),
  CategoryTransactionCompanion(
      name: const Value("Tích luỹ"),
      type: Value(TransactionType.income.toString())),
  CategoryTransactionCompanion(
      name: const Value("Cafe"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Mua đồ gia dụng"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Du lịch"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Tiền học phí"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Đi chợ"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Đi siêu thị"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Đồ dùng cá nhân"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Đồ dùng học tập"),
      type: Value(TransactionType.expense.toString())),
  CategoryTransactionCompanion(
      name: const Value("Trả nợ"),
      type: Value(TransactionType.expense.toString())),
];
