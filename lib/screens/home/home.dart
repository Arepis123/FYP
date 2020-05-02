import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netninja/models/newuser.dart';
import 'package:netninja/screens/drawer.dart';
import 'package:netninja/services/auth.dart';
import 'package:netninja/services/crud.dart';
import 'package:netninja/services/database.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseUser user;
  String error;

  void setUser(FirebaseUser user) {
    setState(() {
      this.user = user;
      this.error = null;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then(setUser);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(uid: user.uid),
      appBar: AppBar(
        title: Text('JomShare'),
        centerTitle: true,
        elevation: 0.0,
      ),
    );
  }



}


