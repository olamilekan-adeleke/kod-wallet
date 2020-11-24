import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kod_wallet_app/wallet/history/ui/pages/history_page.dart';
import 'package:kod_wallet_app/wallet/home/ui/pages/home_page.dart';
import 'package:kod_wallet_app/wallet/stat/ui/pages/stat_home_page.dart';
import 'package:kod_wallet_app/wallet/transfer/ui/pages/transfer_home_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController pageController;
  int getPageIndex = 0;

  void pageChanged(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  void onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  void navigatorCallBack(int i) {
    print(i);
    onTapChangePage(i);
  }

  @override
  void initState() {
    pageController = PageController(initialPage: getPageIndex, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        onTap: onTapChangePage, //
        currentIndex: getPageIndex, //
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.wallet, size: 20),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: -math.pi / 4,
              child: Icon(Icons.send, size: 20),
            ),
            title: Text('Transfer'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.history, size: 20),
            title: Text('Histroy'),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartBar, size: 20),
            title: Text('Statistics'),
          ),
        ],
      ),
    );
  }

  Widget pages() {
    return PageView(
      children: <Widget>[
        HomePage(),
        TransferHomePage(),
        HistoryPage(),
        StatHomePage(),
      ],
      controller: pageController,
      onPageChanged: pageChanged,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
