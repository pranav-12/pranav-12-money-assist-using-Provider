import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_mangement_project1/provider/bottomnavigation_provider.dart';
import 'package:money_mangement_project1/screens/add/addnotes.dart';
import 'package:money_mangement_project1/screens/accounts/screen_all_transaction.dart';
import 'package:money_mangement_project1/screens/home/screen_home.dart';
import 'package:money_mangement_project1/screens/settings/screen_settings.dart';
import 'package:money_mangement_project1/screens/statistics/screen_statistic.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppBottomNavigationBar extends StatelessWidget {
  AppBottomNavigationBar({super.key});

  final List _pages = [
    ScreenHome(),
    const ScreenAllTransaction(),
     AddNotes(),
     ScreenStatistic(),
    const ScreenSettings()
  ];
 final List<Widget> items = [
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
  Widget build(BuildContext context) {

    return Consumer<BottomNavigatinBarProvider>(
    
      builder: (context, value, child) => Scaffold(
          extendBody: true,
          bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: Colors.transparent,
              color: Theme.of(context).primaryColor,
              animationCurve: Curves.easeInOutCubic,
              index: 0,
              height: 60,
              onTap: (index) {
                value.bottomNavigationChange(index);
              },
              items: items),
          body: _pages[value.selectedCurrentIndex]),
    );
  }
}
