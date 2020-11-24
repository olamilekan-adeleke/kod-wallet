import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/helper/toggle_helper.dart';
import 'package:kod_wallet_app/auth/model/login_model.dart';
import 'package:kod_wallet_app/wallet/landing_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // this wrapper class is here to monitor the auth changes, it returns home
    // page if the user is already logged in and login page if not instance of
    // login is present(no user is already logged in) or the user logged out.
    // provider is being used to monitor the UserStream in the auth method class

    final user = Provider.of<LoginUserModel>(context);

    if (user == null) {
      return ToggleBetweenLoginAndSignUpPage();
    } else {
      return LandingPage();
    }
  }
}
