import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:netninja/screens/drawer.dart';
import 'package:netninja/screens/locationPage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../personalInfo.dart';

class Home extends StatefulWidget {

  final String uuid ;
  Home({ this.uuid });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var clients = [];
  int docsNo = 0;
  String Sdistance = 'dude';
  int selectedNo = 0;
  double avgRate = 0;
  bool  starCount = false;
  var currentLocation;

  int selectedIndex = 0;
  List<String> categories = ['All', 'Restaurant', 'Entertainment', 'Historical Place'];

  countRate(String docID) {
    double totalRate = 0;
    double tempAvg = 0;
    //starCount = false;
    avgRate = 0;
    Firestore.instance.collection('reviews').where('locID', isEqualTo: docID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          docsNo = docsNo + 1;
          totalRate = totalRate + docs.documents[i].data['rate'].toDouble();
        }
        tempAvg = (totalRate / docsNo) ;
        if (tempAvg > 0 &&  tempAvg < 1.5) {
          avgRate = 1;
        }
        else if ( tempAvg > 1.4 && tempAvg <2.5) {
          avgRate = 2;
        }
        else if ( tempAvg > 2.4 && tempAvg < 3.5) {
          avgRate = 3;
        }
        else if ( tempAvg > 3.4 && tempAvg < 4.5) {
          avgRate = 4;
        }
        else if ( tempAvg > 4.4 && tempAvg < 5.1) {
          avgRate = 5;
        }
      }
      starCount = true;
      avgRate = 0;
    });
  }

  Future populateClients(docID) async {
    clients = [];
    await Firestore.instance.collection('locations').where('docID', isEqualTo: docID ).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          clients.add(docs.documents[i].data);
          calcDistance(docs.documents[i].data);
        }
      }
    });
  }

  Future calcDistance(clients) async{
    double distance = 0;
    Sdistance = '';
    Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, clients['LatLng'].latitude, clients['LatLng'].longitude).then((calDist){
      distance = calDist / 1000;
      if (distance > 0.9) {
        Sdistance = '${distance.toStringAsFixed(2)} km';
        //print(Sdistance);
      }
      else if ( distance < 1) {
        distance = distance * 1000;
        Sdistance = '${distance.truncate().toString()} m';
        //print(Sdistance);
      }
    });
  }

  GoogleMapController mapController;

  void getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude,position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
    //getAddress(Coordinates(position.latitude,position.longitude));
  }

  void getMoveCamera() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude
    );
  }

  @override
  void initState() {
    //populateClients();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        getUserLocation();
        currentLocation = currloc;
      });
    });
    super.initState();
