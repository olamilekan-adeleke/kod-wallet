import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';

class HiveMethods {
  Future<Box<Map>> getOpenBox({@required String boxName}) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    } else {
      return Hive.box(boxName);
    }
  }

  Future<Box<Map>> getUserLocalDb() async {
    Box<Map> box = await getOpenBox(boxName: 'userDataBox');
    return box;
  }

  Future<void> saveUserDataToLocalDb({@required Map userData}) async {
    Box<Map> userBox = await getUserLocalDb();
    final String key = 'userData';
    final _userData = userData;

    _userData['timestamp'] = _userData['timestamp'].toString();
    await userBox.put(key, _userData);
    debugPrint('user data saved to Local db');
  }

  Future<String> getUserUid() async {
    Box<Map> box = await getOpenBox(boxName: 'userDataBox');
    String uid = box.values.toList()[0]['uid'];
    return uid;
  }

  Future<Map> getUserData() async {
    Box<Map> box = await getOpenBox(boxName: 'userDataBox');
    Map data = box.values.toList()[0];
    return data;
  }

  Future<UserModel> getUserDataInModel() async {
    Box<Map> box = await getOpenBox(boxName: 'userDataBox');
    Map data = box.values.toList()[0];
    return UserModel.fromMap(data.cast());
  }
}
