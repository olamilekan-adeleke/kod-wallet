import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';

import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/home/model/wallet_model.dart';
import 'package:kod_wallet_app/wallet/home/repo/fund_wallet.dart';
import 'package:kod_wallet_app/wallet/home/repo/wallet_methods.dart';
import 'package:kod_wallet_app/wallet/home/ui/view/home_view.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Box<Map> userDataBox;
  StreamController loadedStream = StreamController<bool>.broadcast();
  Stream walletBalanceStream;

  Future<void> getBox() async {
    userDataBox = await HiveMethods().getUserLocalDb();
    loadedStream.add(true);
  }

  Future<void> fundWallet({@required int amount}) async {
    Map userData = await HiveMethods().getUserData();

    TransferHistory history = TransferHistory(
      dec: 'You Receied \$$amount From Paystack',
      amount: amount,
      type: 'Credit',
      walletType: 'wallet',
      userUid: userData['uid'],
      uid: Uuid().v1(),
      searchKeys: ['paystack'],
      timestamp: Timestamp.now(),
    );

    await FundWallet().chargeCard(
      price: amount,
      context: context,
      userEmail: userData['email'],
      history: history,
    );
  }

  void showPopUp() {
    int _amount = 0;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.only(left: 10.0),
            decoration: formTextFieldDecoration,
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Amount',
                hintText: 'Enter Amount',
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              onSubmitted: (val) {
                _amount = int.parse(val);
              },
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Fund', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    print(_amount);
                    await fundWallet(amount: _amount);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  color: Colors.grey[400],
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    walletBalanceStream = WalletMethods().walletStream();
    getBox();

    super.initState();
  }

  @override
  void dispose() {
    loadedStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<bool>(
          stream: loadedStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return ListView(
                children: [
                  header(),
                  ValueListenableBuilder(
                    valueListenable: userDataBox.listenable(),
                    builder: (BuildContext context, Box box, Widget child) {
                      return balanceStream();
                    },
                  ),
                  SizedBox(height: 20),
                  message(),
                  SizedBox(height: 10),
                  walletImage(),
                  SizedBox(height: 15),
                  button(),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget button() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: customButton(
        context: context,
        title: 'Fund Wallet',
        function: () {
          showPopUp();
        },
      ),
    );
  }

  Widget walletImage() {
    return Container(
      child: Image.asset(
        'asset/images/undraw_wallet.png',
        fit: BoxFit.contain,
        height: 150,
      ),
    );
  }

  Widget message() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Text(
            'Welcome To Kod mobile wallet – A secure mobile wallet solution that gives '
            'users control over the paying experience and the ability to '
            'track spending. \n Get Started By Funding Your Wallet.',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget balanceStream() {
    //TODO: fix firestore stream saving the last user balance data when user //
    //TODO: log out and log in with another account
    return StreamBuilder(
      stream: walletBalanceStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              balanceWidget(title: 'Wallet', amount: null),
              SizedBox(height: 5),
              balanceWidget(title: 'Coin', amount: null),
            ],
          );
        } else {
          DocumentSnapshot doc = snapshot.data;
          WalletModel wallet = WalletModel.fromMap(doc.data());
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              balanceWidget(title: 'Wallet', amount: wallet.walletBalance),
              SizedBox(height: 5),
              balanceWidget(title: 'Coin', amount: wallet.coinBalance),
            ],
          );
        }
      },
    );
  }

  Widget header() {
    return userDetailWidget(userDataBox: userDataBox);
  }

  @override
  bool get wantKeepAlive => true;
}
