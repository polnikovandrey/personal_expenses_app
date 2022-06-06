import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {

  final void Function() _presentDatePicker;
  final String _text;
  final bool _ios;

  const AdaptiveFlatButton(this._presentDatePicker, this._text, this._ios, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ios
        ? CupertinoButton(
            child: Text(
              _text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _presentDatePicker,
          )
        : TextButton(
            child: Text(
              _text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _presentDatePicker,
          );
  }
}
