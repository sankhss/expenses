import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactionsOfWeek;

  Chart({this.transactionsOfWeek});

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double sum = 0.0;

      for (var trans in transactionsOfWeek) {
        if (trans.date.day == weekDay.day &&
            trans.date.month == weekDay.month &&
            trans.date.year == weekDay.year) {
          sum += trans.value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': sum,
      };
    }).reversed.toList();
  }

  double get _weekTotal {
    return groupedTransactions.fold(0.0, (sum, trans) => sum += trans['value']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((gt) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: gt['day'],
                value: gt['value'],
                percentage: _weekTotal == 0.0 ? 0.0 : (gt['value'] as double) / _weekTotal,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
