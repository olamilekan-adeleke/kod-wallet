import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:kod_wallet_app/constant.dart';
import 'package:kod_wallet_app/local_db/init_hive.dart';
import 'package:provider/provider.dart';

import 'auth/helper/wrapper.dart';
import 'auth/methods/auth_methods.dart';
import 'auth/model/login_model.dart';
import 'bloc_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveInitMethods().startUserDataHiveDb();
  await PaystackPlugin().initialize(publicKey: publicKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LoginUserModel>.value(
      value: AuthMethods().userStream,
      child: MultiBlocProvider(
        providers: blocList(context: context),
        child: MaterialApp(
          title: 'Kod Wallet',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}
