import 'dart:collection';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../my_flutter_app_icons.dart' as abjay;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:netninja/services/database.dart';
import 'package:netninja/shared/constant.dart';
import 'package:netninja/shared/dialogbox.dart';
import 'package:netninja/shared/loading.dart';
import 'package:rxdart/rxdart.dart';

class Admin extends StatefulWidget {

  final String userId;
  Admin({this.userId});

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  int countUser = 0, countLocation = 0, countNewLocation;

  countNewPlace() {
    Firestore.instance.collection('locations').getDocuments().then((docs) {
      print("${docs.documents.length}");
      int count = docs.documents.length;
      setState(() {
          countLocation = count;
      });
    });
    Firestore.instance.collection('locations').where('verified', isEqualTo: 'No').getDocuments().then((docs) {
      print("${docs.documents.length}");
      int count = docs.documents.length;
      setState(() {
        countNewLocation = count;
      });
    });
    Firestore.instance.collection('users').getDocuments().then((docs) {
      print("${docs.documents.length}");
      int count = docs.documents.length;
      setState(() {
        countUser = count;
      });
    });
  }

  @override
  void initState() {
    countNewPlace();
    super.initState();
  }

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'List of users',
                    style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                Stack(
                  children: <Widget>[
                    new Icon(Icons.notifications, color: Colors.white,),
                    new Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                            boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                )
                            ]
                          //borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: new Text(
                          '$countUser',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                ],
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 3,
                  child: InkWell(
                    splashColor: Colors.red.withAlpha(30),
                    onTap: () {},
                    child: ListTile(
                      title: Text('List of All Users'),
                      subtitle: Text('Admin & User', style: TextStyle(fontWeight: FontWeight.bold)),
                      //trailing: Icon(abjay.MyFlutterApp.crown, size: 30, color: Colors.orange),
                      trailing:  Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => AdminUsers(uid: widget.userId))),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'List of locations',
                    style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    children: <Widget>[
                      new Icon(Icons.notifications, color: Colors.white,),
                      new Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                )
                              ]
                            //borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: new Text(
                            '$countLocation',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  elevation: 3,
                  child: InkWell(
                    splashColor: Colors.red.withAlpha(30),
                    onTap: () { },
                    child: ListTile(
                      title: Text('New Place'),
                      subtitle: Text('Name, Address, Location & Required Information', style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => AdminLocation(uid: widget.userId))),
                    ),
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
        title: Text(' Users', style: TextStyle( fontWeight: FontWeight.bold)),
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
                      elevation: 3,
                      child: InkWell(
                        splashColor: Colors.red.withAlpha(30),
                        onTap: () { },
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(document[index].data['imageURL'])),
                          title: Text(email, style: new TextStyle(fontSize: 16, letterSpacing: 0)),
                          subtitle: Text(role, style: new TextStyle( fontWeight: FontWeight.bold,letterSpacing: 0)),
                          trailing: id != widget.uid.toString()?  Icon(Icons.keyboard_arrow_right): null,
                          onTap: id != widget.uid.toString() ? () {
                            var datetime = document[index].data['age'];
                            DateTime date1 = document[index].data['age'].toDate();
                            DateTime date2 = DateTime.now();
                            final age = date2.difference(date1).inDays / 365 ;
                            changeRole(id, age.truncate().toString().substring(0,2));
                          }: null,
                        ),
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
                height: 250,
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
                                margin: EdgeInsets.only(top: 35, bottom: 7, left: 10),
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
                                  margin: EdgeInsets.only(top:26, left: 14),
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
                      const SizedBox(height: 24.0),
                      Visibility(
                        visible: (snapshot.data['role'].toString() == 'User')? true: false,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                                height: 55,
                                width: 330,
                                child:  RaisedButton(
                                  elevation: 0.0,
                                  shape:  RoundedRectangleBorder(
                                      borderRadius:  BorderRadius.circular(3.5)),
                                  color: Colors.red,
                                  child: Stack(
                                    children: <Widget>[
                                        Positioned(
                                                right: 30,
                                                top: 11,
                                                child: Container(
                                                    child: Icon(abjay.MyFlutterApp.crown, size: 27, color: Color(0xFFFFE595)),
                                                ),
                                        ),
                                      Positioned(
                                        left: 30,
                                        top: 16,
                                        child: Container(
                                          child: Text(  'Upgrade User to Admin',
                                            style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    Firestore.instance.collection('users').document(uid).updateData({
                                      'role': 'Admin',
                                    })
                                        .whenComplete((){
                                      print('Role Updated');
                                      Navigator.pop(context);
                                    });
                                  },
                                )
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: (snapshot.data['role'].toString() == 'Admin' )? true: false,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                                height: 55,
                                width: 330,
                                child: new RaisedButton(
                                  elevation: 0.0,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(3.5)),
                                  color: Colors.red,
                                  child: Text(  'Downgrade Admin to User',
                                    style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold ),
                                    textAlign: TextAlign.right,
                                  ),
                                  onPressed: () async {
                                    Firestore.instance.collection('users').document(uid).updateData({
                                      'role': 'User',
                                    })
                                        .whenComplete((){
                                      print('Role Updated');
                                      Navigator.pop(context);
                                    });
                                  },
                                )
                            ),
                          ],
                        ),
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

