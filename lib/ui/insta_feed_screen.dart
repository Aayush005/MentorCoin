import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/models/like.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:instagram_clone/ui/chat_screen.dart';
import 'package:instagram_clone/ui/comments_screen.dart';
import 'package:instagram_clone/ui/insta_friend_profile_screen.dart';
import 'package:instagram_clone/ui/likes_screen.dart';
import 'package:medium_clap_flutter/medium_clap_flutter.dart';


class InstaFeedScreen extends StatefulWidget {
  @override
  _InstaFeedScreenState createState() => _InstaFeedScreenState();
}

enum ScoreWidgetStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  VISIBLE,
  BECOMING_INVISIBLE
}

class _InstaFeedScreenState extends State<InstaFeedScreen> with TickerProviderStateMixin {

  //__________________________________
  int _counter = 0;
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = new Duration(milliseconds: 400);
  final oneSecond = new Duration(seconds: 1);
  Random random;
  Timer holdTimer, scoreOutETA;
  AnimationController scoreInAnimationController, scoreOutAnimationController,
      scoreSizeAnimationController, sparklesAnimationController;
  Animation scoreOutPositionAnimation, sparklesAnimation;
  bool _isLiked = false;

  //________________________________end
  var _repository = Repository();
  User currentUser, user, followingUser;
  IconData icon;
  Color color;
  List<User> usersList = List<User>();
  Future<List<DocumentSnapshot>> _future;

  List<String> followingUIDs = List<String>();


