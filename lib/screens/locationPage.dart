import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:netninja/shared/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:netninja/shared/loading.dart';
import 'package:permission/permission.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class LocationPage extends StatefulWidget {

  final String uid;
  final String docID;
  LocationPage({this.uid,this.docID});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  var rating = 0.0;

  @override
  void initState() {
    //print(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
          child: StreamBuilder(
              stream: Firestore.instance.collection('locations').document(widget.docID).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                return Loading();
                }
                return Container(
                  color: Colors.grey.withOpacity(0.1),
                  child: ListView(
                      children: <Widget>[
                        Stack(
                             children: <Widget>[
                               Container(
                                 width: 410,
                                 height: 240,
                                 decoration: BoxDecoration(
                                   image: DecorationImage(image: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/netninja-6cb94.appspot.com/o/places%2Fcity-skyline-at-sunset-vector-background1.jpg?alt=media&token=a9b67ed0-a27d-4319-a138-efc69af1b2f7'),
                                       fit: BoxFit.fill),
                                 ),
                               ),
                               Positioned(
                                  bottom: 60,
                                   left: 26,
                                   child: Text( snapshot.data['placeName'], style: TextStyle( fontWeight: FontWeight.w900, fontSize: 30, color: Colors.white, fontFamily: 'SFProText')),
                               ),
                               Positioned(
                                 bottom: 20,
                                 left: 25,
                                 child: SmoothStarRating(
                                   rating: rating,
                                   size: 23,
                                   isReadOnly: true,
                                   filledIconData: Icons.stars,
                                   defaultIconData: Icons.stars,
                                   starCount: 5,
                                   allowHalfRating: false,
                                   spacing:  0.1,
                                   borderColor: Colors.white,
                                 ),
                               ),
                               Positioned(
                                 bottom: 19,
                                 left: 152,
                                 child: Text('0', style: TextStyle( fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white, fontFamily: 'SFProText')),
                               ),
                            ],
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                  Text(  snapshot.data['placeCategory'],  style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16)),
                                  SizedBox(height: 35.0),
                                  Row(
                                      children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left: 15),
                                              child: Column(
                                                  children: <Widget>[
                                                      ClipOval(
                                                        child: Material(
                                                          color: Colors.grey.withOpacity(0.1), // button color
                                                          child: InkWell(
                                                            splashColor: Colors.red.withOpacity(0.2), // inkwell color
                                                            child: SizedBox(width: 45, height: 45, child: Icon(Icons.directions, size: 32, color: Colors.black54.withOpacity(0.7))),
                                                            onTap: () {},
                                                          ),
                                                        ),
                                                      ),
                                                    SizedBox(height: 12.0),
                                                    Text('View map',  style: TextStyle(  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54.withOpacity(0.6))),
                                                  ],
                                              ),
                                          ),
                                        Container(
                                          margin: EdgeInsets.only(left: 31),
                                          child: Column(
                                            children: <Widget>[
                                              ClipOval(
                                                child: Material(
                                                  color: Colors.grey.withOpacity(0.1), // button color
                                                  child: InkWell(
                                                    splashColor: Colors.red.withOpacity(0.2), // inkwell color
                                                    child: SizedBox(width: 45, height: 45, child: Icon(Icons.info_outline, size: 32, color: Colors.black54.withOpacity(0.7))),
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12.0),
                                              Text('More info',  style: TextStyle(  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54.withOpacity(0.6))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 32),
                                          child: Column(
                                            children: <Widget>[
                                              ClipOval(
                                                child: Material(
                                                  color: Colors.grey.withOpacity(0.1), // button color
                                                  child: InkWell(
                                                    splashColor: Colors.red.withOpacity(0.2), // inkwell color
                                                    child: SizedBox(width: 45, height: 45, child: Icon(Icons.local_activity, size: 28, color: Colors.black54.withOpacity(0.7))),
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12.0),
                                              Text('Add review',  style: TextStyle(  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54.withOpacity(0.6))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 32),
                                          child: Column(
                                            children: <Widget>[
                                              ClipOval(
                                                child: Material(
                                                  color: Colors.grey.withOpacity(0.1), // button color
                                                  child: InkWell(
                                                    splashColor: Colors.red.withOpacity(0.2), // inkwell color
                                                    child: SizedBox(width: 45, height: 45, child: Icon(Icons.share, size: 26, color: Colors.black.withOpacity(0.7))),
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 12.0),
                                              Text('Share',  style: TextStyle(  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54.withOpacity(0.6))),
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
                          padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Start a review:',  style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 10),
                              SmoothStarRating(
                                  rating: rating,
                                  size: 40,
                                  filledIconData: Icons.stars,
                                  defaultIconData: Icons.stars,
                                  starCount: 5,
                                  allowHalfRating: false,
                                  spacing:  0.1,
                                  borderColor: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text('Your feedback can help people decide',  style: TextStyle( fontSize: 13)),
                            ],
                          ),
                        ),
                        SizedBox(height: 1),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 50),
                                    child: Row(
                                      children: <Widget>[
                                        ClipOval(
                                          child: Material(
                                            color: Colors.grey.withOpacity(0.1), // button color
                                            child: InkWell(
                                              splashColor: Colors.red.withOpacity(0.2), // inkwell color
                                              child: SizedBox(width: 45, height: 45, child: Icon(Icons.camera_enhance, size: 28, color: Colors.black54.withOpacity(0.7))),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 9.0),
                                        Text('Add photo',  style: TextStyle(  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54.withOpacity(0.6))),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        ClipOval(
                                          child: Material(
                                            color: Colors.grey.withOpacity(0.1), // button color
                                            child: InkWell(
                                              splashColor: Colors.red.withOpacity(0.2), // inkwell color
                                              child: SizedBox(width: 45, height: 45, child: Icon(Icons.bookmark, size: 29, color: Colors.black54.withOpacity(0.7))),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 9.0),
                                        Text('Save',  style: TextStyle(  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54.withOpacity(0.6))),
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
                            padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Text('Photos', style: TextStyle( fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'SFProText')),
                                    SizedBox(height: 20),
                                    Container(
                                      height: 140,
                                      width: 370,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.6),
                                            width: 1
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          IconButton(
                                              icon: Icon(Icons.camera_enhance, size: 30, color: Colors.black87),
                                              onPressed: null
                                          ),
                                          Text(' Add photo', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold)),
                                        ],
                                    ),
                                  )
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