GoogleMapController mapController;
List<Marker> allMarkers = [];

class _AdminLocationState extends State<AdminLocation> {

  int countUser = 0, countLocation = 0, countNewLocation = 0;

  countNewPlace() {
    Firestore.instance.collection('locations').getDocuments().then((docs) {
      int count = docs.documents.length;
      setState(() {
        countLocation = count;
      });
    });
    Firestore.instance.collection('locations').where('verified', isEqualTo: 'No').getDocuments().then((docs) {
      int count = docs.documents.length;
      setState(() {
        countNewLocation = count;
      });
    });
    Firestore.instance.collection('users').getDocuments().then((docs) {
      int count = docs.documents.length;
      setState(() {
        countUser = count;
      });
    });
  }

  @override
  void initState() {
    countNewPlace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Location', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'List of new locations',
                    style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Stack(
                    children: <Widget>[
                      new Icon(Icons.notifications, color: Colors.white,),
                      new Positioned(
                        right: 0,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                )
                              ]
                            //borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: new Text(
                            '$countNewLocation',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: StreamBuilder(
              stream: Firestore.instance.collection('locations').where('verified', isEqualTo: 'No').snapshots(),
              builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return Center(child: Text('Loading...'));
                }
                final List<DocumentSnapshot> document = snapshot.data.documents;
                return new ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount:  document.length,
                  itemBuilder: (BuildContext context, int index) {
                    String placeName = document[index].data['placeName'];
                    String id = document[index].data['id'];
                    String name = document[index].data['name'];
                    String docID = document[index].data['docID'];
                    return Card(
                      elevation: 3,
                      color: Colors.white,
                      child: InkWell(
                        splashColor: Colors.red.withAlpha(30),
                        onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => AdminLocationProfile(uid: id, docID: docID)));},
                        onLongPress: () {
                          setState(() {
                            setMarkers(id,docID);
                          });
                          mapView(id,docID);
                          } ,
                        child: Column(
                          children: <Widget>[
                            Visibility(
                              visible:  document[index].data['id'] == id ? true : false,
                              child: FutureBuilder(
                                future: Firestore.instance.collection('users').where('id', isEqualTo: id).getDocuments(),
                                builder: (BuildContext context, AsyncSnapshot snap) {
                                  if(!snap.hasData) {
                                    return Center(child: Text('Loading...'));
                                  }
                                  return Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: CircleAvatar(backgroundImage: NetworkImage(snap.data.documents.toList()[0].data['imageURL'])),
                                        title: Text(snap.data.documents.toList()[0].data['email'], style: new TextStyle(fontSize: 16, letterSpacing: 0)),
                                        subtitle: Text(snap.data.documents.toList()[0].data['name'], style: new TextStyle( fontWeight: FontWeight.bold,letterSpacing: 0)),
                                      ),
                                      Divider(color: Colors.grey.withOpacity(0.7), indent: 20, endIndent: 20, height: 2, thickness: 0.5),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 10,10, 5),
                              child: Row(
                                children: <Widget>[
                                  Text('Category  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  Text(document[index].data['placeCategory'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0,10, 5),
                              child: Row(
                                children: <Widget>[
                                  Text('Name  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  Text(document[index].data['placeName'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 0,10, 15),
                              alignment: Alignment.topLeft,
                              child: RichText(
                                  text: TextSpan(text: 'Address  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'SFUIDisplay'),
                                      children: <TextSpan> [
                                          TextSpan(text: document[index].data['placeAddress'], style: TextStyle(fontSize: 15, color: Colors.black54,  fontFamily: 'SFUIDisplay'))
                                      ]
                                  )
                              )
                            ),
                          ],
                        ),
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

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  setMarkers(String uid, String docID) {
    Firestore.instance.collection('locations').where('docID', isEqualTo: docID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        String name = '';
        for (int i=0; i<docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
          String name = docs.documents[i].data['placeName'];
        }
      }
    });
  }

  void initMarker(data, docID) {
    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data['LatLng'].latitude, data['LatLng'].longitude),
      infoWindow: InfoWindow(title: data['placeName'], snippet: data['category']),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void mapView(String uid, String docID){
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
            stream: Firestore.instance.collection('locations').document(docID).snapshots(),
            builder: (context,  snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              return new Container(
                  height: 400,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 30.0,30),
                    child:
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3.5), border: Border.all(width: 2, color: Colors.red.withOpacity(0.5))),
                          child: Stack(
                            children: [
                              SizedBox(
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(snapshot.data['LatLng'].latitude,snapshot.data['LatLng'].longitude),
                                    zoom: 17,
                                  ),
                                  onMapCreated: _onMapCreated,
                                  mapType:MapType.normal,
                                  zoomControlsEnabled: false,
                                  markers: Set<Marker>.of(markers.values),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: SizedBox(
                                    height: 55,
                                    width: 351,
                                    child: new RaisedButton(
                                      elevation: 0.0,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(3.5)),
                                      color: Colors.red,
                                      child: Text(  'Verify',
                                        style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold ),
                                        textAlign: TextAlign.right,
                                      ),
                                      onPressed: () async {
                                        Firestore.instance.collection('locations').document(docID).updateData({
                                          'verified': 'Yes',
                                        })
                                            .whenComplete((){
                                          print('Verify Updated');
                                          Navigator.pop(context);
                                        });
                                      },
                                    )
                                ),
                              ),
                            ],
                          ),
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

class AdminLocationProfile extends StatefulWidget {

  final String uid;
  final String docID;
  AdminLocationProfile({this.uid,this.docID});

  @override
  _AdminLocationProfileState createState() => _AdminLocationProfileState();
}

class _AdminLocationProfileState extends State<AdminLocationProfile> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String placeName = '', placeAddress = '', placeCategory = '', placeHours = '', placePhone = '', placeNotes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Location Details",style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
            IconButton(
                icon: Icon(Icons.map),
                tooltip: 'view map',
                iconSize: 26,
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => AdminLocationMap(userid: widget.uid, docID: widget.docID )));
                },
            )
        ],
      ),
      body: SingleChildScrollView(
          child: StreamBuilder(
              stream: Firestore.instance.collection('locations').document(widget.docID).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                }
                return Container(
                  padding: EdgeInsets.fromLTRB(20.0, 30.0,20.0, 5.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              readOnly:true,
                              initialValue: snapshot.data['placeName'],
                              onChanged: (text) {
                                setState((){
                                  placeName = text;
                                });
                              },
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                hintText: 'Name',
                                labelText: 'Name',
                                labelStyle: TextStyle(color: Colors.red, fontSize: 17.0),
                                hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              readOnly:true,
                              initialValue: snapshot.data['placeAddress'],
                              onChanged: (text) {
                                setState((){
                                  placeCategory = text;
                                });
                              },
                              //minLines: 2,
                              maxLines: 3,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                hintText: 'Address',
                                labelText: 'Address' ,
                                labelStyle: TextStyle(color: Colors.red, fontSize: 17.0),
                                hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              readOnly:true,
                              initialValue: snapshot.data['placeCategory'],
                              onChanged: (text) {
                                setState((){
                                  placeCategory = text;
                                });
                              },
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                hintText: 'Category',
                                labelText: 'Category' ,
                                labelStyle: TextStyle(color: Colors.red, fontSize: 17.0),
                                hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              readOnly:true,
                              initialValue: snapshot.data['placeHours'],
                              onChanged: (text) {
                                setState((){
                                  placeHours = text;
                                });
                              },
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                hintText: 'Hours',
                                labelText: 'Hours' ,
                                labelStyle: TextStyle(color: Colors.red, fontSize: 17.0 ),
                                hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              readOnly:true,
                              initialValue: snapshot.data['placePhone'],
                              onChanged: (text) {
                                setState((){
                                  placeHours = text;
                                });
                              },
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                hintText: 'Phone',
                                labelText: 'Phone' ,
                                labelStyle: TextStyle(color: Colors.red, fontSize: 17.0 ),
                                hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              readOnly:true,
                              initialValue: snapshot.data['placeNotes'],
                              onChanged: (text) {
                                setState((){
                                  placeNotes= text;
                                });
                              },
                              maxLines: 4,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                hintText: 'Notes',
                                labelText: 'Notes' ,
                                labelStyle: TextStyle(color: Colors.red, fontSize: 17.0 ),
                                hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ButtonTheme(
                                  height: 55,
                                  minWidth: 370,
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(2.0),
                                        side: BorderSide(color: Colors.red)),
                                    onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => AdminLocationEdit( uid: widget.uid, uid2: snapshot.data['id'], docID: widget.docID,name: snapshot.data['placeName'], address: snapshot.data['placeAddress'], category: snapshot.data['placeCategory'], hour: snapshot.data['placeHours'], phone: snapshot.data['placePhone'], notes: snapshot.data['placeNotes'])));
                                    },
                                    color: Colors.red,
                                    //textColor: Colors.white,
                                    child: Text("Edit",
                                        style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold )),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ButtonTheme(
                                  height: 55,
                                  minWidth: 370,
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(2.0),
                                        side: BorderSide(color: Colors.red)),
                                    onPressed: () async {
                                      Firestore.instance.collection('notifications').document().setData({
                                        "dateTime": DateTime.now(),
                                        "id": snapshot.data['id'],
                                        "placeName": snapshot.data['placeName'],
                                        "text": 'Your request has been verified',
                                      });
                                      Firestore.instance.collection('locations').document(widget.docID).updateData({
                                        'verified': 'Yes',
                                      })
                                          .whenComplete((){
                                        print('Location Verify');
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute( builder: (BuildContext context) => super.widget));
                                      });
                                    },
                                    color: Colors.red,
                                    //textColor: Colors.white,
                                    child: Text("Verify",
                                        style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold )),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ButtonTheme(
                                  height: 55,
                                  minWidth: 370,
                                  child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(2.0),
                                        side: BorderSide(color: Colors.red)),
                                    onPressed: () async {
                                      Firestore.instance.collection('locations').document(widget.docID).delete()
                                          .whenComplete((){
                                        print('Location Deleted');
                                        Navigator.pop(context);
                                      });
                                    },
                                    color: Colors.red,
                                    //textColor: Colors.white,
                                    child: Text("Delete",
                                        style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold )),
                                  ),
                                )
                              ],
                            ),
                          ],
                      ),
                  ),
                );
              }
          ),
      ),
    );
  }
}

