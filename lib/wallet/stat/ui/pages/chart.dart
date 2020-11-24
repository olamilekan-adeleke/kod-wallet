import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';

class CustomBarChart extends StatefulWidget {
  final List<TimeSeriesSales> expensesTimeSeriesSalesList;
  final List<TimeSeriesSales> incomeTimeSeriesSalesList;

  CustomBarChart({@required this.expensesTimeSeriesSalesList, @required this.incomeTimeSeriesSalesList,});


  @override
  _CustomBarChartState createState() => _CustomBarChartState();

}

class _CustomBarChartState extends State<CustomBarChart> {
  StreamController _infoDetailsStream = StreamController<Map>.broadcast();

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Spending',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.totalCount,
        data: widget.expensesTimeSeriesSalesList,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Incomes',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.totalCount,
        data: widget.incomeTimeSeriesSalesList,
      )
    ];
  }

  @override
  void dispose() {
    _infoDetailsStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          selectedDay(),
          chartUi(),
          infoUi(),
        ],
      ),
    );
  }

  Widget infoUi() {
    return Container(
      child: Row(
        children: [
          colorInfo(),
          Spacer(),
          selectedDayDataInfo(),
          Spacer(),
        ],
      ),
    );
  }

  Widget selectedDayDataInfo() {
    return Container(
      child: StreamBuilder(
        stream: _infoDetailsStream.stream,
        builder: (_, snapshot) {
          if (snapshot.data != null) {
            Map data = snapshot.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.isNotEmpty ? 'Total Income: \$ ${data['Incomes']}' : 'No Day Selected!'}',
                  style: subTextStyle,
                ),
                Text(
                  '${data.isNotEmpty ? 'Total Expenses: \$ ${data['Spending']}' : 'No Day Selected!'}',
                  style: subTextStyle,
                ),
              ],
            );
          } else {
            return Text(
              'No Day Selected Yet!',
              style: subTextStyle,
            );
          }
        },
      ),
    );
  }

  Widget selectedDay() {
    return Container(
      child: StreamBuilder(
        stream: _infoDetailsStream.stream,
        builder: (_, snapshot) {
          if (snapshot.data != null) {
            Map data = snapshot.data;
            return Text(
              '${data.isNotEmpty ? 'Day ${data['day'].toString().split(' ')[0].split('-')[2]}' : 'No Day Selected!'}',
              style: subTextStyle,
            );
          } else {
            return Text(
              'No Day Selected Yet!',
              style: subTextStyle,
            );
          }
        },
      ),
    );
  }

  Widget colorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(height: 15, width: 15, color: Colors.blue.shade100),
            SizedBox(width: 10.0),
            Text('Expenses'),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(height: 15, width: 15, color: Colors.blue),
            SizedBox(width: 10.0),
            Text('Incomes'),
          ],
        ),
      ],
    );
  }

  Widget chartUi() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: double.infinity,
      child: charts.TimeSeriesChart(
        _createSampleData(),
        animationDuration: Duration(seconds: 1),
        animate: true,
        defaultRenderer: charts.BarRendererConfig<DateTime>(),
        defaultInteractions: false,
        behaviors: [charts.SelectNearest(), charts.DomainHighlighter()],
        selectionModels: [
          charts.SelectionModelConfig(
            type: charts.SelectionModelType.info,
            changedListener: (val) {
              Map infoDetails = {};
              final selectedDatum = val.selectedDatum;

              if (selectedDatum.isNotEmpty) {
                infoDetails['day'] = selectedDatum.first.datum.time;
                selectedDatum.forEach((charts.SeriesDatum datumPair) {
                  print(datumPair);
                  print(datumPair.datum.totalCount);
//                  measures[datumPair.series.displayName] = datumPair.datum.sales;
                  infoDetails[datumPair.series.displayName] =
                      datumPair.datum.totalCount;
                  infoDetails[datumPair.series.displayName] =
                      datumPair.datum.totalCount;
                  print(1);
                });
              }

              print(infoDetails);
              _infoDetailsStream.add(infoDetails);
            },
          ),
        ],
      ),
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int totalCount;

  TimeSeriesSales(this.time, this.totalCount);
}
