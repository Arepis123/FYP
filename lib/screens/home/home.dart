import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/drawer.dart';

class Home extends StatefulWidget {

  final String uuid ;
  Home({ this.uuid });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

//  FirebaseUser user;
//  String error;
//
//  void setUser(FirebaseUser user) {
//    setState(() {
//      this.user = user;
//      this.error = null;
//    });
//  }

  @override
  void initState() {
    super.initState();
    print('Home: your uid is ' + widget.uuid);
//    FirebaseAuth.instance.currentUser().then(setUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(uid: widget.uuid),
      appBar: AppBar(
        title: Text('JomShare', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
    );
  }



}


