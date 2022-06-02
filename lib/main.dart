import 'package:flutter/material.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      title: 'Personal Expenses',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple, secondary: Colors.amber),
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(id: 't2', title: 'Weekly Groceries', amount: 16.53, date: DateTime.now()),
    Transaction(id: 't3', title: 'T-Shirt', amount: 20.21, date: DateTime.now()),
    Transaction(id: 't4', title: 'Cat Food', amount: 5.75, date: DateTime.now()),
    Transaction(id: 't5', title: 'Coffee', amount: 10.03, date: DateTime.now()),
    Transaction(id: 't6', title: 'Tea', amount: 8.47, date: DateTime.now()),
    Transaction(id: 't7', title: 'Milk', amount: 6.71, date: DateTime.now()),
  ];

  bool _showChart = false;

  void _setShowChart(bool showChart) {
    setState(() {
      _showChart = showChart;
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((transaction) => transaction.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(id: DateTime.now().toString(), title: title, amount: amount, date: date);
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => id == transaction.id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final landscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
      title: const Text('Personal Expenses'),
    );
    final mediaQuery = MediaQuery.of(context);
    final appHeightWoAppBarAndPaddingTop = (mediaQuery.size.height - mediaQuery.padding.top - appBar.preferredSize.height);
    SizedBox chartContainer(double heightRatio) => SizedBox(
          height: appHeightWoAppBarAndPaddingTop * heightRatio,
          child: Chart(_recentTransactions),
        );
    var transactionListContainer = SizedBox(
      height: appHeightWoAppBarAndPaddingTop * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (landscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: _setShowChart,
                  ),
                ],
              ),
            if (landscape) _showChart ? chartContainer(0.7) : transactionListContainer,
            if (!landscape) chartContainer(0.3),
            if (!landscape) transactionListContainer,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
