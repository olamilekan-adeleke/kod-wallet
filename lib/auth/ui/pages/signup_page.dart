import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/methods/auth_methods.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/auth/shared/shared_widgets.dart';
import 'package:kod_wallet_app/auth/ui/views/login_widgets.dart';
import 'package:kod_wallet_app/helper.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleView;

  SignUpPage({@required this.toggleView});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  AuthMethods authService = AuthMethods();
  StreamController loadingStream = StreamController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  DateTime dateOfBirth;

  Future<void> validateAndSave({@required BuildContext context}) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String fullName =
        firstNameController.text.trim() + ' ' + lastNameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    int accountNumber = getAccountNumber();
    final form = formKey.currentState;

    if (form.validate() && dateOfBirth != null) {
      form.save();
      loadingStream.add(true);

      ///
      await signUpUser(
        context: context,
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: int.parse(phoneNumber),
        accountNumber: accountNumber,
      );
    } else {
      showSnackBar(
        context: context,
        message: 'Fill All Form',
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> signUpUser({
    @required BuildContext context,
    @required String email,
    @required String password,
    @required String fullName,
    @required int phoneNumber,
    @required int accountNumber,
  }) async {
    try {
      await authService.registerUserWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        accountNumber: accountNumber,
        dateOfBirth: dateOfBirth,
      );
    } catch (e) {
      showSnackBar(context: context, message: '$e');
      loadingStream.add(false);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        dateOfBirth = picked;
      });
  }

  int getAccountNumber() {
    final _random = Random();
    var digit = _random.nextInt(9) + 1; // first digit must not be a zero
    int n = digit;

    for (var i = 0; i < 9; i++) {
      digit = _random.nextInt(10);
      n *= 10;
      n += digit;
    }
    return n;
  }

  @override
  void dispose() {
    loadingStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(),
            form(),
            SizedBox(height: 20),
            createAccountButton(),
            SizedBox(height: 20),
            logInButton(),
          ],
        ),
      ),
    );
  }

  Widget selectDate() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RaisedButton(
          onPressed: () => _selectDate(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Center(
              child: Text(
                '${dateOfBirth ?? 'Select-Date'}'.split(' ')[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          color: Colors.teal[400],
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            CustomTextField(
              padding: const EdgeInsets.only(left: 15, right: 15),
              title: 'First Name',
              showSuffix: false,
              controller: firstNameController,
              itemLengthCheck: 3,
            ),
            SizedBox(height: 10),
            CustomTextField(
              padding: const EdgeInsets.only(left: 15, right: 15),
              title: 'Last Name',
              showSuffix: false,
              controller: lastNameController,
              itemLengthCheck: 3,
            ),
            SizedBox(height: 10),
            CustomTextField(
              padding: const EdgeInsets.only(left: 15, right: 15),
              title: 'Phone Number',
              showSuffix: false,
              controller: phoneNumberController,
              itemLengthCheck: 3,
            ),
            SizedBox(height: 10),
            CustomTextField(
              padding: const EdgeInsets.only(left: 15, right: 15),
              title: 'Email',
              showSuffix: false,
              controller: emailController,
              itemLengthCheck: 3,
            ),
            SizedBox(height: 10),
            CustomTextField(
              padding: const EdgeInsets.only(left: 15, right: 15),
              title: 'Password',
              showSuffix: true,
              controller: passwordController,
              itemLengthCheck: 3,
            ),
            SizedBox(height: 10),
            selectDate(),
            SizedBox(height: 16),
            Text(
              "By clicking on 'Create Account', you agree to Terms And "
              "Condition And Privacy Policy",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget createAccountButton() {
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
            title: 'Create Account',
          );
        }
      },
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 40),
      padding: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Create your Account", style: headingTextStyle),
          Text("Let's get to know you better", style: subTextStyle)
        ],
      ),
    );
  }

  Widget logInButton() {
    return InkWell(
      onTap: () {
        widget.toggleView();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(
            "Already have an account ? Sign in",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
