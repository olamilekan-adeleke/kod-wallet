import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

class _StatHomePageState extends State<StatHomePage> with AutomaticKeepAliveClientMixin{
  Size _size;
  int month = DateTime.now().month - 1;

  void getMonth(int number) {
    int _month = month + number;
    if (_month >= 1 && _month <= 12) {
      month = month + number;
      BlocProvider.of<StatBloc>(context).add(GetStatEvent(month: month));
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
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
          monthSelector(),
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
          if (state.statModel == null) {
            return noDataUi();
          }
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

  Widget noDataUi() {
    DateTime _now = DateTime.now();
    return Container(
      height: _size.height * 0.60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            child: Image.asset(
              'asset/images/no_data.png',
              fit: BoxFit.contain,
              height: 150,
            ),
          ),
          Text(
            'Opps, No Data Was Found For The Month '
            '${DateFormat.MMMM().format(DateTime(_now.year, month, _now.day))}',
            style: subTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget chartUi(StatModel stat) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        header(),
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
    DateTime _now = DateTime.now();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.only(top: 20, bottom: 30),
      child: Text(
        'Your Spendings For ${DateFormat.MMMM().format(DateTime(_now.year, month, _now.day))}',
        style: headingTextStyle = TextStyle(
          color: Colors.grey[700],
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
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

  Widget monthSelector() {
    DateTime _now = DateTime.now();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () => getMonth(-1),
          ),
          Text(
            '${DateFormat.MMMM().format(DateTime(_now.year, month, _now.day))}',
            style: subTextStyle,
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
            onPressed: () => getMonth(1),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