//    FirebaseAuth.instance.currentUser().then(setUser);
  }

  Widget build2(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 10),
      child: SizedBox(
        height: 20,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategoryItem(index),
        ),
      ),
    );
  }

  Widget buildCategoryItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 7),
        padding: EdgeInsets.fromLTRB(7, 0,7,0.5),
        decoration: BoxDecoration(
          color:  selectedIndex == index ? Colors.red.withOpacity(0.6) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          categories[index],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.7), fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: willPopBack,
        child: Scaffold(
          drawer: MainDrawer(uid: widget.uuid),
          appBar: AppBar(
            title: Text('JomShare', style: TextStyle( fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: <Widget>[
                GestureDetector( onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute( builder: (BuildContext context) => super.widget));
                }, child: Icon(Icons.refresh, color: Colors.red,)),
            ],
          ),
          body: Column(
              children: <Widget>[
                build2(context),
                Visibility(
                  visible: selectedIndex == 0 ? true : false,
                  child: Expanded(
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('locations').where('verified', isEqualTo: 'Yes').snapshots(),
                      builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('Loading...'));
                        }
                        final List<DocumentSnapshot> document = snapshot.data.documents;
                        return new ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount:  document.length,
                            itemBuilder: (BuildContext context, int index) {
                              int count =1 + index;
                              //countRate(document[index].data['docID']);
                              String doc = document[index].data['docID'];
                              //print(doc);
                              //populateClients( doc);
                              return Container(
                                padding: EdgeInsets.fromLTRB(17, 10,17, 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: widget.uuid, docID: document[index].data['docID'])));
                                  },
                                  splashColor: Colors.red.withAlpha(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text('$count' + '. ' + document[index].data['placeName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] > 0 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setStat3) {
                                                  return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(top: 3, bottom: 3),
                                                    child: Visibility(
                                                      visible: true,
                                                      child: SmoothStarRating(
                                                        rating: document[index].data['avgRate'].toDouble(),
                                                        size: 25,
                                                        isReadOnly: true,
                                                        filledIconData: Icons.stars,
                                                        defaultIconData: Icons.stars,
                                                        starCount: 5,
                                                        allowHalfRating: false,
                                                        spacing:  -1,
                                                        borderColor: Colors.grey,
                                                        //color: Colors.black54,
                                                      ),
                                                    ),
                                                  );
                                                }
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(top: 3, bottom: 3, left: 5),
                                              child: Text( document[index].data['noReview'].toString() +  ' Reviews', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] < 1 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.info, size: 25, color: Colors.red),
                                            Container(
                                              padding: EdgeInsets.only(left: 4),
                                              child: Text('Be the first one to review this place!', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700, color: Colors.blue)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeCategory'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeAddress'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700, color: Colors.grey.withOpacity(1))),
                                      ),
                                      //Text(Sdistance),
                                      SizedBox(height: 10),
                                      Center(
                                        child: Padding(
                                          padding:EdgeInsets.symmetric(vertical:0.0),
                                          child: Container(
                                              height:1.5,
                                              width:420,
                                              color:Colors.grey.withOpacity(0.3)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedIndex == 1 ? true : false,
                  child: Expanded(
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('locations').where('verified', isEqualTo: 'Yes').where('placeCategory', isEqualTo: 'Restaurant').snapshots(),
                      builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('Loading...'));
                        }
                        final List<DocumentSnapshot> document = snapshot.data.documents;
                        return new ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount:  document.length,
                            itemBuilder: (BuildContext context, int index) {
                              int count =1 + index;
                              //countRate(document[index].data['docID']);
                              return Container(
                                padding: EdgeInsets.fromLTRB(17, 10,17, 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: widget.uuid, docID: document[index].data['docID'])));
                                  },
                                  splashColor: Colors.red.withAlpha(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text('$count' + '. ' + document[index].data['placeName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] > 0 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setStat3) {
                                                  return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(top: 3, bottom: 3),
                                                    child: Visibility(
                                                      visible: true,
                                                      child: SmoothStarRating(
                                                        rating: document[index].data['avgRate'].toDouble(),
                                                        size: 25,
                                                        isReadOnly: true,
                                                        filledIconData: Icons.stars,
                                                        defaultIconData: Icons.stars,
                                                        starCount: 5,
                                                        allowHalfRating: false,
                                                        spacing:  -1,
                                                        borderColor: Colors.grey,
                                                        //color: Colors.black54,
                                                      ),
                                                    ),
                                                  );
                                                }
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(top: 3, bottom: 3, left: 5),
                                              child: Text( document[index].data['noReview'].toString() +  ' Reviews', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] < 1 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.info, size: 25, color: Colors.red),
                                            Container(
                                              padding: EdgeInsets.only(left: 4),
                                              child: Text('Be the first one to review this place!', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700, color: Colors.blue)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeCategory'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeAddress'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700, color: Colors.grey.withOpacity(1))),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: Padding(
                                          padding:EdgeInsets.symmetric(vertical:0.0),
                                          child: Container(
                                              height:1.5,
                                              width:420,
                                              color:Colors.grey.withOpacity(0.3)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedIndex == 2 ? true : false,
                  child: Expanded(
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('locations').where('verified', isEqualTo: 'Yes').where('placeCategory', isEqualTo: 'Entertainment').snapshots(),
                      builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('Loading...'));
                        }
                        final List<DocumentSnapshot> document = snapshot.data.documents;
                        return new ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount:  document.length,
                            itemBuilder: (BuildContext context, int index) {
                              int count =1 + index;
                              //countRate(document[index].data['docID']);
                              return Container(
                                padding: EdgeInsets.fromLTRB(17, 10,17, 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: widget.uuid, docID: document[index].data['docID'])));
                                  },
                                  splashColor: Colors.red.withAlpha(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text('$count' + '. ' + document[index].data['placeName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] > 0 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setStat3) {
                                                  return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(top: 3, bottom: 3),
                                                    child: Visibility(
                                                      visible: true,
                                                      child: SmoothStarRating(
                                                        rating: document[index].data['avgRate'].toDouble(),
                                                        size: 25,
                                                        isReadOnly: true,
                                                        filledIconData: Icons.stars,
                                                        defaultIconData: Icons.stars,
                                                        starCount: 5,
                                                        allowHalfRating: false,
                                                        spacing:  -1,
                                                        borderColor: Colors.grey,
                                                        //color: Colors.black54,
                                                      ),
                                                    ),
                                                  );
                                                }
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(top: 3, bottom: 3, left: 5),
                                              child: Text( document[index].data['noReview'].toString() +  ' Reviews', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] < 1 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.info, size: 25, color: Colors.red),
                                            Container(
                                              padding: EdgeInsets.only(left: 4),
                                              child: Text('Be the first one to review this place!', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700, color: Colors.blue)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeCategory'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeAddress'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700, color: Colors.grey.withOpacity(1))),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: Padding(
                                          padding:EdgeInsets.symmetric(vertical:0.0),
                                          child: Container(
                                              height:1.5,
                                              width:420,
                                              color:Colors.grey.withOpacity(0.3)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: selectedIndex == 3 ? true : false,
                  child: Expanded(
                    child: StreamBuilder(
                      stream: Firestore.instance.collection('locations').where('verified', isEqualTo: 'Yes').where('placeCategory', isEqualTo: 'Historical Place').snapshots(),
                      builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text('Loading...'));
                        }
                        final List<DocumentSnapshot> document = snapshot.data.documents;
                        return new ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount:  document.length,
                            itemBuilder: (BuildContext context, int index) {
                              int count =1 + index;
                              //countRate(document[index].data['docID']);
                              return Container(
                                padding: EdgeInsets.fromLTRB(17, 10,17, 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: widget.uuid, docID: document[index].data['docID'])));
                                  },
                                  splashColor: Colors.red.withAlpha(30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text('$count' + '. ' + document[index].data['placeName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] > 0 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setStat3) {
                                                  return Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(top: 3, bottom: 3),
                                                    child: Visibility(
                                                      visible: true,
                                                      child: SmoothStarRating(
                                                        rating: document[index].data['avgRate'].toDouble(),
                                                        size: 25,
                                                        isReadOnly: true,
                                                        filledIconData: Icons.stars,
                                                        defaultIconData: Icons.stars,
                                                        starCount: 5,
                                                        allowHalfRating: false,
                                                        spacing:  -1,
                                                        borderColor: Colors.grey,
                                                        //color: Colors.black54,
                                                      ),
                                                    ),
                                                  );
                                                }
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(top: 3, bottom: 3, left: 5),
                                              child: Text( document[index].data['noReview'].toString() +  ' Reviews', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: document[index].data['avgRate'] < 1 ? true : false,
                                        child: Row(
                                          children: <Widget>[
                                            //Icon(Icons.info, size: 25, color: Colors.red),
                                            Container(
                                              padding: EdgeInsets.only(left: 4),
                                              child: Text('Be the first one to review this place!', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700, color: Colors.blue)),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeCategory'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 0, bottom: 3, left: 0),
                                        child: Text(' ' + document[index].data['placeAddress'], style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700, color: Colors.grey.withOpacity(1))),
                                      ),
                                      SizedBox(height: 10),
                                      Center(
                                        child: Padding(
                                          padding:EdgeInsets.symmetric(vertical:0.0),
                                          child: Container(
                                              height:1.5,
                                              width:420,
                                              color:Colors.grey.withOpacity(0.3)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      },
                    ),
                  ),
                ),
              ],
          ),
        ),
    );
  }

Future <bool> willPopBack() async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text('Do you really want to exit the application?', style: TextStyle(  fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'SFUIDisplay')),
          actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('NO', style: TextStyle(  fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'SFUIDisplay')),
              ),
            FlatButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('YES', style: TextStyle(  fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'SFUIDisplay')),
            )
          ],
      )
  );
}
}

