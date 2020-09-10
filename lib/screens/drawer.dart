
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/admin.dart';
import 'package:netninja/screens/bookmark.dart';
import 'package:netninja/screens/history.dart';
import 'package:netninja/screens/locationPage.dart';
import 'package:netninja/screens/nearbyplaces.dart';
import 'package:netninja/screens/personalInfo.dart';
import 'package:netninja/screens/profile.dart';
import 'package:netninja/screens/request.dart';
import 'package:netninja/services/auth.dart';
import 'package:netninja/shared/loading.dart';
import 'package:netninja/screens/noti.dart';
import 'package:netninja/uploadImages.dart';


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
                                                 margin: EdgeInsets.only(top: 23, bottom: 7),
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
                                                   fontSize: 16, color: Colors.white)),
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
                                       MaterialPageRoute(builder: (context) => PreProfile(
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
                                 onTap: () {
                                   Navigator.pop(context);
                                   //Navigator.push(context, MaterialPageRoute(builder: (context) => Noti(uid: widget.uid)));
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => History(uid: widget.uid)));
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
                                   Navigator.push(context,
                                       MaterialPageRoute(builder: (context) => Bookmark(uid: widget.uid)));
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(Icons.book, color: Colors.red, size: 28),
                                 title: Text(' Notification', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {
                                   Navigator.pop(context);
                                   Navigator.push(context,
                                       MaterialPageRoute(builder: (context) => Noti(uid: widget.uid)));
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(Icons.add_circle, color: Colors.red, size: 28),
                                 title: Text(' Add New Place', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {
                                   Navigator.pop(context);
                                   Navigator.push(context,
                                       MaterialPageRoute(builder: (context) => Request(uid: widget.uid)));
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 4, horizontal: 30),
                                 leading: Icon(
                                     Icons.find_in_page, color: Colors.red, size: 28),
                                 title: Text(' Find Nearby Places', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () {
                                   print(widget.uid);
                                   Navigator.pop(context);
                                   Navigator.push(context,
                                       MaterialPageRoute(builder: (context) => NearbyPlaces(uid: widget.uid)));
                                 },
                               ),
                               ListTile(
                                 contentPadding: EdgeInsets.symmetric(
                                     vertical: 7, horizontal: 30),
                                 leading: Icon(
                                     Icons.power_settings_new, color: Colors.red, size: 28),
                                 title: Text(' Log Out', style: TextStyle(
                                     fontSize: 18, fontWeight: FontWeight.w900)),
                                 onTap: () async {
                                   Navigator.pop(context);
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

