import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransferHistory {
  String dec;
  int amount;
  String type;
  String walletType;
  String userUid;
  String uid;
  List searchKeys;
  Timestamp timestamp;

  TransferHistory({
    @required this.dec,
    @required this.amount,
    @required this.type,
    @required this.walletType,
    @required this.userUid,
    @required this.uid,
    @required this.searchKeys,
    @required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'dec': this.dec,
      'amount': this.amount,
      'type': this.type,
      'walletType': this.walletType,
      'userUid': this.userUid,
      'uid': this.uid,
      'searchKeys': this.searchKeys,
      'timestamp': this.timestamp,
    };
  }

  factory TransferHistory.fromMap(Map<String, dynamic> map) {
    return new TransferHistory(
      dec: map['dec'] as String,
      amount: map['amount'] as int,
      type: map['type'] as String,
      walletType: map['walletType'] as String,
      userUid: map['userUid'] as String,
      uid: map['uid'] as String,
      searchKeys: map['searchKeys'] as List,
      timestamp: map['timestamp'] as Timestamp,
    );
  }
}
