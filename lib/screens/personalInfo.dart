
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/locationPage.dart';
import 'package:netninja/screens/profile.dart';
import 'package:netninja/shared/dialogbox.dart';
import 'package:netninja/shared/loading.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PreProfile extends StatefulWidget {

  final String userId ;
  PreProfile({ this.userId });

  @override
  _PreProfileState createState() => _PreProfileState();
}

class _PreProfileState extends State<PreProfile> {

  String docID = '';
  int noPlaceAdded = 0;
  int noReview = 0;
  double avgRate;
  int  money =0;
  int mon = 0;


  setRevNo() {
    Firestore.instance.collection('reviews').where('uID', isEqualTo: widget.userId).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          //initRevNo(docs.documents[i].data);
          noReview = noReview + 1;
        }
      }
    });
  }

  setPlaNo() {
    Firestore.instance.collection('users').where('id', isEqualTo: widget.userId).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          //initRevNo(docs.documents[i].data);
          noPlaceAdded = docs.documents[i].data['noPlaceAdded'];
        }
      }
    });
  }

  @override
  void initState() {
    setRevNo();
    setPlaNo();
    Firestore.instance.collection('locations').where('id', isEqualTo: widget.userId).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          docID =  docs.documents[i].documentID;
        }
      }
    });
    super.initState();
  }

//  Stream getStream() {
//    Stream stream1 = Firestore.instance.collection('locations').document(docID).snapshots();
//    Stream stream2 = Firestore.instance.collection('users').document(widget.userId).snapshots();
//    return CombineLatestStream.list([stream1,stream2]);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Personal Information",style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey.withOpacity(0.1),
            child: Column(
              children: <Widget>[
                FutureBuilder(
                  future: Firestore.instance.collection('users').where('id', isEqualTo: widget.userId).getDocuments(),
                  builder: (BuildContext context, AsyncSnapshot snap) {
                    if (!snap.hasData) {
                      return Center(child: Text('Loading...'));
                    }
                    return Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text( 'Profile',  style: TextStyle( fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'SFProText', letterSpacing: -0.6)),
                          SizedBox(height: 35.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 3, color: Colors.red),
                                  image: DecorationImage(image: NetworkImage(
                                      snap.data.documents.toList()[0].data['imageURL']),
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
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  children: <Widget>[
                                    Text(snap.data.documents.toList()[0].data['name'],
                                        style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87.withOpacity(0.9))),
                                    Text(snap.data.documents.toList()[0].data['email'] , style: TextStyle(
                                        fontSize: 16, color: Colors.black87.withOpacity(0.9))),
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
                                                  Text(snap.data.documents.toList()[0].data['noPlaceAdded'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.9))),
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
                                                  //Text( snap.data.documents.toList()[0].data['noReview'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.9))),
                                                  Text(noReview.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87.withOpacity(0.9))),
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
                    );
                  },
                ),
                SizedBox(height: 10),
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text( 'List of Places Added',  style: TextStyle( fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'SFProText', letterSpacing: -0.6)),
                        SizedBox(height: 10),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:1.0),
                          child: Container(
                              height: 1.0,
                              width: 370,
                              color:Colors.grey.withOpacity(0.5)
                          ),
                        ),
                        StreamBuilder(
                          stream: Firestore.instance.collection('locations').where('id', isEqualTo: widget.userId).snapshots(),
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
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: widget.userId, docID: document[index].data['docID'])));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 7),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 23),
                                              width: 65,
                                              height: 65,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                                color: Colors.grey.withOpacity(0.4),
                                              ),
                                              child: Icon(Icons.home, color: Colors.white, size: 40),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:280,
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Text( document[index].data['placeName'],  style: TextStyle( fontSize: 18, fontWeight: FontWeight.w700)),
                                                          GestureDetector(
                                                              onTap: () {
                                                                showMenu(widget.userId, document[index].data['docID']);
                                                              },
                                                              child: Icon(Icons.more_horiz, color: Colors.black87.withOpacity(0.7))
                                                          ),
                                                        ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text( document[index].data['placeCategory'],  style: TextStyle( fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87.withOpacity(0.7))),
                                                  SizedBox(height: 1),
                                                  Text( document[index].data['verified'] == 'No' ? "Not Verified ": "Verified" ,
                                                      style: TextStyle(
                                                            fontSize: 16, fontWeight: FontWeight.w700, color:  document[index].data['verified'] == 'Yes' ? Colors.blue.withOpacity(0.7) : Colors.red.withOpacity(0.7))),
                                                ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Padding(
                                          padding:EdgeInsets.symmetric(horizontal:1.0),
                                          child: Container(
                                              height:1.0,
                                              width:345,
                                              color:Colors.grey.withOpacity(0.5)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void showMenu(String uid, String docID){
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
            height: 250,
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
                       child: Text(  'Add Review',
                         style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                         textAlign: TextAlign.right,
                       ),
                       onPressed: (){
                         Navigator.pop(context);
                         Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage(uid: uid,docID: docID)));
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
                      child: Text(  'Delete This Place',
                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final action = await DialogBox.yesAbortDialog(context, 'Delete Location', 'Are you sure you want to delete this location?');
                        if (action == DialogAction.yes) {
                          Firestore.instance.collection('users').document(widget.userId).updateData({'noPlaceAdded': noPlaceAdded - 1});
                          Firestore.instance.collection('reviews').where('locID', isEqualTo: docID).getDocuments().then((snapshot){
                                for (int i=0; i<snapshot.documents.length; i++) {
                                    snapshot.documents[i].reference.delete();
                                }
                          });
                          Firestore.instance.collection('locations').document(docID).delete().
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
}

