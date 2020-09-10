import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netninja/screens/locationPage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class NearbyPlaces extends StatefulWidget {

  final String uid;
  NearbyPlaces({this.uid});

  @override
  _NearbyPlacesState createState() => _NearbyPlacesState();
}

class _NearbyPlacesState extends State<NearbyPlaces> {

  Set<Circle> circles = HashSet<Circle>();

  bool mapToggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;
  bool showRate = false;

  int docsNo = 0;
  String Sdistance = '';
  double radius1 = 50;
  double height = 90;
  double avgRate = 0.0;
  double distance = 0.0;

  var currentLocation;

  var clients = [];
  var newClients = [];

  var currentClient;
  var currentBearing;
  var filterdist;

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        getUserLocation();
        currentLocation = currloc;
        mapToggle = true;
        populateClients();
        setCircle();
      });
    });
  }

  countRate(String docID) {
    avgRate = 0;
    docsNo = 0;
    double totalRate = 0;
    double tempAvg = 0;
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
      showRate = true;
      Firestore.instance.collection('locations').document(docID).updateData({
        "avgRate": avgRate
      });
    });
  }

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

  void setCircle()  async {
    circles.add(
        Circle(
            circleId: CircleId('cir 1'),
            center: LatLng(currentLocation.latitude, currentLocation.longitude),
            strokeWidth: 0,
            radius:radius1,
            fillColor: Colors.red.withOpacity(0.3),
        )
    );
  }

  populateClients() {
    clients = [];
    Firestore.instance.collection('locations').where('verified', isEqualTo: 'Yes').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          clientsToggle = false;
          //clientsToggle = true;
        });
        for (int i = 0; i < docs.documents.length; ++i) {
          clients.add(docs.documents[i].data);
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  initMarker(client, String docID) {
    var markerIdVal = docID;
    final MarkerId markerId = MarkerId(markerIdVal);
    //markers.clear();
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(client['LatLng'].latitude, client['LatLng'].longitude),
      //infoWindow: InfoWindow(title: client['placeName'], snippet: client['category']),
      onTap: () {
          height = 90;
          showRate = false;
          countRate(docID);
          calcDistance(client['LatLng'].latitude, client['LatLng'].longitude);
          showMenu(client);
      }
    );
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  calcDistance(lat, long) {
    distance = 0;
    Sdistance = '';
    Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, lat, long).then((calDist){
        distance = calDist / 1000;
        if (distance > 0.9) {
            Sdistance = '${distance.toStringAsFixed(2)} km';
        }
        else if ( distance < 1) {
            distance = distance * 1000;
            Sdistance = '${distance.truncate().toString()} m';
        }
    });
  }

  void showMenu(client) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0)
              )
          ),
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: 250,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(30.0, 30, 30.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                  setState(() {
                                      height = height - 50;
                                      showRate = true;
                                  });
                              },
                              child: Container(
                                  child: Text(client['placeName'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'SFProText' , letterSpacing: -0.5))),
                            ),
                            SizedBox(height: 5),
                            Visibility(
                              visible: showRate,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    Text(avgRate.toString() + ' '),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 0),
                                      child: SmoothStarRating(
                                        rating: avgRate.toDouble(),
                                        size: 30,
                                        isReadOnly: true,
                                        filledIconData: Icons.stars,
                                        defaultIconData: Icons.stars,
                                        starCount: 5,
                                        allowHalfRating: false,
                                        spacing:  -2,
                                        borderColor: Colors.grey,
                                      ),
                                    ),
                                    Text(' (${docsNo.toString()} reviews)' ),
                                ],
                              ),
                            ),
                            Text(client['placeCategory'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Visibility(
                                visible: showRate,
                                child: Text(Sdistance, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87.withOpacity(0.5))),
                            ),
                            SizedBox(height: height),
                            SizedBox(
                              height: 55,
                              width: 350,
                              child: RaisedButton(
                                elevation: 0.0,
                                shape:  RoundedRectangleBorder(
                                    borderRadius:  BorderRadius.circular(3.5)),
                                color: Colors.red,
                                child: Text(  'More Details',
                                  style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                onPressed: () async {
                                  Firestore.instance.collection('histories').document().setData({
                                      "uid": widget.uid,
                                      "dateTime": DateTime.now(),
                                      "type": 'Location',
                                      "locID": client['docID'],
                                  });
                                  Navigator.pop(context);
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(docID: client['docID'])));
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                  );
                }
            );

          }
      );
  }

  Widget clientCard(client) {
    return Padding(
        padding: EdgeInsets.only(left: 3.0, right:5 , top: 5.0),
        child: InkWell(
            splashColor: Colors.red.withAlpha(30),
            onTap: () {
              setState(() {
                currentClient = client;
                currentBearing = 90.0;
              });
              zoomInMarker(client);
            },
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                  height: 60.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Column (
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(child: Text(client['placeName'], style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16))),
                        Center(child: Text(client['placeCategory'], style: TextStyle( fontWeight: FontWeight.w500, fontSize: 14)))
                      ],
                  )
              ),
            )));
  }

  zoomInMarker(client) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            client['LatLng'].latitude, client['LatLng'].longitude),
        zoom: 17.0,
        bearing: 90.0,
        tilt: 45.0)))
        .then((val) {
      setState(() {
        resetToggle = true;
      });
    });
  }

  resetCamera() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude), zoom: 13.0))).then((val) {
      setState(() {
        resetToggle = true;
      });
    });
  }

  addBearing() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentClient['LatLng'].latitude,
                currentClient['LatLng'].longitude
            ),
            bearing: currentBearing == 360.0 ? currentBearing : currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if(currentBearing == 360.0) {}
        else {
          currentBearing = currentBearing + 90.0;
        }
      });
    });
  }

  removeBearing() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentClient['LatLng'].latitude,
                currentClient['LatLng'].longitude
            ),
            bearing: currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
            zoom: 17.0,
            tilt: 45.0
        )
    )
    ).then((val) {
      setState(() {
        if(currentBearing == 0.0) {}
        else {
          currentBearing = currentBearing - 90.0;
        }
      });
    });
  }

  filterMarkers(dist){
    markers.clear();
      for(int i=0; i<clients.length; i++) {
          Geolocator().distanceBetween(currentLocation.latitude, currentLocation.longitude, clients[i]['LatLng'].latitude, clients[i]['LatLng'].longitude).then((calDist){
                //print(calDist / 1000);
                if(calDist / 1000 < double.parse(dist)) {
                    //newClients.add(clients[i].documents[i].data);
                    placeFilteredMarker(clients[i], clients[i]['docID'], calDist / 1000);
                }
          });
      }
  }

  placeFilteredMarker(client, docID, distance) {
     // markers.clear();
      var markerIdVal = docID;
      final MarkerId markerId = MarkerId(markerIdVal);
      //markers.clear();
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(client['LatLng'].latitude, client['LatLng'].longitude),
        //infoWindow: InfoWindow(title: client['placeName'], snippet: distance.toStringAsFixed(2)+ ' KM' , onTap: (){print('object');} ),
        onTap: (){
          height = 90;
          showRate = false;
          countRate(docID);
          calcDistance(client['LatLng'].latitude, client['LatLng'].longitude);
          showMenu(client);
        }
      );
      setState(() {
        // adding a new marker to map
        markers[markerId] = marker;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Find Nearby', style: TextStyle( fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: <Widget>[
              Visibility(
                  child:  IconButton(icon: Icon(Icons.refresh),
                  onPressed: () {
                    populateClients();
                    circles.clear();
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => NearbyPlaces()));
                  }
                  )),
              IconButton(icon: Icon(Icons.filter_list), onPressed: getDist)
          ],
        ),
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 90.0,
                    width: double.infinity,
                    child: mapToggle
                        ? GoogleMap(
                                onCameraIdle: () async {getMoveCamera();},
                                onMapCreated: onMapCreated,
                                zoomControlsEnabled: false,
                                markers: Set<Marker>.of(markers.values),
                                circles: circles,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(6.3693, 100.4928), zoom: 13.0),
                          )
                        : Center(
                        child: Text(
                          'Loading.. Please wait..',
                          style: TextStyle(fontSize: 20.0),
                        ))),
                Positioned(
                    top: MediaQuery.of(context).size.height - 200.0,
                    left: 10.0,
                    child: Container(
                        height: 95.0,
                        width: MediaQuery.of(context).size.width,
                        child: clientsToggle
                            ? ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(8.0),
                          children: clients.map((element) {
                            return clientCard(element);
                          }).toList(),
                        )
                            : Container(height: 1.0, width: 1.0))),
                resetToggle
                    ? Positioned(
                    top: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height -
                            50.0),
                    right: 15.0,
                    child: FloatingActionButton(
                      onPressed: resetCamera,
                      mini: true,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.gps_fixed),
                    ))
                    : Container(),
                resetToggle
                    ? Positioned(
                    top: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height -
                            50.0),
                    right: 60.0,
                    child: FloatingActionButton(
                        onPressed: addBearing,
                        mini: true,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.rotate_left
                        ))
                )
                    : Container(),
                resetToggle
                    ? Positioned(
                    top: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height -
                            50.0),
                    right: 110.0,
                    child: FloatingActionButton(
                        onPressed: removeBearing,
                        mini: true,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.rotate_right)
                    ))
                    : Container()
              ],
            )
          ],
        ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<bool> getDist() {
      return showDialog(
          context: context,
          barrierDismissible:  true,
          builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                  title: Text('Enter Distance', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  contentPadding:  EdgeInsets.only(left: 25,top: 10),
                  content: TextField(
                      decoration:  InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Distance in Kilometer'),
                      onChanged: (val) {
                            setState(() {
                              filterdist = val;
                            });
                      },
                  ),
                actions: <Widget>[
                  FlatButton(
                      color: Colors.transparent,
                      textColor: Colors.red,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text('CANCEL',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                    FlatButton(
                      color: Colors.transparent,
                        textColor: Colors.red,
                        onPressed: ()  {
                          //Navigator.pushReplacement(context, MaterialPageRoute( builder: (BuildContext context) => super.widget));
                            setState(()  {
                                circles.clear();
                                double temp = double.parse(filterdist);
                                radius1 =temp*1000;
                                setCircle();
                            });
                            filterMarkers(filterdist);
                            Navigator.of(context).pop();
//                          setState(()  {
//                            //radius = double.parse(filterdist) * 2;
//                            setCircle();
//                          });
                        },
                        child: Text('OK',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))
                ],
              );
          }
      );
  }

}
