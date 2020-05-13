import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                    //onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => AdminUsers(uid: widget.userId))),
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
                    String name = document[index].data['name'];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(document[index].data['imageURL'])),
                        title: Text(name, style: new TextStyle(fontSize: 16, letterSpacing: 0)),
                        subtitle: Text(role, style: new TextStyle( fontWeight: FontWeight.bold,letterSpacing: 0)),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: (){},
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


