import 'package:flutter/material.dart';
import 'package:rk_coin/screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rk_Coin',
      home: HomeScreen(),
    );
  }
}

