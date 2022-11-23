import 'package:flutter/material.dart';
import 'package:money_mangement_project1/db/transactions/transaction_db.dart';
import 'package:money_mangement_project1/screens/screen_splash.dart';
import 'package:money_mangement_project1/screens/settings/about_us_screen.dart';
import 'package:money_mangement_project1/screens/settings/categories_settings.dart';
import 'package:money_mangement_project1/screens/settings/privacy_policy_screen.dart';
import 'package:money_mangement_project1/screens/settings/terms_condition.dart';
import 'package:money_mangement_project1/screens/settings/theme_change.dart';
import 'package:money_mangement_project1/widgets/bottomnavigationbar.dart';
import 'package:provider/provider.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);

// for iconButton as a list as a action
    final titleAsIconButton = [
      // category setting
      IconButton(
        onPressed: () {
          Navigator.of(navigatorKey.currentContext!).push(
            MaterialPageRoute(
              builder: (context) => const CategoriesSettings(),
            ),
          );
        },
        icon: const Icon(
          Icons.category,
          size: 40,
          color: Colors.black,
        ),
      ),
      // restapp
      IconButton(
        onPressed: () {
          resetAllDialog(themeprovider);
         
        },
        icon: const Icon(
          Icons.restore,
          size: 40,
          color: Colors.black,
        ),
      ),
      // privacy policy
      IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ScreenPrivacyPolicy(),
            ),
          );
        },
        icon: const Icon(
          Icons.privacy_tip,
          size: 40,
          color: Colors.black,
        ),
      ),
      // Terms & Condition
      IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ScreenTermsAndCondition(),
            ),
          );
        },
        icon: const Icon(
          Icons.edit_calendar_sharp,
          size: 40,
          color: Colors.black,
        ),
      ),
      // about us
      IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ScreenAboutUs(),
            ),
          );
        },
        icon: const Icon(
          Icons.info_outline,
          size: 40,
          color: Colors.black,
        ),
      ),
    ];

// for list subtitle as a test
    final subTitleForSetting = [
      const Text(
        'Category Settings',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const Text(
        'Reset App',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const Text(
        textAlign: TextAlign.center,
        'Privacy Policy',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const Text(
        textAlign: TextAlign.center,
        'Terms & conditions',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      const Text(
        'About Us',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ];


    return Scaffold(
// appbar
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
// body
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Switch Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
// switch theme
              Switch(
                activeColor: Theme.of(context).primaryColor,
                value: themeprovider.isDarkMode,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              )
            ],
          ),
// building as a list for settings
          ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: titleAsIconButton[index],
                      subtitle: subTitleForSetting[index],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 5,
                );
              },
              itemCount: 5)
        ],
      ),
    );
  }


// for resetall fucntion
  resetAllDialog(ThemeProvider themeprovider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.grey.shade200,
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
                onPressed: () {
                  TransactionDB.instance.resetAll();
                   themeprovider.toggleTheme(false);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const ScreenSplash(),
                      ),
                      (route) => false);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      },
    );
  }
}
