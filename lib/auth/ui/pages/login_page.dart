import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/methods/auth_methods.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/auth/shared/shared_widgets.dart';
import 'package:kod_wallet_app/auth/ui/pages/forgot_password_page.dart';
import 'package:kod_wallet_app/auth/ui/views/login_widgets.dart';
import 'package:kod_wallet_app/helper.dart';

class LogInPage extends StatefulWidget {
  final Function toggleView;

  LogInPage({this.toggleView});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AuthMethods authService = AuthMethods();
  StreamController loadingStream = StreamController<bool>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> validateAndSave({@required BuildContext context}) async {
    final form = formKey.currentState;

    if (form.validate()) {
      loadingStream.add(true);
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      debugPrint(email);
      debugPrint(password);
      await logInUser(email: email, password: password, context: context);
    }
  }

  Future<void> logInUser({
    @required String email,
    @required String password,
    @required BuildContext context,
  }) async {
    try {
      await authService.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
//      if (!mounted) {
      showSnackBar(context: context, message: '${e.message}');
//      }
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
      body: ListView(
        children: [
          loginGreetingWidget(),
          form(),
          SizedBox(height: 40),
          signInButton(),
          SizedBox(height: 20),
          forgotPassword(),
          SizedBox(height: 20),
          createAccountButton(),
        ],
      ),
    );
  }

  Widget forgotPassword() {
    return Container(
      child: InkWell(
        onTap: () => navigate(context: context, page: ForgetPasswordPage()),
        child: Text(
          'Opps, Forgot Password? Click Here To Reset Password',
          style: subTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget createAccountButton() {
    return InkWell(
      onTap: () {
        widget.toggleView();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            "New Here ? Click Here To Create An Account",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget signInButton() {
    return StreamBuilder(
      stream: loadingStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Center(child: CircularProgressIndicator());
        } else {
          return customButton(
            context: context,
            function: () {
              validateAndSave(context: context);
            },
            title: 'Sign In',
          );
        }
      },
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            CustomTextField(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              title: 'Email',
              showSuffix: false,
              controller: emailController,
              itemLengthCheck: 5,
            ),
            SizedBox(height: 40),
            CustomTextField(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              title: 'Password',
              showSuffix: true,
              controller: passwordController,
              itemLengthCheck: 6,
            ),
          ],
        ),
      ),
    );
  }
}
