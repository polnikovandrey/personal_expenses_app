import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class TransactionList extends StatelessWidget {

  final List<Transaction> _userTransactions;

  const TransactionList(this._userTransactions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _userTransactions.map((transaction) {
        return Card(
          child: Row(
            children: [
              Container(
                child: Text(
                  '\$${transaction.amount}',
                  style: const TextStyle(color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(border: Border.all(color: Colors.purple, width: 2)),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding: const EdgeInsets.all(10),
              ),
              Column(
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat.yMMMd().format(transaction.date),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
