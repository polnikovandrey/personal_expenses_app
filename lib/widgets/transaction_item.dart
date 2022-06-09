import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction _transaction;
  final MediaQueryData _mediaQuery;
  final void Function(String id) _deleteTransaction;

  const TransactionItem(this._transaction, this._mediaQuery, this._deleteTransaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '\$${_transaction.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          radius: 30,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(_transaction.date),
          style: const TextStyle(color: Colors.grey),
        ),
        title: Text(
          _transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: _mediaQuery.size.width > 460
            ? TextButton.icon(
                onPressed: () => _deleteTransaction(_transaction.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                label: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                ),
              )
            : IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => _deleteTransaction(_transaction.id),
              ),
      ),
    );
  }
}
