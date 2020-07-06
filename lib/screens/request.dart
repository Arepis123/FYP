import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:netninja/shared/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home.dart';
import 'locationPage.dart';

class Request extends StatefulWidget {

  final String uid ;
  Request({ this.uid});

  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {

  final formKey = GlobalKey<FormState>();

  String placeName = '', placeAddress = '', placeCategory = '', placeHours = '', placePhone = '', placeNotes = '';
  String _selectedType;
  String documentID;
  List <String> genderList = <String> ['Park','Restaurant','Auto Service','Historical Place'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Place' , style: TextStyle( fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding:  EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 15.0),
                        Text('Name' , style: TextTitle1),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: CustOutlineInputBorder,
                            focusedErrorBorder: CustOutlineInputBorder,
                            enabledBorder: CustOutlineInputBorder,
                            focusedBorder: CustOutlineInputBorder,
                            hintText: 'Mamak MU',
                            hintStyle: TextHint1,
                          ),
                          validator: (val) => val.length < 3 ? 'Please enter a valid name' : null,
                          onChanged: (val) {
                            setState(() => placeName = val);
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Text('Address' , style: TextTitle1),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: CustOutlineInputBorder,
                            focusedErrorBorder: CustOutlineInputBorder,
                            enabledBorder: CustOutlineInputBorder,
                            focusedBorder: CustOutlineInputBorder,
                            hintText: 'Jalan M/J3, Sungai Chua, Kajang',
                            hintStyle: TextHint1,
                          ),
                          onChanged: (val) {
                            setState(() => placeAddress = val);
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Text('Category' , style: TextTitle1),
                        const SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.all(0.2),                                                                                        // spacing outside border
                          padding: EdgeInsets.symmetric(horizontal: 15),                              // spacing inside border
                          //padding: EdgeInsets.symmetric(horizontal: 73, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3.5),
                            border: Border.all(
                                color: Colors.red,style: BorderStyle.solid, width: 1.5),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text('Restaurant', style: TextHint1),
                            value: _selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedType = newValue;
                                placeCategory = _selectedType;
                              });
                            },
                            items: genderList.map((jantina) {
                              return DropdownMenuItem(
                                child: new Text(jantina),
                                value: jantina,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text('Hours' , style: TextTitle1),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: CustOutlineInputBorder,
                            focusedErrorBorder: CustOutlineInputBorder,
                            enabledBorder: CustOutlineInputBorder,
                            focusedBorder: CustOutlineInputBorder,
                            hintText: 'Mon-Fri 9am -6pm, Sat 11am-8pm',
                            hintStyle: TextHint1,
                          ),
                          onChanged: (val) {
                            setState(() => placeHours = val);
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Text('Phone' , style: TextTitle1),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: CustOutlineInputBorder,
                            focusedErrorBorder: CustOutlineInputBorder,
                            enabledBorder: CustOutlineInputBorder,
                            focusedBorder: CustOutlineInputBorder,
                            hintText: '03-12345678',
                            hintStyle: TextHint1,
                          ),
                          onChanged: (val) {
                            setState(() => placePhone = val);
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Text('Notes for Jomshare team' , style: TextTitle1),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                          decoration: new InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: CustOutlineInputBorder,
                            focusedErrorBorder: CustOutlineInputBorder,
                            enabledBorder: CustOutlineInputBorder,
                            focusedBorder: CustOutlineInputBorder,
                            hintText: 'Any additional informational for place',
                            hintStyle: TextHint1,
                          ),
                          onChanged: (val) {
                            setState(() => placeNotes = val);
                          },
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ButtonTheme(
                              height: 55,
                              minWidth: 380,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(2.0),
                                    side: BorderSide(color: Colors.red)),
                                onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.reset();
                                      if (placePhone.length < 3 || placeHours.length < 3) {
                                        placePhone = '-';
                                        placeHours = '-';
                                      };
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => FireMap(userid: widget.uid, placeName: placeName, placeAddress: placeAddress, placeCategory: placeCategory, placeHours: placeHours, placeNotes: placeNotes, placePhone: placePhone )));
                                    }
                                },
                                color: Colors.red,
                                //textColor: Colors.white,
                                child: Text("Next",
                                    style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold )),
                              ),
                            )
                          ],
                        ),
                      ]
                  ),
                ),
          ),
        )
    );
  }
  }
  
  class FireMap extends StatefulWidget {

    final String userid;
    final String placeName;
    final String placeAddress;
    final String placeHours;
    final String placeCategory;
    final String placePhone;
    final String placeNotes;

    FireMap({this.userid, this.placeName, this.placeAddress, this.placeHours, this.placeCategory, this.placeNotes, this.placePhone});

    @override
    _FireMapState createState() => _FireMapState();
  }
  
  class _FireMapState extends State<FireMap> {

    CameraPosition _position = _kInitialPosition;
    MapType currentMapType  = MapType.normal;
    final Geolocator geolocator = Geolocator();                                         // new
    GoogleMapController mapController;
    List<Marker> allMarkers = [];
    LatLng currentLocation = LatLng(24.150, -110.32);
    LatLng get initialPos => currentLocation;
    Location location = new Location();
    LocationData currentLocationData;                                                               // new
    Position currentPosition;                                                                                              // new
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
    Geoflutterfire geo = Geoflutterfire();

    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

    setMarkers() {
        firestore.collection('locations').getDocuments().then((docs) {
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

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Get Location', style: TextStyle( fontWeight: FontWeight.bold)),
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
                                      Text(widget.placeName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        onPressed: _addGeoPoint,
                        color: Colors.red,
                        //textColor: Colors.white,
                        child: Text("Set Location",
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

    void _updateCameraPosition(CameraPosition position) {
      setState(() {
        _position = position;
      });
    }

  _onMapCreated(GoogleMapController controller) {
        setState(() {
            mapController = controller;
        });
  }

    Future  _addGeoPoint() async {
      DocumentReference docRef =  Firestore.instance.collection('locations').document();
      docRef.setData({
        "id": widget.userid,
        "docID": docRef.documentID,
        "verified": "No",
        "placeName": widget.placeName,
        "placeAddress": widget.placeAddress,
        "placeHours": widget.placeHours,
        "placeCategory": widget.placeCategory,
        "placePhone": widget.placePhone,
        "placeNotes": widget.placeNotes,
        "LatLng": new GeoPoint(currentLocation.latitude, currentLocation.longitude)
      })
          .whenComplete(() {
        print('Geolocation Added');
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: widget.userid, docID: docRef.documentID)));
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
  

