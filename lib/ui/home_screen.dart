import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:instagram_clone/ui/activity_screen.dart';
import 'package:instagram_clone/ui/add_screen.dart';
import 'package:instagram_clone/ui/feed_screen.dart';
import 'package:instagram_clone/ui/friend_profile.dart';
import 'package:instagram_clone/ui/profile_screen.dart';

import 'acheivements_screen.dart';
import 'screen_screen.dart';


class InstaHomeScreen extends StatefulWidget {
  @override
  _InstaHomeScreenState createState() => _InstaHomeScreenState();

}

PageController pageController;

class _InstaHomeScreenState extends State<InstaHomeScreen> {

  var _repository = Repository();
  int _page = 0;
  bool home = true;
  User _user = User();
  User currentUser;
  List<User> usersList = List<User>();

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
    addOnlineUsers();
    //removeOnlineUsers();

  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new PageView(
        children: [
          //1
          new Container(
            color: Colors.white,
            child: InstaFeedScreen(),
          ),
          //2
          new Container(color: Colors.white, child: InstaAddScreen()),
          //3
          new Container(
            color: Colors.white,
            child: InstaAddScreen(),
          ),
          //4
          new Container(
              color: Colors.white, child: InstaActivityScreen()),
          //5
          new Container(
              color: Colors.white,
              child: InstaProfileScreen()),

          //6
          new Container(
              color: Colors.white,
              child: InstaSearchScreen()),

          //7
          new Container(
              color: Colors.white,
              child: Achievements()),

        ],
        controller: pageController,
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),

//      appBar: AppBar(title: const Text('Bottom App Bar')),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: home?
        const Icon(Icons.add)
        :
        const Icon(Icons.home),
         onPressed: () {
          if(home) {
            pageController.jumpToPage(2);
            home = false;
          }else{
            pageController.jumpToPage(0);
            home = true;
          }

      },),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,


        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

          new Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(icon: Icon(Icons.brightness_1, color: Colors.green,), onPressed: () async {

                _showModal();

              },),
              IconButton(icon: Icon(Icons.search), onPressed: (){
                pageController.jumpToPage(6);
                home = false;
                }, ),
          ]),


            new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(icon: Icon(Icons.person), splashColor: Colors.black, onPressed: (){
                  navigationTapped(4);
                  home = false;},),
                IconButton(icon: Icon(Icons.star), color: Colors.yellow, onPressed: (){
                  navigationTapped(6);
                  home = false;},),
                 Stack(
                    children: <Widget>[
                      new Icon(Icons.notifications),
                      new Positioned(  // draw a red marble
                        top: 0.0,
                        right: 0.0,
                        child: new Icon(Icons.brightness_1, size: 8.0,
                            color: Colors.redAccent),
                      )
                    ]
                ),
                IconButton(icon: Icon(Icons.more_vert), onPressed: (){ }  ),

              ],
            )

          ],
        ),
      ),
    );
  }

  void _showModal() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: usersList.length,

            itemBuilder: ((context, index) => ListTile(
              onTap: () {

                //   showResults(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: ((context) => InstaFriendProfileScreen(name: usersList[index].displayName))
                ));

              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(usersList[index].photoUrl),
              ),
              title: Text(usersList[index].displayName),
            )),


          );
        });
  }

  void addOnlineUsers() {

    //Fetching users from db
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoUrl;
      _repository.fetchUserDetailsById(user.uid).then((user) {
        setState(() {
          currentUser = user;
        });
      });

      _repository.fetchAllUsers(user).then((list) {
        setState(() {
          usersList = list;
        });
      });
    });

    //displaying users in the bottomsheet


  }



}