import 'dart:io';

import 'package:flutter/cupertino.dart';
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
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


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState: AppLifecycleState.$state');
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _createCupertinoScaffold() : _createMaterialScaffold();
  }

  Widget _createCupertinoScaffold() {
    final mediaQueryData = MediaQuery.of(context);
    CupertinoNavigationBar cupertinoNavBar = CupertinoNavigationBar(
      middle: const Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            child: const Icon(CupertinoIcons.add),
            onPressed: () => _startAddNewTransaction(context, true),
          ),
        ],
      ),
    );
    return CupertinoPageScaffold(
      navigationBar: cupertinoNavBar,
      child: SafeArea(
        child: createPageBody(mediaQueryData, cupertinoNavBar.preferredSize.height, true),
      ),
    );
  }

  Widget _createMaterialScaffold() {
    final mediaQueryData = MediaQuery.of(context);
    final AppBar appBar = AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context, false),
        )
      ],
      title: const Text('Personal Expenses'),
    );
    return Scaffold(
      appBar: appBar,
      body: createPageBody(mediaQueryData, appBar.preferredSize.height, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context, false),
      ),
    );
  }

  Widget createPageBody(MediaQueryData mediaQueryData, double appBarPreferredHeight, bool ios) {
    double appHeightWoAppBarAndPaddingTop = _getAppHeightWoAppBarAndPaddingTop(mediaQueryData, appBarPreferredHeight);
    final landscape = mediaQueryData.orientation == Orientation.landscape;
    var transactionListContainer = SizedBox(
      height: appHeightWoAppBarAndPaddingTop * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: landscape
            ? _buildLandscapeContent(transactionListContainer, appHeightWoAppBarAndPaddingTop, ios)
            : _buildPortraitContent(transactionListContainer, appHeightWoAppBarAndPaddingTop),
      ),
    );
  }

  List<Widget> _buildPortraitContent(SizedBox transactionListContainer, double appHeightWoAppBarAndPaddingTop) => [
    _chartContainer(appHeightWoAppBarAndPaddingTop, 0.3),
    transactionListContainer,
  ];

  List<Widget> _buildLandscapeContent(SizedBox transactionListContainer, double appHeightWoAppBarAndPaddingTop, bool ios) => [
    Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.headline6,
        ),
        ios
            ? CupertinoSwitch(
          activeColor: Theme.of(context).colorScheme.primary,
          value: _showChart,
          onChanged: _setShowChart,
        )
            : Switch.adaptive(
          activeColor: Theme.of(context).colorScheme.primary,
          value: _showChart,
          onChanged: _setShowChart,
        ),
      ],
    ),
    _showChart ? _chartContainer(appHeightWoAppBarAndPaddingTop, 0.7) : transactionListContainer,
  ];

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

  void _startAddNewTransaction(BuildContext context, bool ios) {
    showModalBottomSheet(
      builder: (_) {
        return NewTransaction(_addNewTransaction, ios);
      },
      context: context,
    );
  }

  SizedBox _chartContainer(double appHeightWoAppBarAndPaddingTop, double heightRatio) => SizedBox(
    height: appHeightWoAppBarAndPaddingTop * heightRatio,
    child: Chart(_recentTransactions),
  );

  double _getAppHeightWoAppBarAndPaddingTop(MediaQueryData mediaQuery, double appBarPreferredHeight) {
    return mediaQuery.size.height - mediaQuery.padding.top - appBarPreferredHeight;
  }
}
