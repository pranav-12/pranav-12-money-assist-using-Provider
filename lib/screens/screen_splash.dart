import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_mangement_project1/widgets/bottomnavigationbar.dart';
import 'package:page_transition/page_transition.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          
          statusBarColor: Colors.black,
        ),
        backgroundColor:  Colors.black,
        elevation: 0,
      ),
      body: AnimatedSplashScreen(
        pageTransitionType: PageTransitionType.leftToRight,
        
        backgroundColor: Colors.black,
        splashIconSize: 200,
        
        curve: Curves.easeIn,
        splashTransition: SplashTransition.scaleTransition,

        splash: Image.asset('assets/logo.png'),
        nextScreen:  AppBottomNavigationBar(),
        // nextScreen: ScreenSplash(),
      ),
    );
  }
}
