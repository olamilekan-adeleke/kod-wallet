import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/methods/auth_methods.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/auth/shared/shared_widgets.dart';
import 'package:kod_wallet_app/auth/ui/views/login_widgets.dart';

import '../../../helper.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  StreamController loadingStream = StreamController<bool>();
  TextEditingController emailController = TextEditingController();

  Future<void> resetPassword({@required BuildContext context}) async {
    if (formKey.currentState.validate()) {
      loadingStream.add(true);
      await AuthMethods().resetEmail(email: emailController.text);
      showSnackBar(
        context: context,
        message: 'A Rest Password Link Has Been Sent To The Email You '
            'Provided. \n Procced To Check For Email.',
      );
      loadingStream.add(false);
    }
  }

  @override
  void dispose() {
    loadingStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reset Password', style: headingTextStyle),
                  Text('Input Your Email Address Below', style: subTextStyle),
                ],
              ),
            ),
            SizedBox(height: 40),
            form(),
            SizedBox(height: 40),
            resetButton(context: context),
          ],
        ),
      ),
    );
  }

  Widget resetButton({@required BuildContext context}) {
    return StreamBuilder<bool>(
      stream: loadingStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Center(child: CircularProgressIndicator());
        } else {
          return customButton(
            function: () async {
              resetPassword(context: context);
            },
            title: 'Reset Password',
            context: context,
          );
        }
      },
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: formKey,
        child: Column(children: [
          CustomTextField(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            title: 'Email',
            showSuffix: false,
            controller: emailController,
            itemLengthCheck: 5,
          ),
        ]),
      ),
    );
  }
}
