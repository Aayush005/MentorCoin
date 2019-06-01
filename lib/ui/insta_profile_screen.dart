import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/models/like.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/ui/comments_screen.dart';
import 'package:instagram_clone/ui/edit_profile_screen.dart';
import 'package:instagram_clone/ui/likes_screen.dart';
import 'package:instagram_clone/ui/post_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InstaProfileScreen extends StatefulWidget {
  // InstaProfileScreen();

  @override
  _InstaProfileScreenState createState() => _InstaProfileScreenState();
}

class _InstaProfileScreenState extends State<InstaProfileScreen> {


  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: new Color(0xfff8faf8),
          elevation: 1,
          title: Text('Profile'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings_power),
              color: Colors.black,
              onPressed: () {
                _repository.signOut().then((v) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                });
              },
            )
          ],
        ),
        body: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  var _repository = Repository();
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;
  User _user;
  IconData icon;
  Color color;
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;


  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    icon = FontAwesomeIcons.heart;
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    _future = _repository.retrieveUserPosts(_user.uid);
  }


  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 110.0,
                height: 110.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _user.photoUrl.isEmpty
                            ? AssetImage('assets/no_image.png')
                            : NetworkImage(_user.photoUrl),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _user.displayName,
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    Padding(///____________TODO AUTHOR OF THE PAGE________________///
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _user.bio,
                        style: TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: Divider(color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
           child: new Padding(
            padding: new EdgeInsets.all(0.0),
              child: Row(

                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                        width: 30.0,
                      ),
                      postCountWidget(),
                      followersCountWidget(),
                      followingCountWidget()
                    ],
                  ),

                ],
              ),
        ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0),
          child: Divider(color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.only(left:32.0 , right: 32.0 , top: 16.0),
          child: Text(
            'About the Page',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:32.0 , right: 32.0 , top: 20.0 ),
          child: Text(
            _user.bio,
            style: TextStyle(color: Colors.grey, fontSize: 15.0),
          ),
        ),



        Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0),
          child: Divider(color: Colors.grey),
        ),

        Padding(
          padding: const EdgeInsets.only(left:32.0 , right: 32.0 , top: 16.0),
          child: Text(
            'Posts',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: postImagesWidget(),
        ),
      ],
    );
    } else {
      return
        Center(
          child: CircularProgressIndicator(),
        );

    }
    }


  Padding bioWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 10.0),
      child: _user.bio.isNotEmpty ? Text(_user.bio) : Container(),
    );
  }

  Padding displayNameWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 30.0),
      child: Text(_user.displayName,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0)),
    );
  }

  GestureDetector editProfileButton(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 150.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.grey)),
        child: Center(
          child: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => EditProfileScreen(
                    photoUrl: _user.photoUrl,
                    email: _user.email,
                    bio: _user.bio,
                    name: _user.displayName,
                    phone: _user.phone))));
      },
    );
  }

  StreamBuilder<List<DocumentSnapshot>> followingCountWidget() {
    return StreamBuilder(
      stream:
          _repository.fetchStats(uid: _user.uid, label: 'following').asStream(),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: detailsWidget(snapshot.data.length.toString(), 'following'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  StreamBuilder<List<DocumentSnapshot>> followersCountWidget() {
    return StreamBuilder(
      stream:
          _repository.fetchStats(uid: _user.uid, label: 'followers').asStream(),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: detailsWidget(snapshot.data.length.toString(), 'followers'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  StreamBuilder<List<DocumentSnapshot>> postCountWidget() {
    return StreamBuilder(
      stream: _repository.fetchStats(uid: _user.uid, label: 'posts').asStream(),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return detailsWidget(snapshot.data.length.toString(), 'posts');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget postImagesWidget() {
    return _isGridActive == true
        ? FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data[index].data['imgUrl'],
                          placeholder: ((context, s) => Center(
                                child: CircularProgressIndicator(),
                              )),
                          width: 125.0,
                          height: 125.0,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          print(
                              "SNAPSHOT : ${snapshot.data[index].reference.path}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PostDetailScreen(
                                        user: _user,
                                        currentuser: _user,
                                        documentSnapshot: snapshot.data[index],
                                      ))));
                        },
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('No Posts Found'),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          )
        : FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                      height: 600.0,
//                      child: ListView.builder(
//                          shrinkWrap: true,
//                          itemCount: snapshot.data.length,
//                          itemBuilder: ((context, index) => ListItem(
//                              list: snapshot.data,
//                              index: index,
//                              user: _user)))
                               );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          );
  }

  Widget detailsWidget(String count, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 15.0),),
//        SizedBox(
//          width: 40.0,
//        ),

      ],

    );
}

}




