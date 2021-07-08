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
        walletHistory
            .doc(history.userUid)
            .collection('userHistory')
            .doc(history.uid),
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

  //TODO: implement coin part
  ///
}
