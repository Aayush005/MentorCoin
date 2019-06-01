import 'package:flutter/material.dart';
import 'package:instagram_clone/models/trending_users.dart';

class Achievements extends StatefulWidget {
  @override
  _AchievementsState createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {

  List<TrendingUsers> _trendingUsers;

  @override
  void initState() {

    super.initState();
    _trendingUsers = [
      TrendingUsers('assets/dp0.png', 'Manik Gupta' , '10'),
      TrendingUsers('assets/dp1.png', 'Mohak Gupta' , '20'),
      TrendingUsers('assets/dp2.png', 'Aayush Upadhyay' , '30'),
      TrendingUsers('assets/dp4.png', 'Rameet Singh' , '40'),
      TrendingUsers('assets/dp4.png', 'Rameet Singh' , '40'),

    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors:
                [
                  Colors.blue[900],
                  Colors.purple
                ]
            )
        ),
        child: ClipPath(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0, bottom: 10.0),
            child: Container(
              height: 100.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0)
              )  ,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: ListView.builder(physics: BouncingScrollPhysics(),
                  itemCount: _trendingUsers.length,
                  itemBuilder: (context , index){

                    return Padding(
                      padding: (index % 2 == 0) ? const EdgeInsets.only( left: 2.0 , top: 15.0 , right: 120.0 )
                          : const EdgeInsets.only( left: 160.0 , top: 15.0 , right: 50.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(_trendingUsers[index].profileImage),
                                )
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Text(
                              _trendingUsers[index].name,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_trendingUsers[index].questionSolved,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black
                                ),
                              ),

                              Icon(Icons.star , color: Colors.yellow,)
                            ],
                          ),



                        ],
                      ),
                    );
                  },


                ),
              ),
            ),
          ),
          clipper: MyClipper(),
        ),
      ),
    );
  }
}



class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 50);

    // var firstEndPoint =Offset(0.0, size.height - 15);
    var firstEndPoint =Offset(size.width / 2.25, size.height- 30);
    var firstControlPoint =Offset(size.width / 4 , size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);



    var secondEndPoint =Offset(size.width , size.height - 40);
    var secondControlPoint =Offset(size.width - (size.width / 3.25), size.height - 65);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);



    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.lineTo(0.0, 0.0);
    path.close();
    //  path.lineTo(0.0, size.height / 2);
    //  path.lineTo(size.width, size.height / 2 + 200.0);
    //  path.lineTo(size.width, 0.0);
    //  path.lineTo(0.0, 0.0);
    //  path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return null;
  }

}