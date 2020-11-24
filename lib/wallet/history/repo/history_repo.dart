import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/history/enum/filter_enum.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';

class HistoryMethods {
  final CollectionReference walletHistory =
      FirebaseFirestore.instance.collection('walletHistory');

  Future<List<TransferHistory>> getHistory({
    @required TransferHistory lastDoc,
    @required FilterEnum filterEnum,
    String keyword,
  }) async {
    List<TransferHistory> historyList = [];

    if (filterEnum == FilterEnum.All) {
      historyList = await _getAllHistory(lastDoc: lastDoc);
    } else if (filterEnum == FilterEnum.Wallet) {
      historyList = await _getWalletHistory(lastDoc: lastDoc);
    } else if (filterEnum == FilterEnum.Coin) {
      historyList = await _getCoinHistory(lastDoc: lastDoc);
    } else if (filterEnum == FilterEnum.Debit) {
      historyList = await _getDebitHistory(lastDoc: lastDoc);
    } else if (filterEnum == FilterEnum.Credit) {
      historyList = await _getCreditHistory(lastDoc: lastDoc);
    } else if (filterEnum == FilterEnum.Search && keyword != null) {
      historyList = await _getSearchHistory(lastDoc: lastDoc, keyword: keyword);
    }

    return historyList;
  }

  Future<List<TransferHistory>> _getAllHistory(
      {TransferHistory lastDoc}) async {
    String userUid = await HiveMethods().getUserUid();
    List<TransferHistory> historyList = [];

    try {
      if (lastDoc == null) {
        print('not given');
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      } else {
        print('given');
        print(lastDoc.toMap());
        print(lastDoc.timestamp.toDate());
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .orderBy('timestamp', descending: true)
            .startAfter([lastDoc.timestamp])
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      }

      ///
    } on SocketException {
      throw Exception('Error: No Internet Connection!');
    } on FormatException {
      throw Exception('Error: Format Expcetion!');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Error: ${e.message}');
    }

    return historyList;
  }

  Future<List<TransferHistory>> _getWalletHistory(
      {TransferHistory lastDoc}) async {
    String userUid = await HiveMethods().getUserUid();
    List<TransferHistory> historyList = [];

    try {
      if (lastDoc == null) {
        print('not given');
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('walletType', isEqualTo: 'wallet')
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      } else {
        print('given');
        print(lastDoc.toMap());
        print(lastDoc.timestamp.toDate());
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('walletType', isEqualTo: 'wallet')
            .orderBy('timestamp', descending: true)
            .startAfter([lastDoc.timestamp])
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      }

      ///
    } on SocketException {
      throw Exception('Error: No Internet Connection!');
    } on FormatException {
      throw Exception('Error: Format Expcetion!');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Error: ${e.message}');
    }

    return historyList;
  }

  Future<List<TransferHistory>> _getCoinHistory(
      {TransferHistory lastDoc}) async {
    String userUid = await HiveMethods().getUserUid();
    List<TransferHistory> historyList = [];

    try {
      if (lastDoc == null) {
        print('not given');
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('walletType', isEqualTo: 'coin')
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      } else {
        print('given');
        print(lastDoc.toMap());
        print(lastDoc.timestamp.toDate());
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('walletType', isEqualTo: 'coin')
            .orderBy('timestamp', descending: true)
            .startAfter([lastDoc.timestamp])
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      }

      ///
    } on SocketException {
      throw Exception('Error: No Internet Connection!');
    } on FormatException {
      throw Exception('Error: Format Expcetion!');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Error: ${e.message}');
    }

    return historyList;
  }

  Future<List<TransferHistory>> _getCreditHistory(
      {TransferHistory lastDoc}) async {
    String userUid = await HiveMethods().getUserUid();
    List<TransferHistory> historyList = [];

    try {
      if (lastDoc == null) {
        print('not given');
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('type', isEqualTo: 'Credit')
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      } else {
        print('given');
        print(lastDoc.toMap());
        print(lastDoc.timestamp.toDate());
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('type', isEqualTo: 'Credit')
            .orderBy('timestamp', descending: true)
            .startAfter([lastDoc.timestamp])
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      }

      ///
    } on SocketException {
      throw Exception('Error: No Internet Connection!');
    } on FormatException {
      throw Exception('Error: Format Expcetion!');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Error: ${e.message}');
    }

    return historyList;
  }

  Future<List<TransferHistory>> _getDebitHistory(
      {TransferHistory lastDoc}) async {
    String userUid = await HiveMethods().getUserUid();
    List<TransferHistory> historyList = [];

    try {
      if (lastDoc == null) {
        print('not given');
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('type', isEqualTo: 'Debit')
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      } else {
        print('given');
        print(lastDoc.toMap());
        print(lastDoc.timestamp.toDate());
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('type', isEqualTo: 'Debit')
            .orderBy('timestamp', descending: true)
            .startAfter([lastDoc.timestamp])
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      }

      ///
    } on SocketException {
      throw Exception('Error: No Internet Connection!');
    } on FormatException {
      throw Exception('Error: Format Expcetion!');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Error: ${e.message}');
    }

    return historyList;
  }

  Future<List<TransferHistory>> _getSearchHistory(
      {TransferHistory lastDoc, @required String keyword}) async {
    String userUid = await HiveMethods().getUserUid();
    List<TransferHistory> historyList = [];

    try {
      if (lastDoc == null) {
        print('not given');
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('searchKeys', arrayContains: keyword)
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      } else {
        print('given');
        print(lastDoc.toMap());
        print(lastDoc.timestamp.toDate());
        QuerySnapshot querySnapshot = await walletHistory
            .doc(userUid)
            .collection('userHistory')
            .where('searchKeys', arrayContains: keyword)
            .orderBy('timestamp', descending: true)
            .startAfter([lastDoc.timestamp])
            .limit(10)
            .get();

        querySnapshot.docs.forEach((doc) {
          TransferHistory _history = TransferHistory.fromMap(doc.data());
          historyList.add(_history);
        });
      }

      ///
    } on SocketException {
      throw Exception('Error: No Internet Connection!');
    } on FormatException {
      throw Exception('Error: Format Expcetion!');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Error: ${e.message}');
    }

    return historyList;
  }
}