class AdminLocationMap extends StatefulWidget {

  final String userid ;
  final String docID;
  AdminLocationMap({this.docID,this.userid});

  @override
  _AdminLocationMapState createState() => _AdminLocationMapState();
}

class _AdminLocationMapState extends State<AdminLocationMap> {

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  setMarkers() {
    Firestore.instance.collection('locations').where('docID', isEqualTo: widget.docID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(data, docID) {
    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data['LatLng'].latitude, data['LatLng'].longitude),
      infoWindow: InfoWindow(title: data['placeName'], snippet: data['category']),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    setMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('locations').document(widget.docID).snapshots(),
        builder:(context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
           return  Stack(
             children: <Widget>[
               GoogleMap(
                 initialCameraPosition: CameraPosition(
                   target: LatLng(snapshot.data['LatLng'].latitude,snapshot.data['LatLng'].longitude),
                   zoom: 17,
                 ),
//              onCameraIdle: () async {
//                buscando = true;
//                getMoveCamera();
//              },
                 //onMapCreated: _onMapCreated,
                 //mapType: currentMapType,
                 //onCameraMove: onCameraMove ,
                 zoomControlsEnabled: false,
                 markers: Set<Marker>.of(markers.values),
               ),
             ],
           );
        },
      ),
    );
  }
}

