import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';

Widget customTransferTextField({
  @required String title,
  @required EdgeInsets padding,
  @required int itemLengthCheck,
  @required TextEditingController controller,
  TextInputAction keyboardAction = TextInputAction.done,
  TextInputType keyboardType = TextInputType.text,
  int maxLength,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.grey[200],
    ),
    child: Padding(
      padding: padding,
      child: TextFormField(
        maxLength: maxLength,
        keyboardType: keyboardType,
        textInputAction: keyboardAction,
        controller: controller,
        validator: (value) {
          if (value.trim().isEmpty) {
            return '$title Can\'t Be Empty';
          } else if (value.trim().length < itemLengthCheck) {
            return '$title Must Be More Than $itemLengthCheck Character';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter $title',
        ),
      ),
    ),
  );
}

Widget customTransferAppBar({
  @required String title,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(
      '$title',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    centerTitle: true,
  );
}

Widget formTitle(String message) {
  return Container(
    margin: EdgeInsets.only(bottom: 5.0, left: 2.0),
    child: Text('$message'),
  );
}

Widget customTransferButton({
  @required Function function,
  @required bool loaded,
}) {
  return Container(
    height: 60,
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: loaded ? Colors.teal : Colors.grey,
      borderRadius: BorderRadius.circular(15),
    ),
    child: InkWell(
      onTap: () {
        function();
      },
      child: Center(
        child: Text(
          "Proceed",
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

Widget button({Stream<bool> loadingStream, Function function}) {
  return StreamBuilder<bool>(
    stream: loadingStream,
    builder: (context, snapshot) {
      if (snapshot.data == true) {
        return customTransferButton(
          function: () {
            function();
          },
          loaded: snapshot.data,
        );
      } else {
        return customTransferButton(
          function: () {},
          loaded: false,
        );
      }
    },
  );
}

Widget receiverDataWidget({String message, Color color}) {
  return Column(
    children: [
      Divider(),
      Row(
        children: [
          Text(
            'Receiver Account Name:  ',
            style: subTextStyle,
          ),
          Flexible(
            child: Text(
              '$message',
              style: TextStyle(
                color: color ?? Colors.grey[700],
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      Divider(),
    ],
  );
}
