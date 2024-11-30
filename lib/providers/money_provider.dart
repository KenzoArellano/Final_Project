import 'package:flutter/foundation.dart'; // For ChangeNotifier
import 'package:intl/intl.dart';

class MoneyProvider with ChangeNotifier {
  double _balance = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  final List<Map<String, dynamic>> _recentIncome = [];
  final List<Map<String, dynamic>> _recentExpenses = [];
  final Map<DateTime, List<Map<String, dynamic>>> _incomeByDate = {};
  final Map<DateTime, List<Map<String, dynamic>>> _expenseByDate = {};

  String _currency = 'USD'; // Default currency

  // Getters for balance, income, and expense
  double get balance => _balance;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;

  List<Map<String, dynamic>> get recentIncome => _recentIncome;
  List<Map<String, dynamic>> get recentExpenses => _recentExpenses;

  String get currency => _currency;

  // Set currency and notify listeners
  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  // Format currency based on the selected currency
  String formatCurrency(double amount) {
    final NumberFormat currencyFormat =
        NumberFormat.simpleCurrency(name: _currency);
    return currencyFormat.format(amount);
  }

  // Add income and update balance
  void addIncome(String name, double amount, DateTime date) {
    _totalIncome += amount;
    _balance = _totalIncome - _totalExpense;
    _recentIncome.insert(0, {"name": name, "amount": amount, "date": date});

    if (_incomeByDate.containsKey(date)) {
      _incomeByDate[date]?.add({"name": name, "amount": amount});
    } else {
      _incomeByDate[date] = [
        {"name": name, "amount": amount}
      ];
    }

    notifyListeners();
  }

  // Add expense and update balance
  void addExpense(String name, double amount, DateTime date) {
    _totalExpense += amount;
    _balance = _totalIncome - _totalExpense;
    _recentExpenses.insert(0, {"name": name, "amount": amount, "date": date});

    if (_expenseByDate.containsKey(date)) {
      _expenseByDate[date]?.add({"name": name, "amount": amount});
    } else {
      _expenseByDate[date] = [
        {"name": name, "amount": amount}
      ];
    }

    notifyListeners();
  }

  // Get income for the last seven days
  List<double> getIncomeForLastSevenDays() {
    List<double> dailyIncome = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: i));
      dailyIncome.add(_getIncomeForDay(day));
    }

    return dailyIncome;
  }

  // Get expense for the last seven days
  List<double> getExpenseForLastSevenDays() {
    List<double> dailyExpense = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: i));
      dailyExpense.add(_getExpenseForDay(day));
    }

    return dailyExpense;
  }

  // Get balance for the last seven days
  List<double> getBalanceForLastSevenDays() {
    List<double> dailyBalance = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime day = DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: i));
      double dailyIncome = _getIncomeForDay(day);
      double dailyExpense = _getExpenseForDay(day);
      dailyBalance
          .add(dailyIncome - dailyExpense); // Calculate balance for the day
    }

    return dailyBalance;
  }

  // Get total income for a specific day
  double _getIncomeForDay(DateTime date) {
    final incomeForDay = _incomeByDate[date] ?? [];
    return incomeForDay.fold(0.0, (sum, entry) => sum + entry["amount"]);
  }

  // Get total expense for a specific day
  double _getExpenseForDay(DateTime date) {
    final expenseForDay = _expenseByDate[date] ?? [];
    return expenseForDay.fold(0.0, (sum, entry) => sum + entry["amount"]);
  }

  // Clear all data (reset everything)
  void clearData() {
    _balance = 0.0;
    _totalIncome = 0.0;
    _totalExpense = 0.0;
    _recentIncome.clear();
    _recentExpenses.clear();
    _incomeByDate.clear();
    _expenseByDate.clear();
    notifyListeners();
  }
}
