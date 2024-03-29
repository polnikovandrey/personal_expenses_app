import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final void Function(String title, double amount, DateTime date) _addNewTransaction;
  final bool _ios;

  NewTransaction(this._addNewTransaction, this._ios, {Key? key}) : super(key: key) {
    print('NewTransactionWidget()');
  }

  @override
  // ignore: no_logic_in_create_state
  State<NewTransaction> createState() {
    print('NewTransactionWidget.createState()');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  _NewTransactionState() {
    print('_NewTransactionState()');
  }


  @override
  void initState() {
    super.initState();
    print('_NewTransactionState.initState()');
  }


  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('_NewTransactionState.didUpdateWidget()');
  }


  @override
  void dispose() {
    super.dispose();
    print('_NewTransactionState.dispose()');
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null ? 'No Date Chosen!' : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    AdaptiveFlatButton(_presentDatePicker, 'Choose Date', widget._ios),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Add Transaction'),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitData() {
    var enteredTitle = _titleController.text;
    var enteredAmount = _amountController.text.isEmpty ? 0.0 : double.parse(_amountController.text);
    if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty && enteredAmount > 0 && _selectedDate != null) {
      widget._addNewTransaction(
        enteredTitle,
        enteredAmount,
        _selectedDate!,
      );
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }
}
