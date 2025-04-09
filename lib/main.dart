import 'package:app_food_delivery/screens/auth/auth_screen.dart';
import 'package:app_food_delivery/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   fontFamily: 'BeVietnam',
      // ),
      color: Colors.white,
      //home: MainApp(),
      home: AuthScreen()
    );
  }
}
