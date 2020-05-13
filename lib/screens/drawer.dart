
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/admin.dart';
import 'package:netninja/screens/profile.dart';
import 'package:netninja/screens/request.dart';
import 'package:netninja/services/auth.dart';
import 'package:netninja/shared/loading.dart';

class MainDrawer extends StatefulWidget {

  final String uid ;
  MainDrawer({ this.uid });

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
      return Drawer(
          child: SingleChildScrollView(
                child: StreamBuilder(
                    stream:Firestore.instance.collection('users').document(widget.uid).snapshots(),
                     builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                          return Loading();
                      }
                          return Column(
                             children: <Widget>[
                               Container(
                                 width: double.infinity,
                                 padding: EdgeInsets.all(35),
                                 color: Theme
                                     .of(context)
                                     .primaryColor,
                                    child: Center(
                                           child: Column(
                                             children: <Widget>[
                                               Container(
                                                 width: 110,
                                                 height: 110,
                                                 margin: EdgeInsets.only(top: 30, bottom: 10),
                                                 decoration: BoxDecoration(
                                                   shape: BoxShape.circle,
                                                   image: DecorationImage(image: NetworkImage(
                                                       snapshot.data['imageURL']),
                                                       fit: BoxFit.fill),
                                                 ),
                                               ),
                                               Text(snapshot.data != null ? snapshot
                                                   .data['name'] : 'New User',
                                                   style: TextStyle(fontSize: 21,
                                                       fontWeight: FontWeight.w700,
                                                       color: Colors.white)),
                                               Text(snapshot.data != null ? snapshot
                                                   .data['email'] : ' ', style: TextStyle(
                                                   fontSize: 15, color: Colors.white)),
                                             ],
                                           ),
                                 ),
                               ),
                               Text(''),
                               Visibility(
                                 visible:  snapshot.data['role'] == 'Admin' ? true : false,
                                 child: ListTile(
                                   contentPadding: EdgeInsets.symmetric(
                                       vertical: 4, horizontal: 30),
                                   leading: Icon(
                                       Icons.supervised_user_circle, color: Colors.red,
                                       size: 28),
                                   title: Text(' Admin', style: TextStyle(
                                       fontSize: 18, fontWeight: FontWeight.w900)),
                                   onTap: () {
                                     Navigator.of(context).pop();
                                     Navigator.push(context,MaterialPageRoute(builder: (context) => Admin(userId: widget.uid)));
                                   },
                                 ),
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(
                                     Icons.account_circle, color: Colors.red, size: 28),
                                 title: Text(' Profile', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {
                                   Navigator.of(context).pop();
                                   Navigator.push(context,
                                       MaterialPageRoute(builder: (context) => Profile(
                                           userId: widget.uid)));
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(
                                     Icons.watch_later, color: Colors.red, size: 28),
                                 title: Text(' History', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {},
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(Icons.add_circle, color: Colors.red, size: 28),
                                 title: Text(' Request', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {
                                   Navigator.pop(context);
                                   Navigator.push(context,
                                       MaterialPageRoute(builder: (context) => Request()));
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(Icons.book, color: Colors.red, size: 28),
                                 title: Text(' Bookmark', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {
                                   Navigator.pop(context);
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(
                                     Icons.rate_review, color: Colors.red, size: 28),
                                 title: Text(' Write Review', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {
                                   print(widget.uid);
                                   Navigator.pop(context);
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(
                                     Icons.power_settings_new, color: Colors.red, size: 28),
                                 title: Text(' Log Out', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () async {
                                   await _auth.signOut();
                                 },
                               ),
                             ],
               );
             },
        ),
      ),
    );
  }
}

