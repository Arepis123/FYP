import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:netninja/screens/review.dart';
import 'package:netninja/services/database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:netninja/shared/dialogbox.dart';
import 'package:netninja/shared/loading.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'package:netninja/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {

  final String uid;
  final String docID;
  LocationPage({this.uid,this.docID,});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  var rating = 0.0;
  int docsNo = 0;
  bool _trexto = true;
  bool showRate = false;
  String review = '';
  double avgRate = 0;
  final myController = TextEditingController();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String hintText = 'Doesn\'t look like much when you walk past, but I was practically dying of hunger so I popped in. I got special lamb chop and wow... there are no words. A special lamb chop done right. Juicy lamb , 3 scoopes of mashed potato , stuffed with all the essential s (BBQ sauce, salad, fries, red beans, and coleslaw). There is about  a hundreds options available between the menu board and wall full of specials, so it can get a little overwhelming , but you rally  can\'t fo wrong. Not much else to say besides go see for yourself! You won\'t be disppointed.';

  void _toggleText() {
    setState(() {
      _trexto = !_trexto;
      print('object tapped');
    });
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  countRate() async {
    double totalRate = 0;
    double tempAvg = 0;
    Firestore.instance.collection('reviews').where('locID', isEqualTo: widget.docID).getDocuments().then((docs) {
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
        Firestore.instance.collection('locations').document(widget.docID).updateData({
            "avgRate": avgRate
        });
      }
      showRate = true;
    });
  }

  setImages() {
    Firestore.instance.collection('images').where('locID', isEqualTo: widget.docID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        _listOfImages = [];
        for (int i=0; i<docs.documents.length; i++) {
          for(int x=0; x<docs.documents[i].data['urls'].length; x++)
                _listOfImages.add(NetworkImage(docs.documents[i].data['urls'][x]));
        }
        setState(() {
          showImage = true;
        });
      }
    });
  }

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
      countRate();
      setImages();
      setMarkers();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //myController.dispose();
    super.dispose();
  }

  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  List<NetworkImage> _listOfImages = <NetworkImage>[];
  String _error = 'No Error Dectected';
  bool isUploading = true;
  bool usUploading = false;
  bool showImage = false;

  void _isUploading() {
      setState(() {
        isUploading =! isUploading;
        usUploading =! usUploading;
      });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));

    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  void uploadImages(String uid, String locID){
    for ( var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if(imageUrls.length==images.length){
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          Firestore.instance.collection('images').document(documnetID).setData({
            'uID': uid,
            'locID': locID,
            'picID': documnetID,
            'urls':imageUrls
          }).then((_){
            SnackBar snackbar = SnackBar(content: Text('Uploaded Successfully'));
            //widget.globalKey.currentState.showSnackBar(snackbar);
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = 'places/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Location', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector( onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute( builder: (BuildContext context) => super.widget));
          }, child: Icon(Icons.refresh, color: Colors.red,)),
        ],
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
                               Visibility(
                                 visible: !showImage,
                                 child: Container(
                                   width: 412,
                                   height: 240,
                                   decoration: BoxDecoration(
                                     image: DecorationImage(image: NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/netninja-6cb94.appspot.com/o/places%2Fcity-skyline-at-sunset-vector-background1.jpg?alt=media&token=a9b67ed0-a27d-4319-a138-efc69af1b2f7'),
                                         fit: BoxFit.fill),
                                   ),
                                 ),
                               ),
                               Visibility(
                                  visible: showImage,
                                   child: Container(
                                     width: 412,
                                     height: 240,
                                     child: Carousel(
                                         boxFit: BoxFit.cover,
                                         images: _listOfImages,
                                         showIndicator: true,
                                         autoplay: false,
                                         indicatorBgPadding: 5,
                                         dotIncreaseSize: 1,
                                         overlayShadow: true,
                                         overlayShadowSize: 450,
                                         dotBgColor: Colors.transparent,
                                         dotSpacing: 10,
                                         dotSize: 6,
                                         dotPosition: DotPosition.bottomCenter,
                                         animationCurve: Curves.fastOutSlowIn,
                                         animationDuration:
                                         Duration(milliseconds: 2500)),
                                   ),
                                   ),
                               Positioned(
                                 top: 10,
                                 right: 20,
                                 child:  GestureDetector(
                                    onTap: () async  {
                                      print('$avgRate');
                                      final action = await DialogBox.yesAbortDialog(context, 'Edit Location Details', 'Are you sure you want to edit the details?');
                                      if (action == DialogAction.yes) {
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => EditDetails(docID: widget.docID)));
                                      };
                                    },
                                     child: Icon(Icons.edit, color: Colors.white, size: 25))
                               ),
                               Positioned(
                                  bottom: 55,
                                   left: 20,
                                   child: Text( snapshot.data['placeName'], style: TextStyle( fontWeight: FontWeight.w900, fontSize: 26, color: Colors.white, fontFamily: 'SFProText')),
                               ),
                               Positioned(
                                 bottom: 20,
                                 left: 19,
                                 child: Visibility(
                                   visible: showRate,
                                   child: SmoothStarRating(
                                     rating: avgRate.toDouble(),
                                     size: 23,
                                     isReadOnly: true,
                                     filledIconData: Icons.stars,
                                     defaultIconData: Icons.stars,
                                     starCount: 5,
                                     allowHalfRating: false,
                                     spacing:  -1,
                                     borderColor: Colors.white,
                                   ),
                                 ),
                               ),
                               Positioned(
                                 bottom: 19,
                                 left: 140,
                                 child: Text('$docsNo', style: TextStyle( fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white, fontFamily: 'SFProText')),
                               ),
                            ],
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                  Text(  snapshot.data['placeCategory'],  style: TextStyle( fontWeight: FontWeight.bold, fontSize: 17)),
                                  SizedBox(height: 3),
                                  Visibility(
                                      visible: snapshot.data['placeHours'].toString().length < 5 ?  false : true,
                                      child: Text(  snapshot.data['placeHours'],  style: TextStyle( fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red))
                                  ),
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
                                                            child: SizedBox(width: 45, height: 45, child: Icon(Icons.map, size: 32, color: Colors.black54.withOpacity(0.7))),
                                                            onTap: () {
                                                              Navigator.push(context,MaterialPageRoute(builder: (context) => ViewMap(docID: widget.docID)));
                                                            },
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
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(20.0)), //this right here
                                                              child: Container(
                                                                height: 150,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(12.0),
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text('Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                                      TextFormField(
                                                                        initialValue: snapshot.data['placeNotes'],
                                                                        style:TextStyle(fontSize: 14),
                                                                        decoration: InputDecoration(
                                                                            border: InputBorder.none,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
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
                                                    onTap: () {
                                                      double value = 0.0;
                                                      showReviewMenu(user.uid, widget.docID, snapshot.data['placeName'], value);
                                                    },
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
                                                    onTap: () {
                                                      final String text = 'Semoga lulus ini FYP';
                                                      final String subject = 'Test share  @ ${ snapshot.data['placeCategory']}... Semoga lulus FYP ini';
                                                      final RenderBox box = context.findRenderObject();
                                                      Share.share(
                                                          text,
                                                          subject: subject,
                                                          sharePositionOrigin:  box.localToGlobal(Offset.zero) & box.size);
                                                    },
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
                                  spacing:  -1,
                                  borderColor: Colors.grey,
                                  onRated: (value) {
                                    print("rating value dd -> ${value.truncate()}");
                                    showReviewMenu(user.uid, widget.docID, snapshot.data['placeName'], value);
                                  },
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
                                              onTap: () {
                                                  loadAssets();
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 9.0),
                                        GestureDetector(onTap: () {uploadImages( user.uid, snapshot.data['docID']);}, child: Text('Add photo',  style: TextStyle(  fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black54.withOpacity(0.6)))),
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
                                              onTap: () async {
                                                DocumentReference docRef = Firestore.instance.collection('bookmarks').document();
                                                docRef.setData({
                                                    'docID': widget.docID,
                                                    'docID2': docRef.documentID,
                                                    'id': user.uid,
                                                })
                                                  .whenComplete(() {
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
                                                            title: Center(child: Text('Bookmark added', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                                          );
                                                        });
                                                  });
                                              },
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
                          height: 210,
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 0, right: 0),
                          child: Stack(
                            children: <Widget>[
                              SizedBox(
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(snapshot.data['LatLng'].latitude,snapshot.data['LatLng'].longitude),
                                    zoom: 16,
                                  ),
                                  mapType:MapType.normal,
                                  zoomControlsEnabled: false,
                                  markers: Set<Marker>.of(markers.values),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 10, left: 23, right: 23),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       SizedBox(height: 5),
                                       Text('Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                       SizedBox(height: 1),
                                       Text( snapshot.data['placeAddress'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                     ],
                                  ),
                                ),
                               Padding(
                                 padding:EdgeInsets.symmetric(horizontal: 20),
                                 child: Container(
                                     height:1.0,
                                     width:345,
                                     color:Colors.grey.withOpacity(0.5)
                                 ),
                               ),
                               Container(
                                  padding: EdgeInsets.only(top: 13, bottom: 13, left: 23, right: 28),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                          Text('Get Directions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                          GestureDetector(
                                              onTap: () {openMap(snapshot.data['LatLng'].latitude,snapshot.data['LatLng'].longitude);},
                                              child: Icon(Icons.directions, size: 25, color: Colors.black87.withOpacity(0.7))
                                          ),
                                      ],
                                  ) ,
                               ),
                               Padding(
                                 padding:EdgeInsets.symmetric(horizontal:20),
                                 child: Container(
                                     height:1.0,
                                     width:345,
                                     color:Colors.grey.withOpacity(0.5)
                                 ),
                               ),
                               Container(
                                 padding: EdgeInsets.only(top: 13, bottom: 5, left: 23, right: 28),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: <Widget>[
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Call', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                          SizedBox(height: 1),
                                          Text(snapshot.data['placePhone'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
                                        ],
                                     ),
                                     GestureDetector(
                                         onTap: (){
                                           print('object');
                                           launch('tel://${snapshot.data['placePhone']}');
                                         },
                                         child: Icon(Icons.phone_in_talk, size: 25, color: Colors.black87.withOpacity(0.7))),
                                   ],
                                 ) ,
                               ),
                             ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: showImage,
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
                              child: Container(
                                height: 250,
                                width: 412,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 0),
                                          child: Text('Photos', style: TextStyle( fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'SFProText'))),
                                      SizedBox(height: 20),
                                      Container(
                                        height: 200,
                                        width: 412,
                                        child: ListView(
                                          shrinkWrap: false,
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            //padding: EdgeInsets.only(right:10),
                                            children: _listOfImages.map((f){
                                                    return Container(
                                                        height: 200,
                                                        width: 362,
                                                      padding: EdgeInsets.only(right:10),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(13.0),
                                                          color: Colors.grey,
                                                          image: DecorationImage(image: NetworkImage(
                                                            f.url),
                                                              fit: BoxFit.cover),
                                                        ),
                                                    );
                                            }).toList(),
                                        ),
                                      ),
                                    ],
                                )
                              ),
                          ),
                        ),
                        Visibility(
                          visible: showImage == false ? true : false,
                          child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                      Text('Photos', style: TextStyle( fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'SFProText')),
                                      SizedBox(height: 20),
                                      Visibility(
                                        visible: isUploading,
                                        child: Container(
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
                                                  onPressed: (){
                                                    setState(() {
                                                      // ignore: unnecessary_statements
                                                      _isUploading();
                                                    });
                                                    loadAssets();
                                                  }
                                              ),
                                              Text(' Add photo', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold)),
                                            ],
                                        ),
                                    ),
                                      ),
                                      Visibility(
                                        visible: usUploading,
                                        child: Container(
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
                                            SizedBox(
                                                height: 30,
                                                width: 150,
                                                child: new RaisedButton(
                                                  elevation: 0.0,
                                                  shape: new RoundedRectangleBorder(
                                                      borderRadius: new BorderRadius.circular(10)),
                                                   color: Colors.black87,
                                                  child: Text(  'Save photos',
                                                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  onPressed:() {
                                                    if(images.length==0){
                                                      showDialog(context: context,builder: (_){
                                                        return AlertDialog(
                                                          //backgroundColor: Theme.of(context).backgroundColor,
                                                          content: Text("No image selected",style: TextStyle(color: Colors.black)),
                                                          actions: <Widget>[
                                                            InkWell(
                                                              onTap: (){
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                width: 80,
                                                                height: 30,
                                                                child: Center(child: Text("Ok",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700))),
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                      _isUploading();
                                                    }
                                                    else {
                                                      setState(() {
                                                        // ignore: unnecessary_statements
                                                        _isUploading();
                                                      });
                                                      uploadImages( user.uid, snapshot.data['docID']);
                                                    }
                                                  } ,
                                                )
                                            ),
                                          ],
                                        ),
                                    ),
                                      )
                                  ],
                              ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Reviews', style: TextStyle( fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'SFProText')),
                                  SizedBox(height: 20),
                                  SizedBox(
                                      height: 40,
                                      width: 390,
                                      child: new RaisedButton(
                                        elevation: 0.0,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(10)),
                                        color: Colors.red,
                                        child: Text(  'View all reviews',
                                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold ),
                                          textAlign: TextAlign.right,
                                        ),
                                        onPressed:() {
                                          Navigator.push(context,MaterialPageRoute(builder: (context) => Review(uid: user.uid, docID: widget.docID, placeName: snapshot.data['placeName'])));
                                        } ,
                                      )
                                  ),
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
  void showReviewMenu(String uid, String docID, String name,double rating){
    int rate = 0;
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return  Container(
            height: 780,
            child: new Container(
              padding: EdgeInsets.fromLTRB(25.0, 30, 25, 5.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          Text(" "+name, style: TextStyle( fontSize: 23, fontWeight: FontWeight.bold)),
                          GestureDetector(
                              onTap: ()  {
                                  Navigator.pop(context);
                                  myController.clear();
                              },
                              child: Icon(Icons.close, size: 25, color: Colors.black87.withOpacity(0.7))),
                      ],
                  ),
                  SizedBox(height: 5),
                  Row(
                      children: <Widget>[
                        SmoothStarRating(
                          rating: rating,
                          size: 35,
                          filledIconData: Icons.stars,
                          defaultIconData: Icons.stars,
                          starCount: 5,
                          allowHalfRating: false,
                          spacing:  -3,
                          borderColor: Colors.grey,
                          onRated: (val) {
                            _toggleText();
                            rate = val.truncate();
                            print("rating value 1 -> ${rate}");
                            print("rating value 2 -> ${val}");
                          },
                        ),
                        SizedBox(width: 5),
                        Visibility(visible: _trexto, child: Text('Select a rating', style: TextStyle( fontStyle: FontStyle.italic, color: Colors.black87.withOpacity(0.8)))),
                      ],
                  ),
                  SizedBox(height: 25),
                  Container(
                      padding: EdgeInsets.only(left: 3,bottom: 20),
                      child: TextFormField(
                        maxLines: 26,
                        controller: myController,
                         onChanged: (val) {
                             review = val;
                         },
                         decoration: InputDecoration(
                           border: InputBorder.none,
                           focusedBorder: InputBorder.none,
                           enabledBorder: InputBorder.none,
                           errorBorder: InputBorder.none,
                           disabledBorder: InputBorder.none,
                           hintText: hintText,
                           hintStyle: TextStyle( color: Colors.grey, fontSize: 16),
                         ),
                      ),
                  ),
//                  SizedBox(
//                    height: 55,
//                    width: 358,
//                    child: RaisedButton(
//                      elevation: 1.0,
//                      shape:  RoundedRectangleBorder(
//                          borderRadius:  BorderRadius.circular(3.5)),
//                      color: Colors.red,
//                      onPressed: (){
//                        Navigator.pop(context);
//                      },
//                      child: Text(  'Cancel',
//                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
//                        textAlign: TextAlign.right,
//                      ),
//                    ),
//                  ),
                  SizedBox(
                    height: 55,
                    width: 358,
                    child: RaisedButton(
                      elevation: 1.0,
                      shape:  RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(3.5)),
                      color: review.length > 3 ?Colors.red : null,
                      onPressed: () async {
                        //Navigator.pop(context);
                        if(myController.text.toString().length > 3){
                              Firestore.instance.collection('locations').document(docID).updateData({'noReview': FieldValue.increment(1)});
                              Firestore.instance.collection('users').document(uid).updateData({'noReview': FieldValue.increment(1)});
                              Firestore.instance.collection('histories').document().setData({
                                "uid": uid,
                                "dateTime": DateTime.now(),
                                "type": 'Review',
                                "review": myController.text,
                                "rate": rate,
                                "locID": docID,
                                "edited": 'No',
                              });
                              DocumentReference docRef = Firestore.instance.collection('reviews').document();
                              docRef.setData({
                                'locID': widget.docID,
                                'revID': docRef.documentID,
                                'uID':uid,
                                'dateTime': DateTime.now(),
                                'review': myController.text,
                                'edited': 'No',
                                'rate': rate,
                              })
                                  .whenComplete(() {
                                Navigator.of(context).pop(true);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => super.widget));
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
                                        title: Center(child: Text('Review Saved', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                      );
                                    });
                              });
                        }
                      },
                      child: Text(  'Submit',
                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        isScrollControlled: true,
    );
  }

}

