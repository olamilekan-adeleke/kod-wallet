import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveInitMethods {
  Future<void> startUserDataHiveDb() async {
    /// This method will be called at the start of the app, this will start
    /// a local Database this will host/store the user Data.

    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox('userData');
  }
}
