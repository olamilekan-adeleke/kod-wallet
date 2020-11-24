import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/home/model/wallet_model.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';

class WalletMethods {
  WriteBatch writeBatch = FirebaseFirestore.instance.batch();

  final CollectionReference walletRef =
      FirebaseFirestore.instance.collection('wallet');

  final CollectionReference walletHistory =
      FirebaseFirestore.instance.collection('walletHistory');

  final CollectionReference historyStat =
      FirebaseFirestore.instance.collection('walletHistory');

  Stream walletStream() async* {
    String userUid = await HiveMethods().getUserUid();
    yield* walletRef.doc(userUid).snapshots();
  }

  Future<WalletModel> getWalletBalance({@required String uid}) async {
    WalletModel walletDetails;

    try {
      DocumentSnapshot snapshot = await walletRef.doc(uid).get();
      walletDetails = WalletModel.fromMap(snapshot.data());
    } on FormatException {
      throw Exception('Error: A Format Exception.');
    } on SocketException {
      throw Exception('Error: No Internet Connection!');
    } catch (e, s) {
      debugPrint(e);
      debugPrint(s.toString());
      throw Exception('Error: ${e.message}');
    }

    return walletDetails;
  }

  Future updateWallet({
    @required int amount,
    @required TransferHistory history,
  }) async {
    try {
      writeBatch.set(
        walletHistory.doc(history.userUid).collection('userHistory').doc(history.uid),
        history.toMap(),
        SetOptions(merge: true),
      );

      writeBatch.set(
        historyStat
            .doc(history.userUid)
            .collection('userStat')
            .doc(DateTime.now().year.toString())
            .collection(DateTime.now().month.toString())
            .doc('walletStat'),
        {
          'totalAmountReceived': FieldValue.increment(amount),
          '${DateTime.now().day}': {'received': FieldValue.increment(amount)},
        },
        SetOptions(merge: true),
      );

      writeBatch.set(
        walletRef.doc(history.userUid),
        {'walletBalance': FieldValue.increment(amount)},
        SetOptions(merge: true),
      );

      await writeBatch.commit();
    } on SocketException {
      throw Exception('Error: No Internet  Connection!');
    } catch (e) {
      print(e);
      throw Exception('Error: ${e.message}');
    }
  }

  ///
}

//class DummyDataGenerator {
//  final List spendOption = [
//    'Food',
//    'Transport',
//    'Travel',
//    'Health Care',
//    'Market Food Item',
//    'Clothing',
//    'School Fee',
//    'House Rent',
//  ];
//
//  final List spendingType = ['Debit', 'Credit'];
//
//  final List sender = ['Own Company', 'Ola Lekan', 'Emoji'];
//
//  Future<void> getData() async {
//    Random random = Random();
//    String walletType = 'coin';
//    String userUid = await HiveMethods().getUserUid();
//    int day = 0;
//
//    for (var i = 0; i < 20; i++) {
//      int randomAmount = random.nextInt(1000);
//      spendOption.shuffle();
//      sender.shuffle();
//      String currentSpendOption = spendOption[0];
//      String currentSpendType;
//      String currentSender = sender[0];
//
//      if (i % 2 == 0) {
//        print('f');
//        day++;
//      }
//
//      if (i % 4 == 0) {
//        currentSpendType = 'Credit';
//      } else {
//        currentSpendType = 'Debit';
//      }
//
//      if (currentSpendType == 'Credit') {
//        List keys = currentSender.split(' ').toList();
//
//        TransferHistory history = TransferHistory(
//          walletType: walletType,
//          dec: 'You Received ${randomAmount * 3} From $currentSender',
//          amount: (randomAmount * 3),
//          type: currentSpendType,
//          userUid: userUid,
//          timestamp: Timestamp.fromDate(
//            DateTime(
//              2020,
//              11,
//              day,
//              random.nextInt(22),
//              random.nextInt(59),
//            ),
//          ),
//          uid: Uuid().v1(),
//          searchKeys: keys,
//        );
//
//        await saveTrans(
//          userUid: userUid,
//          historyData: history,
//          transUid: history.uid,
//          day: day.toString(),
//          amountReceived: randomAmount * 3,
//          amountSpent: 0,
//        );
//      } else {
//        List keys = currentSpendOption.split(' ').toList();
//
//        TransferHistory history = TransferHistory(
//          walletType: walletType,
//          uid: Uuid().v1(),
//          dec: 'You Spent $randomAmount On $currentSpendOption',
//          amount: randomAmount,
//          type: currentSpendType,
//          userUid: userUid,
//          timestamp: Timestamp.fromDate(
//            DateTime(
//              2020,
//              11,
//              day,
//              random.nextInt(22),
//              random.nextInt(59),
//            ),
//          ),
//          searchKeys: keys,
//        );
//
//        await saveTrans(
//          userUid: userUid,
//          historyData: history,
//          transUid: history.uid,
//          day: day.toString(),
//          amountReceived: 0,
//          amountSpent: randomAmount,
//        );
//      }
//
//      print(i);
//      print(day);
//      print(currentSpendType);
//    }
//  }
//
//  Future<void> saveTrans({
//    @required String userUid,
//    @required TransferHistory historyData,
//    @required String transUid,
//    @required String day,
//    @required int amountReceived,
//    @required int amountSpent,
//  }) async {
//    final CollectionReference walletHistory = FirebaseFirestore.instance
//        .collection('walletHistory')
//        .doc(userUid)
//        .collection('userHistory');
//    final CollectionReference historyStat = FirebaseFirestore.instance
//        .collection('walletHistory')
//        .doc(userUid)
//        .collection('userStat');
//
//    final CollectionReference walletRef =
//        FirebaseFirestore.instance.collection('wallet');
//
//    WriteBatch writeBatch = FirebaseFirestore.instance.batch();
//
//    /// {'spent': digit, 'received': digit}
//
//    writeBatch.set(
//      walletHistory.doc(transUid),
//      historyData.toMap(),
//      SetOptions(merge: true),
//    );
//
//    writeBatch.set(
//      historyStat
//          .doc(DateTime.now().year.toString())
//          .collection(DateTime.now().month.toString())
//          .doc('coinStat'), //TODO:
//      {
//        'totalAmountReceived': FieldValue.increment(amountReceived),
//        'totalAmountSpent': FieldValue.increment(amountSpent),
//        '$day': {
//          'spend': FieldValue.increment(amountSpent),
//          'received': FieldValue.increment(amountReceived)
//        },
//      },
//      SetOptions(merge: true),
//    );
//
//    if (amountReceived == 0) {
//      writeBatch.set(
//        walletRef.doc(userUid),
//        {
//          'coinBalance': FieldValue.increment(-amountSpent),
//        },
//        SetOptions(merge: true),
//      );
//    } else {
//      writeBatch.set(
//        walletRef.doc(userUid),
//        {
//          'coinBalance': FieldValue.increment(amountReceived),
//        },
//        SetOptions(merge: true),
//      );
//    }
//
//    await writeBatch.commit();
//  }
//}
