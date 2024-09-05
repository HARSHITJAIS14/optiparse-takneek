import 'package:flutter/material.dart';
import 'package:optiparse/auth/screens/background_page.dart';
import 'package:optiparse/auth/screens/login.dart';
import 'package:optiparse/auth/screens/signup.dart';
import '../themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const String baseUrl = 'http://192.168.102.64:8060';
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OptiParse',
        theme: appthemes.lighttheme,
        home: BackgroundPage(),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          //'/profile': (context) => ProfilePage(),
        });
  }
}
