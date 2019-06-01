import 'package:flutter/material.dart';
import 'package:fluttercoin/views/screens/phone_screen.dart';

void main() => runApp(
  MaterialApp(
    title: 'MentorCoin',
    darkTheme: ThemeData.dark(),
    home: HomeScreen(),
  )
);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: PhoneScreen()
    );
  }
}




