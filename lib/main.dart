import 'package:flutter/material.dart';

import './transaction.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
    Transaction(id: 't2', title: 'Weekly Groceries', amount: 16.53, date: DateTime.now()),
  ];

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            child: Card(
              child: Text("Chart"),
              color: Colors.blue,
              elevation: 5,
            ),
            width: double.infinity,
          ),
          Column(
            children: transactions.map((transaction) {
              return Card(
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        transaction.amount.toString(),
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
                          transaction.date.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
