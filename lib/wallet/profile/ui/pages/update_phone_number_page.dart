import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/auth/shared/shared_widgets.dart';
import 'package:kod_wallet_app/auth/ui/views/login_widgets.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/profile/ui/views/profile_page_view.dart';
import 'package:kod_wallet_app/wallet/profile/update_user_bloc/update_user_details_bloc.dart';

import '../../../../helper.dart';

class UpdatePhoneNumberPage extends StatefulWidget {
  @override
  _UpdatePhoneNumberPageState createState() => _UpdatePhoneNumberPageState();
}

class _UpdatePhoneNumberPageState extends State<UpdatePhoneNumberPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();

  Future<void> save() async {
    final from = formKey.currentState;

    if (from.validate()) {
      String phoneNumber = phoneNumberController.text.trim();
      UserModel oldData = await HiveMethods().getUserDataInModel();

      UserModel updatedData = UserModel(
        uid: oldData.uid,
        email: oldData.email,
        fullName: oldData.fullName,
        phoneNumber: int.parse(phoneNumber),
        profilePicUrl: oldData.profilePicUrl,
        dateOfBirth: oldData.dateOfBirth,
        address: oldData.address,
        accountNumber: oldData.accountNumber,
        timestamp: oldData.timestamp,
      );

      try {
        BlocProvider.of<UpdateUserDetailsBloc>(context)
            .add(UpdateDetailsEvent(userData: updatedData));
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
      appBar: customProfileAppBar(
        title: 'Edit Phone Name',
        function: () => Navigator.pop(context),
      ),
      body: updateFullName(),
    );
  }

  Widget button() {
    return BlocConsumer<UpdateUserDetailsBloc, UpdateUserDetailsState>(
      listener: (context, UpdateUserDetailsState state) {
        if (state is LoadedUpdateUserDetailsState) {
          showBasicsFlash(
            context: context,
            message: 'Done!',
            color: Colors.green,
          );
        }
      },
      builder: (context, UpdateUserDetailsState state) {
        if (state is InitialUpdateUserDetailsState) {
          return customButton(
            function: () {
              save();
            },
            context: context,
            title: 'Update Phone Name',
          );
        } else if (state is LoadingUpdateUserDetailsState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedUpdateUserDetailsState) {
          return customButton(
            function: () {
              save();
            },
            context: context,
            title: 'Update Phone Name',
          );
        } else if (state is ErrorUpdateUserDetailsState) {
          return customButton(
            function: () {
              save();
            },
            context: context,
            title: 'Update Phone Name',
          );
        }

        return Container();
      },
    );
  }

  Widget updateFullName() {
    return ListView(
      children: [
        SizedBox(height: 40),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'Update Phone Number',
            style: headingTextStyle,
          ),
        ),
        SizedBox(height: 20),
        form(),
        SizedBox(height: 60),
        button(),
      ],
    );
  }

  Widget form() {
    return Form(
      key: formKey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            CustomTextField(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              title: 'Phone Number',
              showSuffix: false,
              controller: phoneNumberController,
              itemLengthCheck: 11,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