class AdminLocationMapEdit extends StatefulWidget {

  final String userId ;
  final String docID;
  AdminLocationMapEdit({this.docID,this.userId});

  @override
  _AdminLocationMapEditState createState() => _AdminLocationMapEditState();
}

class _AdminLocationMapEditState extends State<AdminLocationMapEdit> {

  CameraPosition _position = _kInitialPosition;
  MapType currentMapType  = MapType.normal;
  final Geolocator geolocator1 = Geolocator();                                         // new
  GoogleMapController mapController;
  List<Marker> allMarkers = [];
  LatLng currentLocation = LatLng(24.150, -110.32);
  LatLng get initialPos => currentLocation;
  Location location1 = new Location();
  LocationData currentLocationData1;                                                               // new
  Position currentPosition1;                                                                                              // new
  BitmapDescriptor icon;
  String address = '';                                                                                                                 // new
  bool buscando = false;

  setMarker() {
    return allMarkers;
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.5),
        "assets/images/marker2.png");
    setState(() {
      this.icon = icon;
    });
  }


  void getMoveCamera() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude
    );
  }

  void getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude,position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));

  }

  void onCameraMove(CameraPosition position) async {
    buscando = false;
    currentLocation = position.target;
  }

  void onCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onMapTypePressed() {
    setState(() {
      currentMapType = currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }

  Firestore firestore = Firestore.instance;
//  Geoflutterfire geo = Geoflutterfire();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  setMarkers() {
    Firestore.instance.collection('locations').where('docID', isEqualTo: widget.docID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(data, docID) {
    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(data['LatLng'].latitude, data['LatLng'].longitude),
      infoWindow: InfoWindow(title: data['placeName'], snippet: data['category']),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    //getIcons();
    setMarkers();
    getUserLocation();
    super.initState();
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(24.150, -110.32),
    zoom: 10,
  );

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Location', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(24.142, -110.321),
              zoom: 17,
            ),
            onCameraIdle: () async {
              buscando = true;
              getMoveCamera();
            },
            onMapCreated: _onMapCreated,
            mapType: currentMapType,
            onCameraMove: onCameraMove ,
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(markers.values),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/marker.png', height: 50),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Color(0xFFe3dfdf),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: <Widget>[
                        Text('Move the map until the pin is directly over ', style: TextStyle(fontSize: 15)),
                        Text('Test', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width /26,
              child: ButtonTheme(
                height: 55,
                minWidth: 300,
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(3.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: _updateGeoPoint,
                  color: Colors.red,
                  //textColor: Colors.white,
                  child: Text("Replace Location",
                      style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold )),
                ),
              )
          ),
          Positioned(
              bottom: 20,
              right: MediaQuery.of(context).size.width /26,
              child: ButtonTheme(
                height: 55,
                minWidth: 60,
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed:onMapTypePressed,
                    color: Colors.red,
                    //textColor: Colors.white,
                    child:  Icon(Icons.map, color: Colors.white, size: 35)
                ),
              )
          ),
        ],
      ),
    );
  }

  Future  _updateGeoPoint() async {
    DocumentReference docRef =  Firestore.instance.collection('locations').document(widget.docID);
    docRef.updateData({
      "LatLng": new GeoPoint(currentLocation.latitude, currentLocation.longitude)
    })
        .whenComplete(() {
      print('Geolocation Added');
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Center(child: Text('Location Added', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            );
          });
    });
