import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

void navigate({@required BuildContext context, @required Widget page}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

void showSnackBar({
  @required BuildContext context,
  @required String message,
  Duration duration = const Duration(seconds: 5),
}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 14, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      duration: duration,
    ),
  );
}

void hideSnackBar({@required BuildContext context}) {
  Scaffold.of(context).hideCurrentSnackBar();
}

void showBasicsFlash({
  @required BuildContext context,
  @required String message,
  Duration duration = const Duration(seconds: 2),
  Color color = Colors.black,
  flashStyle = FlashStyle.floating,
}) {
  showFlash(
    context: context,
    duration: duration,
    builder: (context, controller) {
      return Flash(
        backgroundColor: color,
        controller: controller,
        style: flashStyle,
        boxShadows: kElevationToShadow[4],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        child: FlashBar(
          message: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    },
  );
}

