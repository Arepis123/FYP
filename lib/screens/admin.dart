import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netninja/shared/constant.dart';
import 'package:netninja/shared/loading.dart';

class Admin extends StatefulWidget {

  final String userId;
  Admin({this.userId});

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 5.0),
              child: Text(
                'List of users',
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text('List of All Users'),
                    subtitle: Text('Admin & User', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => AdminUsers(uid: widget.userId))),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 5.0),
              child: Text(
                'List of new location',
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: ListTile(
                    title: Text('New Place'),
                    subtitle: Text('Name, Address, Location & Required Information', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => AdminLocation(uid: widget.userId))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminUsers extends StatefulWidget {

  final String uid;
  AdminUsers({this.uid});

  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 5.0),
              child: Text(
                'List of users',
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').orderBy('role').orderBy('name', descending: false).snapshots(),
              builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return Loading();
                }
                final List<DocumentSnapshot> document = snapshot.data.documents;
                return new ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount:  document.length,
                  itemBuilder: (BuildContext context, int index) {
                    String role = document[index].data['role'];
                    String email = document[index].data['email'];
                    String id = document[index].data['id'];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(document[index].data['imageURL'])),
                        title: Text(email, style: new TextStyle(fontSize: 16, letterSpacing: 0)),
                        subtitle: Text(role, style: new TextStyle( fontWeight: FontWeight.bold,letterSpacing: 0)),
                        trailing: id != widget.uid.toString()?  Icon(Icons.keyboard_arrow_right): null,
                        onTap: id != widget.uid.toString() ? () {
                          var datetime = document[index].data['age'];
                          DateTime date1 = document[index].data['age'].toDate();
                          DateTime date2 = DateTime.now();
                          final age = date2.difference(date1).inDays / 365 + 1;
                          changeRole(id, age.toString().substring(0,2));
                          print(age);
                        }: null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  void changeRole(String uid, String age){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0)
            )
        ),
        context: context,
        builder: (builder){
          return StreamBuilder(
            stream: Firestore.instance.collection('users').document(uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              return new Container(
                height: 300.0,
                child: new Container(
                  padding: EdgeInsets.fromLTRB(30.0, 3, 30.0, 5.0),
                  child: Column(
                    children: <Widget>[
                      //Text('User Information', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: <Widget>[
                          Column(
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              margin: EdgeInsets.only(top: 25, bottom: 7, left: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(snapshot.data['imageURL']),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topLeft,
                                  width: 220,
                                  margin: EdgeInsets.only(top:16, left: 14),
                                  child: Text(snapshot.data['name'], textAlign: TextAlign.left,style: TextStyle( fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'SFProText')),
                                ),
                                Container(
                                  width: 220,
                                  margin: EdgeInsets.only(top:4, left: 15),
                                  child: Text(snapshot.data['email'], style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  width: 220,
                                  margin: EdgeInsets.only(top:3, left: 15),
                                  child: Text(age + ' Years', style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      isScrollControlled: true
    );
  }
}

class AdminLocation extends StatefulWidget {

  final String uid;
  AdminLocation({this.uid});

  @override
  _AdminLocationState createState() => _AdminLocationState();
}

class _AdminLocationState extends State<AdminLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Users', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 5.0),
              child: Text(
                'List of users',
                style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').orderBy('role').orderBy('name', descending: false).snapshots(),
              builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return Loading();
                }
                final List<DocumentSnapshot> document = snapshot.data.documents;
                return new ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount:  document.length,
                  itemBuilder: (BuildContext context, int index) {
                    String role = document[index].data['role'];
                    String email = document[index].data['email'];
                    String id = document[index].data['id'];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(document[index].data['imageURL'])),
                        title: Text(email, style: new TextStyle(fontSize: 16, letterSpacing: 0)),
                        subtitle: Text(role, style: new TextStyle( fontWeight: FontWeight.bold,letterSpacing: 0)),
                        trailing: id != widget.uid.toString()?  Icon(Icons.keyboard_arrow_right): null,
                        onTap: id != widget.uid.toString() ? () { }: null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



