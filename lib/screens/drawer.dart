import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/profile.dart';
import 'package:netninja/screens/request.dart';
import 'package:netninja/services/auth.dart';

class MainDrawer extends StatefulWidget {

  final String uid ;
  MainDrawer({ this.uid });

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  final AuthService _auth = AuthService();

//  FirebaseAuth auth = FirebaseAuth.instance;
//
//  String userid = '';
//
//  getUID() async {
//    final FirebaseUser user = await auth.currentUser();
//    final uid = user.uid;
//    userid = uid;
//    //return  uid;
//  }

  // final documentId = await getUID();

//  final FirebaseAuth auth = FirebaseAuth.instance;
//  getCurrentUser() async {
//      final FirebaseUser user = await auth.currentUser();
//      final uid = user.uid;
//      final uemail = user.email;
//      //userid = uid;
//      print(uid);
//      print(uemail);
//  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: Center(
                  child: StreamBuilder(
                      stream:Firestore.instance.collection('users').document(widget.uid).snapshots(),
                      builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                                return new Text('Loading, please wait...');
                          }
                        return Column(
                            children: <Widget>[
                                Container(
                                    width: 100,
                                    height:  100,
                                    margin: EdgeInsets.only(top: 30, bottom: 10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQsKNbGtuXiKKlaS0oDJ72NksP7CS-tl7YInR67NXNTgfvTfkXk&usqp=CAU'),
                                            fit: BoxFit.fill),
                                     ),
                                ),
                              Text(snapshot.data != null ? snapshot.data['name'] : 'New User', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(snapshot.data != null ? snapshot.data['email'] : ' ', style: TextStyle(fontSize: 15, color: Colors.white)),
                          ],
                        );
                      }
                  )
              ),
            ),
            Text(''),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.red),
              title: Text('Profile', style: TextStyle( fontSize: 19,fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(userId: widget.uid)));
              },
            ),
            ListTile(
              leading: Icon(Icons.watch_later, color: Colors.red),
              title: Text('History', style: TextStyle( fontSize: 19,fontWeight: FontWeight.bold)),
              onTap:() {},
            ),
            ListTile(
              leading: Icon(Icons.add_circle, color: Colors.red),
              title: Text('Request', style: TextStyle( fontSize: 19,fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context) => Request()));
              },
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.red),
              title: Text('Bookmark', style: TextStyle( fontSize: 19,fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review, color: Colors.red),
              title: Text('Write Review', style: TextStyle( fontSize: 19,fontWeight: FontWeight.bold)),
              onTap: () {
                print(widget.uid);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.power_settings_new, color: Colors.red),
              title: Text('Log Out', style: TextStyle( fontSize: 19,fontWeight: FontWeight.bold)),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

