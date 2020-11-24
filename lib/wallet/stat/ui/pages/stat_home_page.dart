import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/wallet/home/ui/view/home_view.dart';
import 'package:kod_wallet_app/wallet/stat/bloc/stat_bloc.dart';
import 'package:kod_wallet_app/wallet/stat/model/stat_modle.dart';
import 'package:kod_wallet_app/wallet/stat/ui/pages/pie_chart.dart';

import 'chart.dart';

class StatHomePage extends StatefulWidget {
  @override
  _StatHomePageState createState() => _StatHomePageState();
}

class _StatHomePageState extends State<StatHomePage> {
  StreamController _dateStream = StreamController<DateTime>()
    ..add(DateTime.now());
  Size _size;

  @override
  void dispose() {
    _dateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: statAppBar(),
      body: Center(
        child: statUI(),
      ),
    );
  }

  Widget statUI() {
    return Container(
      child: ListView(
        children: [
          header(),
          chartBlocUi(),
        ],
      ),
    );
  }

  Widget chartBlocUi() {
    return BlocConsumer<StatBloc, StatState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingStatState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedStatState) {
          return chartUi(state.statModel);
        } else if (state is ErrorStatState) {
          return Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              '${state.message}',
              style: subTextStyle,
              textAlign: TextAlign.center,
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget chartUi(StatModel stat) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomBarChart(
            expensesTimeSeriesSalesList: stat.expensesTimeSeriesSalesList,
            incomeTimeSeriesSalesList: stat.incomeTimeSeriesSalesList,
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: DonutAutoLabelChart(
            incomeValue: stat.totalIncome,
            expensesValue: stat.totalExpenses,
          ),
        ),
        SizedBox(height: 20.0),
        totalText(stat.totalExpenses, stat.totalIncome),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget totalText(int expenses, int income) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Expenses For The Month: ', style: subTextStyle),
              Text(
                '\$ ${currencyFormatter(amount: expenses)}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Income For The Month: ', style: subTextStyle),
              Text(
                '\$ ${currencyFormatter(amount: income)}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.only(top: 20, bottom: 30),
      child: Column(
        children: [
          Text(
            'Your Spending For The Month',
            style: headingTextStyle = TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          monthWidget(),
        ],
      ),
    );
  }

  Widget monthWidget() {
    return StreamBuilder<DateTime>(
      stream: _dateStream.stream,
      builder: (_, snapshot) {
        if (snapshot.data != null) {
          DateTime date = snapshot.data;
          return Text(
            '${date.toString().split(' ')[0]}',
            style: subTextStyle,
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            'Loading....',
            style: subTextStyle,
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Widget statAppBar() {
    return AppBar(
      title: Text(
        'Budget Statistics',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
