
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';

import 'insta_home_screen.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Feed'),
            onPressed: () {
              var _repository = Repository();
              FirebaseUser user = FirebaseAuth.instance.currentUser() as FirebaseUser;
              _repository.addDataToDb(user).then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return InstaHomeScreen();
                }));
              });
            },
          ),

          RaisedButton(
            child: Text('Profile'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => InstaHomeScreen())));
            },
          ),
        ],
      ),
    );
  }
}
