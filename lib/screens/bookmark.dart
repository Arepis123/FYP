import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/locationPage.dart';
import 'package:netninja/shared/dialogbox.dart';
import 'package:netninja/shared/loading.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Bookmark extends StatefulWidget {

  final String uid;
  Bookmark({this.uid});

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark' , style: TextStyle( fontWeight: FontWeight.bold)),
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
                    'List of bookmarks',
                    style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
//                      Stack(
//                        children: <Widget>[
//                          new Icon(Icons.notifications, color: Colors.white,),
//                          new Positioned(
//                            right: 0,
//                            child: new Container(
//                              padding: EdgeInsets.all(1),
//                              decoration: new BoxDecoration(
//                                  color: Colors.red,
//                                  shape: BoxShape.circle,
//                                  boxShadow: [
//                                    BoxShadow(
//                                      color: Colors.grey.withOpacity(0.5),
//                                      spreadRadius: 1,
//                                      blurRadius: 7,
//                                    )
//                                  ]
//                                //borderRadius: BorderRadius.circular(6),
//                              ),
//                              constraints: BoxConstraints(
//                                minWidth: 20,
//                                minHeight: 20,
//                              ),
//                              child: new Text(
//                                '$countUser',
//                                style: new TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 16,
//                                    fontWeight: FontWeight.bold
//                                ),
//                                textAlign: TextAlign.center,
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
                ],
              )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
              child: StreamBuilder(
                  stream: Firestore.instance.collection('bookmarks').where('id', isEqualTo: widget.uid).snapshots(),
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
                           String docID = document[index].data['docID'];
                           String docID2 = document[index].data['docID2'];
                          return Card(
                              elevation: 3,
                              color: Colors.white,
                              child: InkWell(
                              splashColor: Colors.red.withAlpha(30),
                                onTap: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage( uid: widget.uid, docID: docID)));
                                },
                                child: Column(
                                    children: <Widget>[
                                        FutureBuilder(
                                            future: Firestore.instance.collection('locations').where('docID', isEqualTo: docID).getDocuments(),
                                            builder: (BuildContext context, AsyncSnapshot snap) {
                                              if (!snap.hasData) {
                                                return Center(child: Text('Loading...'));
                                              }
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(15.0, 15.0,15.0, 15.0),
                                                child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.start,
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
                                                              width:265,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Text(snap.data.documents.toList()[0].data['placeName'],  style: TextStyle( fontSize: 17, fontWeight: FontWeight.w700)),
                                                                  GestureDetector(
                                                                      onTap: () {
                                                                        showMenu(widget.uid, docID2, docID);
                                                                      },
                                                                      child: Icon(Icons.more_horiz, color: Colors.black87.withOpacity(0.7))
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 1),
                                                            Text( snap.data.documents.toList()[0].data['placeCategory'],  style: TextStyle( fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87.withOpacity(0.7))),
                                                            SizedBox(height: 1),
                                                            SmoothStarRating(
                                                              rating: 3,
                                                              size: 21,
                                                              isReadOnly: true,
                                                              filledIconData: Icons.stars,
                                                              defaultIconData: Icons.stars,
                                                              starCount: 5,
                                                              allowHalfRating: false,
                                                              spacing:  0.1,
                                                              borderColor: Colors.grey,
                                                              //color: Colors.black54,
                                                            ),
                                                          ],
                                                      ),
                                                    ],
                                                ),
                                              );
                                            },
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
  void showMenu(String uid, String docID2, String docID){
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
                        Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPage( uid: widget.uid, docID: docID)));
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
                      child: Text(  'Delete Bookmark',
                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final action = await DialogBox.yesAbortDialog(context, 'Delete bookmark', 'Are you sure you want to delete this?');
                        if (action == DialogAction.yes) {
                          Firestore.instance.collection('bookmarks').document(docID2).delete().
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
