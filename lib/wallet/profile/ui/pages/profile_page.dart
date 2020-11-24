import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kod_wallet_app/auth/methods/auth_methods.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/helper.dart';
import 'package:kod_wallet_app/local_db/hive_methods.dart';
import 'package:kod_wallet_app/wallet/profile/enum/update_profile_enum.dart';
import 'package:kod_wallet_app/wallet/profile/ui/pages/update_address_page.dart';
import 'package:kod_wallet_app/wallet/profile/ui/pages/update_email_page.dart';
import 'package:kod_wallet_app/wallet/profile/ui/pages/update_phone_number_page.dart';
import 'package:kod_wallet_app/wallet/profile/ui/pages/update_user_fullName.dart';
import 'package:kod_wallet_app/wallet/profile/ui/views/profile_page_view.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Box<Map> userDataBox;
  StreamController loadedStream = StreamController<bool>();

  Future<void> getBox() async {
    userDataBox = await HiveMethods().getUserLocalDb();
    loadedStream.add(true);
  }

  void navigate({@required UpdateUserDetailsEnum type}) {
    Widget page;

    if (type == UpdateUserDetailsEnum.updateFullName) {
      page = UpdateUserFullNamePage();
    } else if (type == UpdateUserDetailsEnum.updateEmail) {
      page = UpdateEmailPage();
    } else if (type == UpdateUserDetailsEnum.updatePhoneNumber) {
      page = UpdatePhoneNumberPage();
    } else if (type == UpdateUserDetailsEnum.updateAddress) {
      page = UpdateAddressPage();
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void signOut() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Warning!'),
          content: Text(
            'You Are About To Sign Out... \n '
            'Are You Sure You Want To Proceed.',
            style: subTextStyle,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red,
              child: Text('Yes', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await AuthMethods().signOut();
                Navigator.of(dialogContext).pop();
              },
            ),
            FlatButton(
              color: Colors.grey[500],
              child: Text('No', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customProfileAppBar(
        title: 'Profile',
        function: () {
          Navigator.pop(context);
        },
      ),
      body: bodyStream(),
    );
  }

  Widget infoList({@required UserModel userData}) {
    return ListView(
      children: [
        SizedBox(height: 40),
        userProfileImage(url: userData.profilePicUrl),
        SizedBox(height: 20),
        accountDetails(userData: userData),
        SizedBox(height: 50),
        customListTiles(
          title: userData.fullName,
          subtitle: 'Change Account Name',
          function: () {
            navigate(type: UpdateUserDetailsEnum.updateFullName);
          },
        ),
        customListTiles(
          title: userData.email,
          subtitle: 'Change Account Email',
          function: () {
//            navigate(type: UpdateUserDetailsEnum.updateEmail);
          },
        ),
        customListTiles(
          title: userData.phoneNumber.toString(),
          subtitle: 'Change Account Phone Number',
          function: () {
            navigate(type: UpdateUserDetailsEnum.updatePhoneNumber);
          },
        ),
        customListTiles(
          title: userData.address ?? 'No Address Given Yet',
          subtitle: 'Change Account Owner Address',
          function: () {
            navigate(type: UpdateUserDetailsEnum.updateAddress);
          },
        ),
        customListTiles(
          title: 'Sign Out',
          subtitle: 'Tap To Log Out.',
          function: () {
            signOut();
          },
        ),
      ],
    );
  }

  Widget accountDetails({@required UserModel userData}) {
    return Column(
      children: [
        Text(
          '${userData.fullName}',
          style: headingTextStyle,
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: '${userData.accountNumber}'));
            showBasicsFlash(
              context: context,
              message: 'Account Number Has Been Copied To ClipBoard.',
            );
          },
          child: Text(
            'Account Number: ${userData.accountNumber}',
            style: subTextStyle,
          ),
        ),
      ],
    );
  }

  Widget bodyStream() {
    return StreamBuilder(
      stream: loadedStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return ValueListenableBuilder(
            valueListenable: userDataBox.listenable(),
            builder: (BuildContext context, Box box, Widget child) {
              if (box.isEmpty) {
                return Center(child: Text('No data Found'));
              } else {
                Map data = box.get('userData');
                data.remove('timestamp');
                UserModel userData =
                    UserModel.fromMap(data.cast<String, dynamic>());
                return infoList(userData: userData);
              }
            },
          );
        } else {
          return Container(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
