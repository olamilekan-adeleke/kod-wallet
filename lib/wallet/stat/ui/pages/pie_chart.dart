import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DonutAutoLabelChart extends StatelessWidget {
  final int incomeValue;
  final int expensesValue;

  DonutAutoLabelChart({
    @required this.incomeValue,
    @required this.expensesValue,
  });

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      _createSampleData(),
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 80,
        arcRendererDecorators: [charts.ArcLabelDecorator()],
      ),
    );
  }

  List<charts.Series<LinearData, int>> _createSampleData() {
    int total = incomeValue + expensesValue;
    final data = [
      new LinearData(0, incomeValue),
      new LinearData(1, expensesValue),
    ];

    return [
      new charts.Series<LinearData, int>(
          id: 'Data',
          domainFn: (LinearData _data, _) => _data.number,
          measureFn: (LinearData _data, _) => _data.totalCount,
          data: data,
          labelAccessorFn: (LinearData row, index) {
            if (index == 0) {
              return 'Income \n ${((row.totalCount / total) * 100).toStringAsFixed(2)}%';
            } else {
              return 'Expenses \n ${((row.totalCount / total) * 100).toStringAsFixed(2)}%';
            }
          })
    ];
  }
}

/// Sample linear data type.
class LinearData {
  final int number;
  final int totalCount;

  LinearData(this.number, this.totalCount);
}
