import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login_page.dart';

// ✅ Load saved language preference
Future<String> getSavedLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('language_code') ?? 'en'; // Default: English
}

// ✅ Ensure Flutter is initialized before running the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String languageCode = await getSavedLanguage();
  runApp(MyApp(languageCode: languageCode));
}

// ✅ InheritedWidget for Locale Management (Global Access)
class LocaleProvider extends InheritedWidget {
  final Locale locale;
  final Function(Locale) setLocale;

  const LocaleProvider({
    Key? key,
    required this.locale,
    required this.setLocale,
    required Widget child,
  }) : super(key: key, child: child);

  static LocaleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
  }

  @override
  bool updateShouldNotify(LocaleProvider oldWidget) => locale != oldWidget.locale;
}

// ✅ Main App Widget (Manages Locale)
class MyApp extends StatefulWidget {
  final String languageCode;

  const MyApp({Key? key, required this.languageCode}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.languageCode); // 🌍 Load saved language
  }

  // ✅ Function to update locale & save preference
  void setLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode); // Save language
    setState(() {
      _locale = locale; // Update UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocaleProvider(
      locale: _locale,
      setLocale: setLocale,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ticket Booking',
        theme: ThemeData(primarySwatch: Colors.blue),
        locale: _locale, // 🌍 Apply selected locale
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ko'), // Korean
          Locale('ms'), // Bahasa Malaysia
        ],
        home: LoginPage(setLocale: setLocale), // ✅ Start with Login Page
      ),
    );
  }
}