class ViewMap extends StatefulWidget {

  final String docID ;
  ViewMap({this.docID});

  @override
  _ViewMapState createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {

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

  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;

  void _isUploading() {
      isUploading = !isUploading ;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      print(resultList.length);
      print((await resultList[0].getThumbByteData(122, 100)));
      print((await resultList[0].getByteData()));
      print((await resultList[0].metadata));

    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
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
                zoomControlsEnabled: true,
                markers: Set<Marker>.of(markers.values),
              ),
            ],
          );
        },
      ),
    );
  }
}

class EditDetails extends StatefulWidget {

  final String docID;
  EditDetails({this.docID});

  @override
  _EditDetailsState createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController, addressController, categoryController, hourController, phoneController, noteController ;

  setMarkers() {
    Firestore.instance.collection('locations').where('docID', isEqualTo: widget.docID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          setState(() {
            nameController = new TextEditingController(text: docs.documents[i].data['placeName']);
            addressController = new TextEditingController(text: docs.documents[i].data['placeAddress']);
            categoryController = new TextEditingController(text: docs.documents[i].data['placeCategory']);
            hourController = new TextEditingController(text: docs.documents[i].data['placeHours']);
            phoneController = new TextEditingController(text: docs.documents[i].data['placePhone']);
            noteController = new TextEditingController(text: docs.documents[i].data['placeNotes']);
          });
        }
      }
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
      appBar: new AppBar(
        title: new Text("Location Details",style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
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
                        controller: nameController,
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
                        controller:addressController,
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
                        controller: phoneController,
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
                        controller: noteController,
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

