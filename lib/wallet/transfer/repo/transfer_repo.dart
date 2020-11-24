import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/home/model/wallet_model.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';
import 'package:uuid/uuid.dart';

class TransferRepo {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('userData');

  final CollectionReference _walletCollectionRef =
      FirebaseFirestore.instance.collection('wallet');

  final CollectionReference walletHistory =
      FirebaseFirestore.instance.collection('walletHistory');

  final CollectionReference historyStat =
      FirebaseFirestore.instance.collection('walletHistory');

  Future<UserModel> getUserDetailsByAccountNumber(int accountNumber) async {
    UserModel userDetails;
    try {
      QuerySnapshot querySnapshot = await _userCollectionRef
          .where('accountNumber', isEqualTo: accountNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        /// if query list is empty we return null and break out of the function.
        return userDetails;
      }

      /// since every account number is different there can be only one account
      /// number so the query above will return an array of one item, so we'll
      /// just take the item at index 0 which is the first and only item
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

      userDetails = UserModel.fromMap(documentSnapshot.data());
    } on SocketException {
      throw Exception('No Internet Service!!');
    } on FormatException {
      throw Exception('Error: Format Exception!!');
    } catch (e, s) {
      print(s);
      throw Exception('Error: ${e.message}');
    }

    return userDetails;
  }

  Future<void> initTransfer({
    @required int accountNumber,
    @required int amount,
  }) async {
    UserModel userModel = await HiveMethods().getUserDataInModel();
    try {
      if (userModel.accountNumber == accountNumber) {
        throw Exception('Error: You can\'t send your self money. \n '
            'Input another account number');
      }

      QuerySnapshot querySnapshot = await _userCollectionRef
          .where('accountNumber', isEqualTo: accountNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Account $accountNumber Was Not Found!!');
      }

      /// since every account number is different there can be only one account
      /// number so the query above will return an array of one item, so we'll
      /// just take the item at index 0 which is the first and only item
      UserModel receiverData = UserModel.fromMap(querySnapshot.docs[0].data());

      ///make transfer
      await makeTransfer(amount: amount, receiverDetails: receiverData);
    } on SocketException {
      throw Exception('No Internet Service!!');
    } on FormatException {
      throw Exception('Error: Format Exception!!');
    } catch (e, s) {
      print(s);
      throw Exception('Error: ${e.message}');
    }
  }

  Future<void> makeTransfer({
    @required int amount,
    @required UserModel receiverDetails,
  }) async {
    String userId = await HiveMethods().getUserUid();
    UserModel userData = await HiveMethods().getUserDataInModel();
    final DocumentReference userWalletRef = _walletCollectionRef.doc(userId);
    final DocumentReference receiverWalletRef =
        _walletCollectionRef.doc(receiverDetails.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userWalletSnapshot =
            await transaction.get(userWalletRef);
        DocumentSnapshot receiverWalletSnapshot =
            await transaction.get(receiverWalletRef);
        WalletModel userWallet = WalletModel.fromMap(userWalletSnapshot.data());
        WalletModel receiverWallet =
            WalletModel.fromMap(receiverWalletSnapshot.data());
        int userWalletBalance = userWallet.walletBalance;
        int receiverWalletBalance = receiverWallet.walletBalance;
        int userUpdatedWalletBalance;
        int receiverUpdatedWalletBalance;

        if (userWalletBalance > amount) {
          userUpdatedWalletBalance = userWalletBalance - amount;
          receiverUpdatedWalletBalance = receiverWalletBalance + amount;

          transaction.update(
            userWalletRef,
            {'walletBalance': userUpdatedWalletBalance},
          );

          transaction.update(
            receiverWalletRef,
            {'walletBalance': receiverUpdatedWalletBalance},
          );

          TransferHistory userHistory = TransferHistory(
            dec: 'You Transfer  \$ $amount To ${receiverDetails.fullName}',
            amount: amount,
            type: 'Debit',
            walletType: 'wallet',
            userUid: userId,
            uid: Uuid().v1(),
            searchKeys: ['transfer', 'sent'],
            timestamp: Timestamp.now(),
          );

          TransferHistory receiverHistory = TransferHistory(
            dec: 'You Received  \$ $amount From ${userData.fullName}',
            amount: amount,
            type: 'Credit',
            walletType: 'wallet',
            userUid: receiverDetails.uid,
            uid: Uuid().v1(),
            searchKeys: ['transfer', 'received'],
            timestamp: Timestamp.now(),
          );

          transaction.set(
            walletHistory
                .doc(userHistory.userUid)
                .collection('userHistory')
                .doc(userHistory.uid),
            userHistory.toMap(),
            SetOptions(merge: true),
          );

          transaction.set(
            walletHistory
                .doc(receiverHistory.userUid)
                .collection('userHistory')
                .doc(receiverHistory.uid),
            receiverHistory.toMap(),
            SetOptions(merge: true),
          );

          transaction.set(
            historyStat
                .doc(userHistory.userUid)
                .collection('userStat')
                .doc(DateTime.now().year.toString())
                .collection(DateTime.now().month.toString())
                .doc('walletStat'),
            {
              'totalAmountReceived': FieldValue.increment(amount),
              '${DateTime.now().day}': {
                'received': FieldValue.increment(amount)
              },
            },
            SetOptions(merge: true),
          );

          transaction.set(
            historyStat
                .doc(receiverHistory.userUid)
                .collection('userStat')
                .doc(DateTime.now().year.toString())
                .collection(DateTime.now().month.toString())
                .doc('walletStat'),
            {
              'totalAmountReceived': FieldValue.increment(amount),
              '${DateTime.now().day}': {
                'received': FieldValue.increment(amount)
              },
            },
            SetOptions(merge: true),
          );
        } else {
          throw Exception('Insuffcient Balance!!');
        }
      });
    } on SocketException {
      throw Exception('No Internet Service!!');
    } on FormatException {
      throw Exception('Error: Format Exception!!');
    } catch (e, s) {
      throw Exception('${e.message}');
    }
  }
}
