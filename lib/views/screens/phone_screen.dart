import 'package:flutter/material.dart';
import 'package:fluttercoin/views/screens/otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 200.0,
            child: ClipPath(
              clipper: MyClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 540.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Positioned(
            top: 140.0,
            left: MediaQuery.of(context).size.width /2 - 120.0,
            child: RichText(
              text: TextSpan(
                text: 'Mentor',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Connect',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 35.0)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 290.0,
            left: 40.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome to',
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),

              RichText(
                  text: TextSpan(
                    text: 'Mentor',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Connect',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 25.0)),
                    ],
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please sign in to continue',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: 250.0,
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: 250.0,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter your number',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
               
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 + 120.0,
            left: MediaQuery.of(context).size.width - 200.0,
            child: Container(
              width: 100.0,
              height: 40.0,
              child: RaisedButton(
                splashColor: Colors.yellow,
                color: Colors.red,
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => OtpScreen()
                  ));
                },
                child: Text(
                  'NEXT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 80.0);

    var firstControlPoint = new Offset(50.0, size.height);
    var firstEndPoint = new Offset(size.width / 3.5, size.height - 45.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width - 30.0, size.height / 2);

    var secondControlPoint =
        new Offset(size.width + 15.0, size.height / 2 - 60.0);
    var secondEndPoint = new Offset(140.0, 50.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint = new Offset(50.0, 0.0);
    var thirdEndPoint = new Offset(0.0, 100.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
