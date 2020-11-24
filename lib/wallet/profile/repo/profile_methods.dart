import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';

class ProfileMethods {
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('userData');

  Future<void> updateUserData({@required UserModel userData}) async {
    try {
      await userRef.doc(userData.uid).set(userData.toMap(), SetOptions(merge: true));
      await HiveMethods().saveUserDataToLocalDb(userData: userData.toMap());
    } on SocketException {
      throw Exception('No InterNet Connectio!');
    } catch (e) {
      throw Exception('Error: ${e.message}');
    }
  }
}
