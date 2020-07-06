
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/profile.dart';
import 'package:netninja/shared/loading.dart';

class PreProfile extends StatefulWidget {

  final String userId ;
  PreProfile({ this.userId });

  @override
  _PreProfileState createState() => _PreProfileState();
}

class _PreProfileState extends State<PreProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Personal Information",style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
      child: StreamBuilder(
        stream:Firestore.instance.collection('users').document(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          return  Container(
            color: Colors.grey.withOpacity(0.1),
            child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 260,
                  padding: EdgeInsets.fromLTRB(30,30,30,30),
                  //color: Theme.of(context).primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(  'Profile',  style: TextStyle( fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'SFProText')),
                      SizedBox(height: 35.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 23),
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3, color: Colors.red),
                              image: DecorationImage(image: NetworkImage(
                                  snapshot.data['imageURL']),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Padding(
                            padding:EdgeInsets.symmetric(vertical:0.0),
                            child: Container(
                                height:130.0,
                                width:1.5,
                                color:Colors.grey.withOpacity(0.5)
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 23),
                            child: Column(
                              children: <Widget>[
                                Text(snapshot.data != null ? snapshot.data['name'] : 'New User',
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87.withOpacity(0.7))),
                                Text(snapshot.data != null ? snapshot.data['email'] : ' ', style: TextStyle(
                                    fontSize: 16, color: Colors.black87.withOpacity(0.7))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Tooltip(
                                      message: 'Number of places added',
                                      child: Container(
                                          margin: EdgeInsets.only(right: 15, top: 7, bottom: 7),
                                          width: 65,
                                          height:30 ,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.1),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.1),
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.add_location, size: 22),
                                              SizedBox(width: 5),
                                              Text(snapshot.data['noPlaceAdded'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.7))),
                                            ],
                                          )
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Numbers of review made',
                                      child: Container(
                                          width: 70,
                                          height:30 ,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.1),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.1),
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.rate_review, size: 20),
                                              SizedBox(width: 5),
                                              Text( snapshot.data['noReview'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.7))),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                SizedBox(
                                    height: 35,
                                    width: 150,
                                    child: new RaisedButton(
                                      elevation: 0.0,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(10)),
                                      color: Colors.red,
                                      child: Text(  'View Profile',
                                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold ),
                                        textAlign: TextAlign.right,
                                      ),
                                      onPressed:() => Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(userId: widget.userId))),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 500,
                  padding: EdgeInsets.fromLTRB(30,30,30,30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(  'History',  style: TextStyle( fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'SFProText')),
                        SizedBox(height: 35.0),
                      ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}

