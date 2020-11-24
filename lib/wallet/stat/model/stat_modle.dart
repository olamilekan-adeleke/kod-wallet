import 'package:flutter/material.dart';
import 'package:kod_wallet_app/wallet/stat/ui/pages/chart.dart';

class StatModel {
  List<TimeSeriesSales> expensesTimeSeriesSalesList;
  List<TimeSeriesSales> incomeTimeSeriesSalesList;
  int totalIncome;
  int totalExpenses;

  StatModel({
    @required this.expensesTimeSeriesSalesList,
    @required this.incomeTimeSeriesSalesList,
    @required this.totalIncome,
    @required this.totalExpenses,
  });

  Map<String, dynamic> toMap() {
    return {
      'expensesTimeSeriesSalesList': this.expensesTimeSeriesSalesList,
      'incomeTimeSeriesSalesList': this.incomeTimeSeriesSalesList,
      'totalIncome': this.totalIncome,
      'totalExpenses': this.totalExpenses,
    };
  }

  factory StatModel.fromMap(Map<String, dynamic> map) {
    return new StatModel(
      expensesTimeSeriesSalesList:
          map['expensesTimeSeriesSalesList'] as List<TimeSeriesSales>,
      incomeTimeSeriesSalesList:
          map['incomeTimeSeriesSalesList'] as List<TimeSeriesSales>,
      totalIncome: map['totalIncome'] as int,
      totalExpenses: map['totalExpenses'] as int,
    );
  }
}
