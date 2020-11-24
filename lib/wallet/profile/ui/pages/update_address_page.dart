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

class UpdateAddressPage extends StatefulWidget {
  @override
  _UpdateAddressPageState createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController stateNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future<void> save() async {
    final from = formKey.currentState;

    if (from.validate()) {
      String address = streetController.text.trim() +
          ' ' +
          cityNameController.text.trim() +
          ', ' +
          stateNameController.text.trim();
      UserModel oldData = await HiveMethods().getUserDataInModel();

      UserModel updatedData = UserModel(
        uid: oldData.uid,
        email: oldData.email,
        fullName: oldData.fullName,
        phoneNumber: oldData.phoneNumber,
        profilePicUrl: oldData.profilePicUrl,
        dateOfBirth: oldData.dateOfBirth,
        address: address,
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
        title: 'Edit Address',
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
            title: 'Update Address',
          );
        } else if (state is LoadingUpdateUserDetailsState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedUpdateUserDetailsState) {
          return customButton(
            function: () {
              save();
            },
            context: context,
            title: 'Update Address',
          );
        } else if (state is ErrorUpdateUserDetailsState) {
          return customButton(
            function: () {
              save();
            },
            context: context,
            title: 'Update Address',
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
            'Update Address',
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
              title: 'Street Name',
              showSuffix: false,
              controller: streetController,
              itemLengthCheck: 3,
            ),
            SizedBox(height: 10),
            CustomTextField(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              title: 'City Name',
              showSuffix: false,
              controller: cityNameController,
              itemLengthCheck: 3,
            ),
            SizedBox(height: 10),
            CustomTextField(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              title: 'State Name',
              showSuffix: false,
              controller: stateNameController,
              itemLengthCheck: 3,
            ),
          ],
        ),
      ),
    );
  }
}
