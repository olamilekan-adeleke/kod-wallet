import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';

Widget userProfileImage({@required String url}) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      shape: BoxShape.circle,
    ),
    child: url != null
        ? Image.network(url, fit: BoxFit.fill)
        : Center(child: Icon(Icons.person, color: Colors.grey[600])),
  );
}

Widget customListTiles({
  @required String title,
  @required String subtitle,
  @required Function function,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    child: InkWell(
      onTap: () {
        function();
      },
      child: Card(
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    '$subtitle',
                    style: subTextStyle,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget customProfileAppBar({
  @required String title,
  @required Function function,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(
      '$title',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
    ),
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),
      onPressed: function,
    ),
    centerTitle: true,
  );
}
