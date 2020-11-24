import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';

Widget loginGreetingWidget() {
  return Container(
    margin: EdgeInsets.only(top: 50, left: 35, bottom: 50),
    child: Column(
      children: [
        Row(
          children: <Widget>[Text('Welcome Back', style: headingTextStyle)],
        ),
        Row(
          children: <Widget>[
            Text('It\'s Nice Seeing You Again.', style: subTextStyle),
          ],
        ),
      ],
    ),
  );
}

Widget customButton({
  @required Function function,
  BuildContext context,
  @required String title,
}) {
  return Container(
    height: 40,
    padding: EdgeInsets.all(5.0),
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
