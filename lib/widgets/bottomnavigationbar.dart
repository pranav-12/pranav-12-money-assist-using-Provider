import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_mangement_project1/screens/add/addnotes.dart';
import 'package:money_mangement_project1/screens/accounts/screen_all_transaction.dart';
import 'package:money_mangement_project1/screens/home/screen_home.dart';
import 'package:money_mangement_project1/screens/settings/screen_settings.dart';
import 'package:money_mangement_project1/screens/statistics/screen_statistic.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<AppBottomNavigationBar> {

  static int selectedCurrentIndex = 0;
  final List _pages = [
    const ScreenHome(),
    const ScreenAllTransaction(),
    const AddNotes(),
    const ScreenStatistic(),
    const ScreenSettings()
  ];
  List<Widget> items = [
    const Icon(
      Icons.home,
      size: 30,
    ),
    const Icon(
      Icons.book,
      size: 30,
    ),
    const Icon(
      Icons.add,
      size: 30,
    ),
    const Icon(
      Icons.stacked_bar_chart,
      size: 30,
    ),
    const Icon(

      Icons.settings,
      size: 30,
    )
  ];

  @override
  void initState() {
    selectedCurrentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Theme.of(context).primaryColor,
            animationCurve: Curves.easeInOutCubic,
            index: 0,
            height: 60,
            onTap: (index) {
              setState(() {
                selectedCurrentIndex = index;
              });
            },
            items: items),
        body: _pages[selectedCurrentIndex]);
  }
}
