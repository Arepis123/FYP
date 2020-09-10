import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:netninja/screens/listofphotos.dart';
import 'package:netninja/shared/dialogbox.dart';
import 'package:netninja/shared/loading.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:timeago/timeago.dart' as timeago;

class Review extends StatefulWidget {

  final String uid;
  final String docID;
  final String placeName;
  Review({this.uid, this.docID, this.placeName});

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  int noReviewU = 0;
  int noReviewL = 0;

  var clients = [];

  bool adedata = false;

  List<NetworkImage> _listOfImages = <NetworkImage>[];

  countReviewUser() {
    Firestore.instance.collection('users').where('id', isEqualTo: widget.uid).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          noReviewU = docs.documents[i].data['noReview'];
        }
      }
    });
  }

  countReviewLocation() {
    Firestore.instance.collection('locations').where('docID', isEqualTo: widget.docID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          noReviewL = docs.documents[i].data['noReview'];
        }
      }
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
          //showImage = true;
        });
      }
    });
  }

  countReviewPic(String locID) {
    Firestore.instance.collection('images').where('locID', isEqualTo: locID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          adedata = true;
        }
      }
    });
  }

  populateClients() {
    Firestore.instance.collection('images').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          clients.add(docs.documents[i].data);
        }
      }
    });
  }


  Widget showPic() {
      return ListView.separated(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: null
      );
  }

  void initState() {
    countReviewUser();
    populateClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.placeName, style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('reviews').where('locID', isEqualTo:  widget.docID ).orderBy('dateTime', descending: true).snapshots(),
        builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
                  return Loading();
            }
            final List<DocumentSnapshot> document = snapshot.data.documents;
            return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount:  document.length,
              itemBuilder: (BuildContext context, int index) {
                final date1 =document[index].data['dateTime'].toDate().subtract(new Duration(minutes: 0));
              return  Container(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0,5.0, 0.0),
                  child: Card(
                    elevation: 3,
                    color: document[index].data['uID']==  widget.uid? Color.fromRGBO(200, 248, 199, 0.9) :  Colors.white,
                    child: Column(
                        children: <Widget>[
                            FutureBuilder(
                              future: Firestore.instance.collection('users').where('id', isEqualTo: document[index].data['uID']).getDocuments(),
                              builder: (BuildContext context, AsyncSnapshot snap) {
                                  if (!snap.hasData) {
                                  return Center(child: Text('Loading...'));
                                  }
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(10.0, 10.0,9.0, 5.0),
                                            child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 45,
                                                    height:  45,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage( snap.data.documents.toList()[0].data['imageURL']),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left:8 ),
                                                    width: 325,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                          Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                  Container(
                                                                      //color: Colors.grey,
                                                                      padding: EdgeInsets.only(bottom: 2),
                                                                      child: Text(snap.data.documents.toList()[0].data['name'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing:0.4)),
                                                                  ),
                                                                 Container(
                                                                      padding: EdgeInsets.only(left: 3, right: 3),
                                                                     decoration: BoxDecoration(
                                                                         color: Colors.grey.withOpacity(0.2),
                                                                     border: Border.all(
                                                                       color: Colors.grey[300],
                                                                     ),
                                                                     borderRadius: BorderRadius.all(Radius.circular(20))
                                                                 ),
                                                                      child: Row(
                                                                          children: <Widget>[
                                                                              Tooltip(
                                                                                  message: 'Number of places added',
                                                                                  child: Container(
                                                                                      padding: EdgeInsets.only(right:1),
                                                                                      width: 45,
                                                                                      height: 20,
                                                                                      child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: <Widget>[
                                                                                            Icon(Icons.add_location, size: 18, color: Colors.black87.withOpacity(0.6)),
                                                                                            SizedBox(width: 0),
                                                                                            Text(snap.data.documents.toList()[0].data['noPlaceAdded'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.9))),
                                                                                          ],
                                                                                      ),
                                                                                  ),
                                                                              ),
                                                                            Tooltip(
                                                                              message: 'Number of review made',
                                                                              child: Container(
                                                                                padding: EdgeInsets.only(left:1),
                                                                                width: 45,
                                                                                height: 20,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: <Widget>[
                                                                                    Icon(Icons.rate_review, size: 17, color: Colors.black87.withOpacity(0.6)),
                                                                                    SizedBox(width: 2),
                                                                                    Text(snap.data.documents.toList()[0].data['noReview'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.9))),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                      ),
                                                                ),
                                                              ],
                                                          ),
                                                          Column(
                                                              children: <Widget>[
                                                                Visibility(
                                                                  visible: document[index].data['uID'] == widget.uid ? true:false,
                                                                  child: GestureDetector(
                                                                      onTap: () {
                                                                        showMenu(widget.uid, document[index].data['revID'], document[index].data['locID'], document[index].data['rate'].toDouble(), document[index].data['review']);
                                                                      },
                                                                      child: Icon(Icons.more_horiz, color: Colors.black87.withOpacity(0.7))
                                                                  ),
                                                                ),
                                                                //justIcon(uid: snap.data.documents.toList()[0].data['id'])
//                                                                FutureBuilder(
//                                                                      future: Firestore.instance.collection('images').getDocuments(),
//                                                                      builder: (BuildContext context, AsyncSnapshot snaps) {
//                                                                        if (!snaps.hasData) {
//                                                                          return Center(child: Text('Loading...'));
//                                                                        }
//                                                                         return GestureDetector(
//                                                                            child:Column(
//                                                                                children: <Widget>[
//                                                                                    Visibility(
//                                                                                        visible: snaps.data.documents.toList()[0].data['uID'] == widget.uid ? true : false,
//                                                                                        child: Icon(Icons.image, color: Colors.black87.withOpacity(0.5)),
//                                                                                    )
//                                                                                ],
//                                                                        ));
//                                                                      }
//                                                                ),
                                                              ],
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                            ),
                                          ),
                                          Row(
                                              children: <Widget>[
                                                Row(
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.fromLTRB(10.0, 0.0,0, 8),
                                                        child: SmoothStarRating(
                                                          rating: document[index].data['rate'].toDouble(),
                                                          size: 28,
                                                          isReadOnly: true,
                                                          filledIconData: Icons.stars,
                                                          defaultIconData: Icons.stars,
                                                          starCount: 5,
                                                          allowHalfRating: false,
                                                          spacing:  -2,
                                                          borderColor: Colors.grey,
                                                          //color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                ),
                                                SizedBox(width: 10),
                                                Column(
                                                    children: <Widget>[
                                                        Row(
                                                            children: <Widget>[
                                                                Container(
                                                                    child: Text(timeago.format(date1), style: TextStyle(fontSize: 13)),
                                                                ),
                                                              SizedBox(width: 3),
                                                              Visibility(
                                                                visible: document[index].data['edited'] == 'Yes' ? true : false,
                                                                child: Container(
                                                                    child: Text('(edited)', style: TextStyle(fontSize: 13)),
                                                                ),
                                                              )
                                                            ],
                                                        ),
                                                        SizedBox(height: 10.5)
                                                    ],
                                                ),
                                              ],
                                          ),
                                          Container(
                                          padding: EdgeInsets.fromLTRB(12.0, 0.0,15, 7.0),
                                          child: Text(document[index].data['review'],
                                            style: TextStyle(
                                                fontFamily: 'SFProText',
                                                letterSpacing: -0.3,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                        ),

                                          //ListOfPhotos(uid: widget.uid, locID: document[index].data['locID'], revID: "fs"),
                                      ]
                                  );
                                  }
                            ),
                        ]
                    )
                ),
                );
            },
            );
          },
      ),
    );
  }
  void showMenu(String uid, String revID, String locID, double rate, String review){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0)
            )
        ),
        context: context,
        builder: (builder){
          return  Container(
            height: 270,
            child: new Container(
              padding: EdgeInsets.fromLTRB(30.0, 30, 30.0, 5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 55,
                    width: 350,
                    child: RaisedButton(
                      elevation: 0.0,
                      shape:  RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(3.5)),
                      color: Colors.red,
                      child: Text(  'Edit Review',
                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        showReviewMenu( uid,  revID,  locID,  rate, review);
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 55,
                    width: 350,
                    child: RaisedButton(
                      elevation: 0.0,
                      shape:  RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(3.5)),
                      color: Colors.red,
                      child: Text(  'Remove Review',
                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final action = await DialogBox.yesAbortDialog(context, 'Remove Review', 'Are you sure you want to remove this review?');
                        if (action == DialogAction.yes) {
                          int temp1 = (noReviewU - 1);
                          int temp2 = (noReviewL - 1);
                          Firestore.instance.collection('users').document(widget.uid).updateData({'noReview': temp1});
                          //Firestore.instance.collection('locations').document(widget.docID).updateData({'noReview': temp2});
                          Firestore.instance.collection('locations').document(widget.docID).updateData({'noReview': FieldValue.increment(-1)});
                          Firestore.instance.collection('reviews').document(revID).delete().
                          whenComplete((){
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
                                    title: Center(child: Text('Deleted Successfully', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                  );
                                });
                          });
                        };
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 55,
                    width: 350,
                    child: RaisedButton(
                      elevation: 1.0,
                      shape:  RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(3.5)),
                      color: Colors.red,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(  'Cancel',
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
        isScrollControlled: true
    );
  }
  void showReviewMenu(String uid, String revID, String locID,double rating, String review){
    int rate = 0;
    final thisController = TextEditingController(text: review);
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
                    Text(" "+widget.placeName, style: TextStyle( fontSize: 23, fontWeight: FontWeight.bold)),
                    GestureDetector(
                        onTap: ()  {
                          Navigator.pop(context);
                          thisController.clear();
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
                      spacing:  0.0,
                      borderColor: Colors.grey,
                      onRated: (val) {
                        rate = val.truncate();
                        print("rating value 1 -> ${rate}");
                        print("rating value 2 -> ${val}");
                      },
                    ),
                    SizedBox(width: 5),
                    Text('Select a rating', style: TextStyle( fontStyle: FontStyle.italic, color: Colors.black87.withOpacity(0.8))),
                  ],
                ),
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.only(left: 3,bottom: 20),
                  child: TextFormField(
                    maxLines: 26,
                    //initialValue: review,
                    controller: thisController,
                    onChanged: (val) {
                      //review = val;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      //hintText: hintText,
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
                    color: Colors.red,
                    onPressed: () async {
                      //Navigator.pop(context);
                      if(thisController.text.toString().length > 3){
                        DocumentReference docRef = Firestore.instance.collection('reviews').document(revID);
                        docRef.updateData({
                          'review': thisController.text,
                          'dateTime': DateTime.now(),
                          'edited': 'Yes',
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


