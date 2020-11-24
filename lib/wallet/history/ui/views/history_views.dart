import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kod_wallet_app/auth/shared/shared_design.dart';
import 'package:kod_wallet_app/wallet/history/enum/filter_enum.dart';
import 'package:kod_wallet_app/wallet/transfer/model/transfer_model.dart';

class CustomSearchTextField extends StatefulWidget {
  final String title;
  final EdgeInsets padding;
  final int itemLengthCheck;
  final TextEditingController controller;
  final Function function;

  CustomSearchTextField({
    @required this.padding,
    @required this.title,
    @required this.controller,
    @required this.itemLengthCheck,
    @required this.function,
  });

  @override
  _CustomSearchTextFieldState createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  String _submittedValue;

  String get value => _submittedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: formTextFieldDecoration,
      child: Padding(
        padding: widget.padding,
        child: TextField(
          textInputAction: TextInputAction.search,
          controller: widget.controller,
          onSubmitted: (val) => widget.function(val),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.title,
          ),
        ),
      ),
    );
  }
}

Widget searchBar({
  @required TextEditingController controller,
  @required Function function,
}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomSearchTextField(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        title: 'Search',
        controller: controller,
        itemLengthCheck: 1,
        function: (val) {
          function();
        },
      ),
    ),
  );
}

Widget filterOption({@required Function function}) {
  return PopupMenuButton<FilterEnum>(
    icon: Icon(Icons.sort, color: Colors.grey),
    onSelected: (enumSelected) {
      function(enumSelected);
    },
    itemBuilder: (context) => [
      PopupMenuItem(value: FilterEnum.All, child: Text("All")),
      PopupMenuItem(value: FilterEnum.Wallet, child: Text("Wallet")),
      PopupMenuItem(value: FilterEnum.Coin, child: Text("Coin")),
      PopupMenuItem(value: FilterEnum.Debit, child: Text("Debit")),
      PopupMenuItem(value: FilterEnum.Credit, child: Text("Credit")),
    ],
  );
}

Widget resultList({
  @required List<TransferHistory> historyList,
  @required ScrollController scrollController,
  @required bool showLoading,
}) {
  return Expanded(
    child: ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            customHistoryListTiles(history: historyList[index]),
            (index == historyList.length - 1 && showLoading)
                ? Container(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(),
          ],
        );
      },
    ),
  );
}

Widget customHistoryListTiles({@required TransferHistory history}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    child: Card(
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${getTimeDate(history.timestamp)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  '${history.type == 'Credit' ? '+' : '-'} \$ ${history.amount}',
                  style: TextStyle(
                    color: history.type == 'Credit' ? Colors.green : Colors.red,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${history.dec}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${history.walletType}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

String getTimeDate(Timestamp timestamp) {
  String date = timestamp.toDate().toString().split(' ')[0];
  String time = timestamp.toDate().toString().split(' ')[1].substring(0, 5);

  return '$date $time';
}
