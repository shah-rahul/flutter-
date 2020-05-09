// /import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/create_account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './pages/timeline.dart';
import './pages/upload.dart';
import './pages/activity_feed.dart';
import './pages/search.dart';
import './pages/profile.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection("users");
final timestamp = DateTime.now();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAuth = false;
  int index = 0;
  PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 2);
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((e) {
      print(e);
    });
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      setState(
        () {
          isAuth = true;
        },
      );
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  Future<void> createUserInFireStore() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();
    if (!doc.exists) {
      String userName;

      userName = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (conetext) => CreateAccount()));

      userRef.document(user.id).setData({
        "id": user.id,
        "userNAme": userName,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timeStamp": timestamp
      });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int index) {
    setState(() {
      this.index = index;
    });
  }

  onTap(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          RaisedButton(child: Text("logout"), onPressed: logout),
          //  Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.whatshot), title: Text("timeline")),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              title: Text("activity feed")),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
              ),
              title: Text("upload")),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("search")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: Text("profile")),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        selectedIconTheme: IconThemeData(
          size: 35,
        ),
        showSelectedLabels: true,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).accentColor,
        onTap: onTap,
        currentIndex: index,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Colors.pink,
              Colors.purple,
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Colors.purple,
                      Colors.pink,
                    ])),
                child: Text(
                  "Whore Market",
                  style: TextStyle(
                    fontFamily: "Bebas",
                    fontSize: 80,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => login(),
              child: Container(
                width: 260,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
