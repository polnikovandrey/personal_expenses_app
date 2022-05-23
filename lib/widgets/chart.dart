import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const Chart(this._recentTransactions, {Key? key}) : super(key: key);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < _recentTransactions.length; i++) {
        var transaction = _recentTransactions[i];
        var transactionDate = transaction.date;
        if (transactionDate.day == weekDay.day && transactionDate.month == weekDay.month && transactionDate.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }
      return {'day': DateFormat.E(weekDay), 'amount': totalSum};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [],
      ),
      elevation: 6,
      margin: const EdgeInsets.all(20),
    );
  }
}