  FixedExtentScrollController fixedExtentScrollController =
  new FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    fetchFeed();
    // addOnlineUsers();


  }


  void fetchFeed() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    followingUIDs = await _repository.fetchFollowingUids(currentUser);

    for (var i = 0; i < followingUIDs.length; i++) {
      print("DSDASDASD : ${followingUIDs[i]}");
      // _future = _repository.retrievePostByUID(followingUIDs[i]);
      this.user = await _repository.fetchUserDetailsById(followingUIDs[i]);
      print("user : ${this.user.uid}");
      usersList.add(this.user);
      print("USERSLIST : ${usersList.length}");

      for (var i = 0; i < usersList.length; i++) {
        setState(() {
          followingUser = usersList[i];
          print("FOLLOWING USER : ${followingUser.uid}");
        });
      }
    }
    _future = _repository.fetchFeed(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//

        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.blue[900],
                    Colors.purple
                  ]
              )
          ),
          child:   currentUser != null
              ? Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: postImagesWidget(),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        )

    );
  }

  Widget postImagesWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          print("FFFF : ${followingUser.uid}");
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              //shrinkWrap: true,

                itemCount: snapshot.data.length,
                itemBuilder: ((context, index) =>
                    listItem2(
                      list: snapshot.data,
                      index: index,
                      user: followingUser,
                      currentUser: currentUser,
                    )));
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





  Widget listItem2(
      {List<DocumentSnapshot> list, User user, User currentUser, int index}) {
    Timestamp date = list[index].data['time'];
    // var date2 = new DateTime.fromMillisecondsSinceEpoch(int.parse(date.toString()) * 1000);
    var date2 = date
        .toDate()
        .day;


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white, //new Color.fromRGBO(255, 0, 0, 0.0),
          borderRadius: new BorderRadius.all(
              Radius.circular(20.0)

          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        InstaFriendProfileScreen(
                                          name: list[index].data['postOwnerName'],
                                        ))));
                          },
                          child: new Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      list[index].data['postOwnerPhotoUrl'])),
                            ),
                          ),
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            InstaFriendProfileScreen(
                                              name: list[index].data['postOwnerName'],
                                            ))));
                              },
                              child: new Text(
                                list[index].data['postOwnerName'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            // list[index].data['location'] != null
                            //     ? new Text(
                            //         list[index].data['location'],
                            //         style: TextStyle(color: Colors.grey),
                            //       )
                            //     : Container(),
                          ],
                        )
                      ],
                    ),
                    FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.access_time,
                          size: 16.0,
                        ),
                        label: Text(date2.toString())

                    ),

                    // new IconButton(
                    //   icon: Icon(Icons.more_vert),
                    //   onPressed: null,
                    // )
                  ],
                ),
              ),

              CachedNetworkImage(
                imageUrl: list[index].data['imgUrl'],
                placeholder: ((context, s) =>
                    Center(
                      child: CircularProgressIndicator(),
                    )),
                width: 125.0,
                height: 250.0,
                fit: BoxFit.cover,

              ),

              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 4.0),
                child: Wrap(
//                  mainAxisSize: MainAxisSize.min,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        list[index].data['caption']),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.monetization_on),

                            onPressed: () {},
                          ),
                          Text("5")
                        ]
                    ),

                  ],
                ),
              ),





              new SizedBox(
                width: 5.0,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FutureBuilder(
                          future: _repository.fetchPostLikes(list[index].reference),
                          builder:
                          ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                            if (likesSnapshot.hasData) {
                              return GestureDetector(
                                onTap: () {

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LikesScreen(
                                                user: currentUser,
                                                documentReference: list[index].reference,
                                              ))));
                                },



                                child: GestureDetector(
                                    child: Container(
                                      height: 50.0,
                                      width:50.0,
                                      child: FittedBox(
                                          child: ClapFAB.icon(

                                            defaultIcon: FontAwesomeIcons.heart,
                                            filledIcon: FontAwesomeIcons.solidHeart,
                                            countCircleColor: Colors.redAccent,
                                            defaultIconColor: Colors.red,
                                            hasShadow: true,
                                            sparkleColor: Colors.red,
                                            shadowColor: Colors.red,
                                            filledIconColor: Colors.red,
                                            clapFabCallback: (int counter){
                                              print(counter);
                                              if (!_isLiked) {
                                                setState(() {
                                                  _isLiked = false;
                                                });
                                                // saveLikeValue(_isLiked);
                                                postLike(list[index].reference, currentUser);
                                              } else {
                                                setState(() {
                                                  _isLiked = false;
                                                });
                                                //saveLikeValue(_isLiked);
                                                postUnlike(list[index].reference, currentUser);
                                              }
                                            },

                                          )
                                      ),
                                    ),


                                    onTap: () {
//

                                    }),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                        ),




                        FutureBuilder(
                          future: _repository.fetchPostLikes(list[index].reference),
                          builder:
                          ((context,
                              AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                            if (likesSnapshot.hasData) {
                              return GestureDetector(
                                onTap: (


                                    ) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LikesScreen(
                                                user: currentUser,
                                                documentReference: list[index]
                                                    .reference,
                                              ))));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: likesSnapshot.data.length >= 1
                                      ? Container(

                                    width: 30.0,
                                    height: 30.0,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),


                                      image: new DecorationImage(

                                        ///___________________to be changed to handle if there is no like____________________________///

                                          image: new NetworkImage(

                                              likesSnapshot.data[0]
                                                  .data['ownerPhotoUrl']),

                                          fit: BoxFit.cover),


                                    ),
                                  )
                                      : Text(likesSnapshot.data.length == 1
                                      ? ""
                                      : ""),
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                        ),
                        new SizedBox(
                          width: 5.0,
                        ),

                        FutureBuilder(
                          future: _repository.fetchPostLikes(list[index].reference),
                          builder:
                          ((context,
                              AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                            if (likesSnapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LikesScreen(
                                                user: currentUser,
                                                documentReference: list[index]
                                                    .reference,
                                              ))));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: likesSnapshot.data.length >= 2
                                      ? Container(

                                    width: 30.0,
                                    height: 30.0,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),


                                      image: new DecorationImage(

                                        ///___________________to be changed to handle if there is no like____________________________///

                                          image: new NetworkImage(

                                              likesSnapshot.data[1]
                                                  .data['ownerPhotoUrl']),

                                          fit: BoxFit.cover),


                                    ),
                                  )
                                      : Text(likesSnapshot.data.length == 2
                                      ? ""
                                      : ""),
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                        ),


                        new SizedBox(
                          width: 5.0,
                        ),
                        FutureBuilder(
                          future: _repository.fetchPostLikes(list[index].reference),
                          builder:
                          ((context,
                              AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                            if (likesSnapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LikesScreen(
                                                user: currentUser,
                                                documentReference: list[index]
                                                    .reference,
                                              ))));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: likesSnapshot.data.length >= 3
                                      ? Container(

                                    width: 30.0,
                                    height: 30.0,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),


                                      image: new DecorationImage(

                                        ///___________________to be changed to handle if there is no like____________________________///

                                          image: new NetworkImage(

                                              likesSnapshot.data[3]
                                                  .data['ownerPhotoUrl']),

                                          fit: BoxFit.cover),


                                    ),
                                  )
                                      : Text(likesSnapshot.data.length == 3
                                      ? ""
                                      : ""),
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                        ),
                        new SizedBox(
                          width: 5.0,
                        ),
                        FutureBuilder(
                          future: _repository.fetchPostLikes(list[index].reference),
                          builder:
                          ((context,
                              AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
                            if (likesSnapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LikesScreen(
                                                user: currentUser,
                                                documentReference: list[index]
                                                    .reference,
                                              ))));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: likesSnapshot.data.length > 3
                                      ? GestureDetector(
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(40.0),
                                      ),
                                      child: Center(
                                        child: Text("+${(likesSnapshot.data.length -
                                            3).toString()}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  )
                                      : Text(likesSnapshot.data.length == 3
                                      ? ""
                                      : ""),
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                        ),
                        //new Icon(FontAwesomeIcons.paperPlane),
                      ],

                    ),

                    Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: commentWidget(list[index].reference))

                    //new Icon(FontAwesomeIcons.bookmark)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Divider(
                  color: Colors.white30,
                ),
              )


            ],
          ),
        ),
      ),
    );
  }


  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: FlatButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            CommentsScreen(
                              documentReference: reference,
                              user: currentUser,
                            ))));

                print("DOneeeeeeeeeeeeeeeeeeeeee");
              },
              label: Text('${snapshot.data.length} comments'),
              icon: Icon(
                Icons.mode_comment,
                color: Colors.blueAccent,
                size: 16.0,
              ),

            ),


          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  void postLike(DocumentReference reference, User currentUser) {
    var _like = Like(
        ownerName: currentUser.displayName,
        ownerPhotoUrl: currentUser.photoUrl,
        ownerUid: currentUser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(currentUser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference, User currentUser) {
    reference
        .collection("likes")
        .document(currentUser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }



}