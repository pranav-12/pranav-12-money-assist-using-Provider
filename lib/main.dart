import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_mangement_project1/models/categories/category_model.dart';
import 'package:money_mangement_project1/models/transactions/transaction_model.dart';
import 'package:money_mangement_project1/provider/accounts_provider/accounts_provider.dart';
import 'package:money_mangement_project1/provider/add_notes_provider.dart';
import 'package:money_mangement_project1/provider/bottomnavigation_provider.dart';
import 'package:money_mangement_project1/screens/screen_splash.dart';
import 'package:money_mangement_project1/screens/settings/theme_change.dart';
import 'package:money_mangement_project1/widgets/bottomnavigationbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool('is_dark') ?? false;
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }

  runApp(MyApp(
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {

  final bool isDark;
  const MyApp({super.key, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDark)),
        ChangeNotifierProvider(create: (context) => BottomNavigatinBarProvider()),
        ChangeNotifierProvider(create: (context) => ScreenAccountsProvider()),
        ChangeNotifierProvider(create: (context) => AddNotesProvider()),
      ],
      builder: (context, child) => MaterialApp(
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Mythemes.lightTheme,
        darkTheme: Mythemes.darkTheme,
        home: const ScreenSplash(),
        routes: {'screen-splash': (context) => const ScreenSplash()},
      ),
    );
  }
}
