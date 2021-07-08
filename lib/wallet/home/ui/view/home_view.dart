import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kod_wallet_app/auth/methods/auth_methods.dart';
import 'package:kod_wallet_app/auth/model/user_model.dart';
import 'package:kod_wallet_app/wallet/profile/ui/pages/profile_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

String currencyFormatter({@required int amount}) {
  final formatter = new NumberFormat("#,##0.00", "en_US");
  return formatter.format(amount);
}

Widget homeProfileImage({@required String url, BuildContext context}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    },
    child: Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: url != null
          ? Image.network(url, fit: BoxFit.fill)
          : Center(child: Icon(Icons.person, color: Colors.grey[600])),
    ),
  );
}

Widget homeProfileGreeting({@required String userName}) {
  return Container(
    child: Text(
      'Welcome, ${userName.split(' ')[0]}',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget userDetailWidget({@required Box userDataBox}) {
  AuthMethods auth = AuthMethods();

  return ValueListenableBuilder(
    valueListenable: userDataBox.listenable(),
    builder: (BuildContext context, Box box, Widget child) {
      // auth.signOut();
      // if (box.isEmpty) {
      //   return Center(child: Text('No data Found'));
      // } else {
      Map data = box.get('userData');
      data?.remove('timestamp');
      print(data);
      UserModel userData =
          UserModel.fromMap(data?.cast<String, dynamic>() ?? {});
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: [
            homeProfileImage(url: userData?.profilePicUrl, context: context),
            SizedBox(width: 20),
            homeProfileGreeting(userName: userData?.fullName ?? ''),
          ],
        ),
      );
    },
    // },
  );
}

Widget balanceWidget({@required String title, @required int amount}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    margin: EdgeInsets.symmetric(horizontal: 30),
    decoration: BoxDecoration(
      color: Colors.teal,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 10),
          child: Text(
            '$title Ballance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 5.0),
          child: Text(
            '\$ ${amount == null ? 'Loading...' : currencyFormatter(amount: amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget customButton({
  @required Function function,
  @required BuildContext context,
  @required String title,
}) {
  return Container(
    height: 60,
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: InkWell(
      onTap: () {
        function();
      },
      child: Center(
        child: Text(
          "$title",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}
