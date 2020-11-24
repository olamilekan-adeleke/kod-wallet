import 'package:flutter/material.dart';

class WalletModel {
  int walletBalance;
  int coinBalance;

  WalletModel({
    @required this.walletBalance,
    @required this.coinBalance,
  });

  Map<String, dynamic> toMap() {
    return {
      'walletBalance': this.walletBalance,
      'coinBalance': this.coinBalance,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return new WalletModel(
      walletBalance: map['walletBalance'] as int,
      coinBalance: map['coinBalance'] as int,
    );
  }
}