//      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//      sharedPrefs.setString('long', currentLocation.longitude.toString());
//      sharedPrefs.setString('latit', currentLocation.latitude.toString());
  }

}


class AdminLocationEdit extends StatefulWidget {

  final String uid;
  final String uid2;
  final String docID;
  final String name;
  final String address;
  final String category;
  final String hour;
  final String phone;
  final String notes;
  AdminLocationEdit({ this.uid, this.uid2, this.docID, this.name, this.address, this.category, this.hour, this.phone, this.notes});

  @override
  _AdminLocationEditState createState() => _AdminLocationEditState();
}

class _AdminLocationEditState extends State<AdminLocationEdit> {

  TextEditingController nameController, addressController, categoryController, hourController, phoneController, noteController, remarkController ;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
      nameController = new TextEditingController(text: widget.name);
      addressController = new TextEditingController(text: widget.address);
      categoryController = new TextEditingController(text: widget.category);
      hourController = new TextEditingController(text: widget.hour);
      phoneController = new TextEditingController(text: widget.phone);
      noteController = new TextEditingController(text: widget.notes);
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Location Details', style: TextStyle( fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit_location),
              tooltip: 'view map',
              iconSize: 26,
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => AdminLocationMapEdit(userId: widget.uid, docID: widget.docID )));
              },
            )
          ],
        ),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 30.0,20.0, 5.0),
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: nameController,
                        maxLines: 1,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Name',
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.red, fontSize: 17.0),
                          hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: addressController,
                        maxLines: 3,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Address',
                          labelText: 'Address' ,
                          labelStyle: TextStyle(color: Colors.red, fontSize: 17.0),
                          hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: categoryController,
                        maxLines: 1,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Category',
                          labelText: 'Category' ,
                          labelStyle: TextStyle(color: Colors.red, fontSize: 17.0),
                          hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: hourController,
                        maxLines: 1,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Hours',
                          labelText: 'Hours' ,
                          labelStyle: TextStyle(color: Colors.red, fontSize: 17.0 ),
                          hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: phoneController,
                        maxLines: 1,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Phone',
                          labelText: 'Phone' ,
                          labelStyle: TextStyle(color: Colors.red, fontSize: 17.0 ),
                          hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        controller: noteController,
                        maxLines: 3,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
