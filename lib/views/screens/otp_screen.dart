import 'package:flutter/material.dart';
import 'package:fluttercoin/views/screens/feed_screen.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 2 + 200.0,
            height: MediaQuery.of(context).size.height / 2 - 100.0,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/otp.png'),
            )),
          ),
          Text('Verification',
              style: TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0)),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Please enter the verification code and it will be valid within 5 minutes.',
                style: TextStyle(fontSize: 17.0, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Verification code',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedScreen()));
            },
            shape: StadiumBorder(),
            splashColor: Colors.red,
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              'Go',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: Colors.cyan,
          )
        ],
      ),
    );
  }
}
