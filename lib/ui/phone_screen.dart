import 'package:flutter/material.dart';

import 'insta_home_screen.dart';


class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation,
      _delayedAnimation,
      _muchDelayedAnimation,
      _muchMuchDelayedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    _delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));

    _muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    _muchMuchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    _animationController.forward();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/login_updated.jpg'),
                        fit: BoxFit.cover)),
              ),
              Opacity(
                opacity: 0.6,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 120.0, 8.0, 8.0),
                child: Column(
                  //  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Transform(
                      transform: Matrix4.translationValues(
                          _animation.value * width, 0.0, 0.0),
                      child: Text('Blackgrape',
                          style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Merienda',
                              color: Colors.white)),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 100.0, left: 16.0, right: 16.0),
                        child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.white,
                          ),
                          child: Transform(
                            transform: Matrix4.translationValues(
                                _delayedAnimation.value * width, 0.0, 0.0),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              maxLength: 10,
                              decoration: InputDecoration(
                                  counterStyle: TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                  labelText: 'Your Phone Number',
                                  labelStyle: TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 4.0),
                                      borderRadius:
                                          BorderRadius.circular(12.0))),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          _muchDelayedAnimation.value * width, 0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Switch(
                              activeColor: Colors.white,
                              inactiveTrackColor: Colors.grey,
                              activeTrackColor: Colors.white,
                              value: false,
                              onChanged: (value) {},
                            ),
                            Text('I am of 13 years or older',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0))
                          ],
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          _muchMuchDelayedAnimation.value * width, 0.0, 0.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: ((context) => InstaHomeScreen())
                            ));
                          },
                          child: Container(
                            height: 40.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.blue),
                            child: Center(
                              child: Text(
                                'Send OTP',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
