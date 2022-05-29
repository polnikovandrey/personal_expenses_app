import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar({required this.label, required this.spendingAmount, required this.spendingPctOfTotal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (builderContext, constraints) {
      final constraintsMaxHeight = constraints.maxHeight;
      return Column(
        children: [
          SizedBox(
            height: constraintsMaxHeight * 0.15,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(
            height: constraintsMaxHeight * 0.05,
          ),
          SizedBox(
            height: constraintsMaxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  heightFactor: spendingPctOfTotal,
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraintsMaxHeight * 0.05,
          ),
          SizedBox(
            height: constraintsMaxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
