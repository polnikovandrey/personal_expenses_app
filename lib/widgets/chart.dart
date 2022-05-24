import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const Chart(this._recentTransactions, {Key? key}) : super(key: key);

  List<Map<String, Object>> get _groupedTransactionValues {
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
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get _maxSpending {
    return _groupedTransactionValues.fold(0.0, (previousValue, element) => previousValue + (element['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _groupedTransactionValues.map((data) {
            return Flexible(
              child: ChartBar(
                label: data['day'] as String,
                spendingAmount: data['amount'] as double,
                spendingPctOfTotal: _maxSpending == 0.0 ? 0.0 : (data['amount'] as double) / _maxSpending,
              ),
              fit: FlexFit.tight,
            );
          }).toList(),
        ),
      ),
      elevation: 6,
      margin: const EdgeInsets.all(20),
    );
  }
}
