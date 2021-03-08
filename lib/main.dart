import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/transaction_list.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const appTitle = 'Despesas Pessoais';
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _transactionsOfWeek {
    return _transactions
        .where((trans) =>
            trans.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      this._transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      this._transactions.removeWhere((trans) => trans.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  Widget _getIconButton({IconData icon, Function onPressed}) {
    return Platform.isIOS
        ? GestureDetector(
            child: Icon(icon),
            onTap: onPressed,
          )
        : IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconChart = Platform.isIOS
        ? CupertinoIcons.chart_bar_alt_fill
        : Icons.stacked_bar_chart;
    final iconList = Platform.isIOS ? CupertinoIcons.square_list : Icons.list;

    final appBarActions = [
      if (isLandscape)
        _getIconButton(
          icon: _showChart ? iconList : iconChart,
          onPressed: () => setState(() {
            _showChart = !_showChart;
          }),
        ),
      _getIconButton(
        icon: Platform.isIOS ? CupertinoIcons.add : Icons.add,
        onPressed: () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(appTitle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: appBarActions,
            ),
          )
        : AppBar(
            title: Text(appTitle),
            actions: appBarActions,
          );

    final availableHeight = mediaQuery.size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.75 : 0.25),
                child: Chart(transactionsOfWeek: _transactionsOfWeek),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1.0 : 0.75),
                child: TransactionList(
                  transactions: _transactions,
                  onDelete: _deleteTransaction,
                ),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