//                                      fillColor: Colors.grey.withOpacity(0.12),
//                                      filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                                style: BorderStyle.solid
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          hintText: 'Notes',
                          labelText: 'Notes' ,
                          labelStyle: TextStyle(color: Colors.red, fontSize: 17.0 ),
                          hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonTheme(
                            height: 55,
                            minWidth: 370,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(2.0),
                                  side: BorderSide(color: Colors.red)),
                              onPressed: () async {
                                final action = await DialogBox.yesAbortDialog(context, 'Update Location Details', 'Are you sure you want to update the details?');
                                 if (action == DialogAction.yes) {
                                      DatabaseService().updateLocation1(widget.docID, nameController.text, addressController.text, categoryController.text, hourController.text, phoneController.text, noteController.text);
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 1), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              title: Center(child: Text('Update Success', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                            );
                                          });
                                 };
                                //Navigator.push(context,MaterialPageRoute(builder: (context) => AdminLocationEdit(name: snapshot.data['placeName'], address: snapshot.data['placeAddress'], category: snapshot.data['placeCategory'], hour: snapshot.data['placeHours'], phone: snapshot.data['placePhone'], notes: snapshot.data['placeNotes'])));
                              },
                              color: Colors.red,
                              //textColor: Colors.white,
                              child: Text("Save",
                                  style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold )),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ButtonTheme(
                            height: 55,
                            minWidth: 370,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(2.0),
                                  side: BorderSide(color: Colors.red)),
                              onPressed: () async {
                                final action = await DialogBox.yesAbortDialog(context, 'Update Location Details', 'Are you sure you want to update the details?');
                                if (action == DialogAction.yes) {
                                  Firestore.instance.collection('notifications').document().setData({
                                    "dateTime": DateTime.now(),
                                    "id": widget.uid2,
                                    "placeName": nameController.text,
                                    "text": 'Your request has been verified',
                                  });
                                  DatabaseService().updateLocation2(widget.docID, widget.uid2, nameController.text, addressController.text, categoryController.text, hourController.text, phoneController.text, noteController.text);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  //Navigator.pushReplacement(context, MaterialPageRoute( builder: (BuildContext context) => super.widget));
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(Duration(seconds: 1), () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          title: Center(child: Text('Update Success', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                        );
                                      });
                                };
                              },
                              color: Colors.red,
                              //textColor: Colors.white,
                              child: Text("Save and Verify",
                                  style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold )),
                            ),
                          )
                        ],
                      ),
                    ],
                ),
            ),
          ),
      ),
    );
  }
}
