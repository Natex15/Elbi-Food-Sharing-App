import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../models/expenses_model.dart';
import '../api/firebase_expenses_api.dart';

class ExpensesProvider with ChangeNotifier {
  Stream<QuerySnapshot>? _expensesStream;

  late FirebaseExpensesApi firebaseService;
  ExpensesProvider() {
    firebaseService = FirebaseExpensesApi();
    fetchExpenses();
  }

  Stream<QuerySnapshot>? get expenses => _expensesStream;

  void fetchExpenses() {
    _expensesStream = firebaseService.getAllExpenses();
    notifyListeners();
  }

  Future<void> addExpenses(Expenses item) async {
    String message = await firebaseService.addExpenses(item.toJson());
    print(message);
    notifyListeners();
  }

  Future<void> editExpenses(String id, Expenses item) async {
    String message = await firebaseService.editExpenses(id, item.toJson());
    print(message);
    notifyListeners();
  }

  Future<void> toggleStatus(String id, bool status) async {
    String message = await firebaseService.editExpenses(id, {'isPaid': status});
    print(message);
    notifyListeners();
  }

  Future<void> deleteExpenses(String id) async {
    String message = await firebaseService.deleteExpenses(id);
    print(message);
    notifyListeners();
  }
}
