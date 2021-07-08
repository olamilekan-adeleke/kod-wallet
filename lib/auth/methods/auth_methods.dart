import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/model/login_model.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/home/model/wallet_model.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollectionRef =
      FirebaseFirestore.instance.collection('userData');
  final CollectionReference walletCollectionRef =
      FirebaseFirestore.instance.collection('wallet');

  LoginUserModel userFromFirebase(User user) {
    return user != null ? LoginUserModel(uid: user.uid) : null;
  }

  Stream<LoginUserModel> get userStream {
    /// emit a stream of user current state(e.g emit an event when the user
    /// log out so the UI can be notify and update as needed or emit a event when
    /// a user log in so the UI can also be updated

    return auth.authStateChanges().map(userFromFirebase);
  }

  Future<dynamic> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user;
      print(user.toString());
      await HiveMethods().saveUserDataToLocalDb(userData: {'uid': user.uid});

      await getUserDetails(uid: user.uid);

      return userFromFirebase(user);
    } on SocketException {
      debugPrint('No Internet Connection!');
      throw Exception('Error: No Internet Connection!');
    } catch (e, s) {
      print(e);
      print(e.message);
      print(s);
      throw Exception('Error: ${e.message}');
    }
  }

  Future registerUserWithEmailAndPassword({
    @required String email,
    @required String password,
    @required String fullName,
    @required DateTime dateOfBirth,
    @required int phoneNumber,
    @required int accountNumber,
  }) async {
    try {
      await checkPhoneNumber(phoneNumber: phoneNumber).then((exist) async {
        /// check if phone number is already taken.
        ///
        // TODO: Implement Check For Account Number Also
        if (exist) {
          throw Exception('Phone Number Already Exist');
        } else {
          UserCredential result = await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          User user = result.user;
          await HiveMethods()
              .saveUserDataToLocalDb(userData: {'uid': user.uid});

          UserModel userData = UserModel(
            address: null,
            uid: user.uid,
            email: email,
            fullName: fullName,
            phoneNumber: phoneNumber,
            profilePicUrl: null,
            dateOfBirth: dateOfBirth.toString().split(' ')[0],
            accountNumber: accountNumber,
            timestamp: Timestamp.now(),
          );

          await writeUserDataToDataBase(userData: userData);
          await HiveMethods().saveUserDataToLocalDb(userData: userData.toMap());
        }
      });

      // return userFromFirebase(user);
    } catch (e, s) {
      debugPrint(e);
      debugPrint(s.toString());
      throw Exception('Erro: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      await HiveMethods().clearBox();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Erro: $e');
    }
  }

  Future<void> resetEmail({@required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception('Erro: $e');
    }
  }

  Future<bool> checkPhoneNumber({@required int phoneNumber}) async {
    bool phoneNumberExist = false;
    await userCollectionRef
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.length > 1) {
        phoneNumberExist = true;
      }
    });

    return phoneNumberExist;
  }

  Future<void> writeUserDataToDataBase({@required UserModel userData}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference userRef = userCollectionRef.doc(userData.uid);
    DocumentReference walletRef = walletCollectionRef.doc(userData.uid);
    WalletModel walletData = WalletModel(walletBalance: 0, coinBalance: 0);

    batch.set(
      userRef,
      userData.toMap(),
    );

    batch.set(
      walletRef,
      walletData.toMap(),
    );

    await batch.commit();
  }

  Future<UserModel> getUserDetails({@required String uid}) async {
    UserModel user;

    try {
      DocumentSnapshot document = await userCollectionRef.doc(uid).get();
      user = UserModel.fromMap(document.data());
      await HiveMethods().saveUserDataToLocalDb(userData: user.toMap());
    } on SocketException {
      throw Exception('No Internet Connection!');
    } catch (e, s) {
      print(e);
      print(s);
      throw Exception('Error: $e');
    }

    return user;
  }
}
