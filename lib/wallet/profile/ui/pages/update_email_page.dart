import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/auth/shared/shared_widgets.dart';
import 'package:kod_wallet_app/auth/ui/views/login_widgets.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/profile/repo/profile_methods.dart';

import '../../../../helper.dart';

class UpdateEmailPage extends StatefulWidget {
  @override
  _UpdateEmailPageState createState() => _UpdateEmailPageState();
}

class _UpdateEmailPageState extends State<UpdateEmailPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  Future<void> save() async {
    final from = formKey.currentState;

    if (from.validate()) {
      String email = emailController.text.trim();
      UserModel oldData = await HiveMethods().getUserDataInModel();

      UserModel updatedData = UserModel(
        uid: oldData.uid,
        email: email,
        fullName: oldData.fullName,
        phoneNumber: oldData.phoneNumber,
        profilePicUrl: oldData.profilePicUrl,
        dateOfBirth: oldData.dateOfBirth,
        address: oldData.address,
        accountNumber: oldData.accountNumber,
        timestamp: oldData.timestamp,
      );

      try {
        await ProfileMethods().updateUserData(userData: updatedData);
      } catch (e) {
        showBasicsFlash(context: context, message: '${e.message}');
      }
    } else {
      showBasicsFlash(
        context: context,
        message: 'Fill All Form',
        duration: Duration(seconds: 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: updateFullName(),
    );
  }

  Widget updateFullName() {
    return ListView(
      children: [
        Text(
          'Update Email Address',
          style: headingTextStyle,
        ),
        form(),
        customButton(
          function: () {
            save();
          },
          context: context,
          title: 'Update Email',
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            title: 'Email',
            showSuffix: false,
            controller: emailController,
            itemLengthCheck: 5,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
