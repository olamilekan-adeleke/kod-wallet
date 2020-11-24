import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/stat/model/stat_modle.dart';
import 'package:kod_wallet_app/wallet/stat/ui/pages/chart.dart';

class StatRepo {
  final CollectionReference baseStatRef =
      FirebaseFirestore.instance.collection('walletHistory');

  Future<StatModel> getUserStat({@required int month}) async {
    StatModel model;
    List<TimeSeriesSales> expensesTimeSeriesSalesList = [];
    List<TimeSeriesSales> incomeTimeSeriesSalesList = [];
    int totalIncome;
    int totalExpenses;
    String userUid = await HiveMethods().getUserUid();

    try {
      ///
      DocumentSnapshot documentSnapshot = await baseStatRef
          .doc(userUid)
          .collection('userStat')
          .doc('2020')
          .collection('$month')
          .doc('walletStat')
          .get();

      if (documentSnapshot.data() == null) {
        return null;
      }

      Map statData = documentSnapshot.data();

      totalIncome = statData['totalAmountReceived'];
      totalExpenses = statData['totalAmountSpent'];

      statData.forEach((key, value) {
        int currentDay;
        TimeSeriesSales currentIncomeTimeSeriesSales;
        TimeSeriesSales currentExpensesTimeSeriesSales;

        if (value is Map) {
          currentDay = int.parse(key);

          int currentIncomeValue = value['received'];
          int currentExpensesValue = value['spend'];

          currentIncomeTimeSeriesSales = TimeSeriesSales(
            DateTime(2020, month, currentDay),
            currentIncomeValue,
          );

          currentExpensesTimeSeriesSales = TimeSeriesSales(
            DateTime(2020, month, currentDay),
            currentExpensesValue,
          );

          incomeTimeSeriesSalesList.add(currentIncomeTimeSeriesSales);
          expensesTimeSeriesSalesList.add(currentExpensesTimeSeriesSales);
        }
      });

      model = StatModel(
        expensesTimeSeriesSalesList: expensesTimeSeriesSalesList,
        incomeTimeSeriesSalesList: incomeTimeSeriesSalesList,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
      );

      return model;

      ///
    } on SocketException {
      throw Exception('No Connection!');
    } on FormatException {
      throw Exception('Error: Format Exception!');
    } catch (e) {
      throw Exception('Error: ${e}');
    }
  }
}
