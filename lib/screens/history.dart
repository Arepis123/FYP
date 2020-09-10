import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

class History extends StatefulWidget {

  final String uid;
  History({this.uid});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('History', style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
                HistoryLoc(uid: widget.uid),
                SizedBox(height: 5),
                HistoryRev(uid: widget.uid),
            ],
        ),
      ),
    );
  }
}

class HistoryLoc extends StatefulWidget {
  
  final String uid;
  HistoryLoc({this.uid});
  
  @override
  _HistoryLocState createState() => _HistoryLocState();
}

class _HistoryLocState extends State<HistoryLoc> {
  
  bool showRate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: ExpansionTile(
            title: Text('Places', style: TextStyle(fontFamily: 'SFProText' , fontSize: 22, letterSpacing: -0.6, color: Colors.black87)),
            subtitle: Text('List of places that you went', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.7))),
            children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance.collection('histories').where('type', isEqualTo: 'Location').where('uid', isEqualTo: widget.uid).orderBy('dateTime', descending: true).snapshots(),
                  builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(child: Center(child: Text('')));
                    }
                    final List<DocumentSnapshot> document = snapshot.data.documents;
                          return ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount:  document.length,
                          itemBuilder: (BuildContext context, int index) {
                            if ((index + 1)== document.length){
                                  showRate = true ;
                            }
                                return Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: FutureBuilder(
                                    future: Firestore.instance.collection('locations').where('docID', isEqualTo: document[index].data['locID']).getDocuments(),
                                    builder: (BuildContext context, AsyncSnapshot snap) {
                                      if (!snap.hasData) {
                                        return Center(
                                            child: Text('Loading...'));
                                      }
                                      final date1 =document[index].data['dateTime'].toDate().subtract(new Duration(minutes: 0));
                                      return Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(top: 5, bottom: 10),
                                            child: Row(
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
                                                    //Text(document[index].data['locID'],  style: TextStyle( fontSize: 18, fontWeight: FontWeight.w700)),
                                                    Text(snap.data.documents.toList()[0].data['placeName'],  style: TextStyle( fontFamily: 'SFProText', letterSpacing: -0.6, fontSize: 18, fontWeight: FontWeight.w700)),
                                                    Container(
                                                        width: 280,
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Text(snap.data.documents.toList()[0].data['placeCategory'],  style: TextStyle(  fontSize: 14, fontWeight: FontWeight.bold)),
                                                              Text(timeago.format(date1), style: TextStyle(fontSize: 13,  fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.5))),
                                                            ],
                                                        ),
                                                    ),
                                                    Visibility(
                                                      visible: snap.data.documents.toList()[0].data['avgRate'].toDouble() < 1 ? false: true,
                                                      child: SmoothStarRating(
                                                        rating:  snap.data.documents.toList()[0].data['avgRate'].toDouble(),
                                                        size: 19,
                                                        isReadOnly: true,
                                                        filledIconData: Icons.stars,
                                                        defaultIconData: Icons.stars,
                                                        starCount: 5,
                                                        allowHalfRating: false,
                                                        spacing:  - 1,
                                                        borderColor: Colors.grey,
                                                        //color: Colors.black54,
                                                      ),
                                                    ),
                                                    Text('No review yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Padding(
                                              padding:EdgeInsets.symmetric(horizontal:1.0),
                                              child: Container(
                                                  height:1.0,
                                                  width:380,
                                                  color:Colors.grey.withOpacity(0.5)
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                );
                          });

                  }
                  ),
            ],
        ),
    );
  }
}

class HistoryRev extends StatefulWidget {
  final String uid;
  HistoryRev({this.uid});

  @override
  _HistoryRevState createState() => _HistoryRevState();
}

class _HistoryRevState extends State<HistoryRev> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ExpansionTile(
        title: Text('Reviews', style: TextStyle(fontFamily: 'SFProText' , fontSize: 22, letterSpacing: -0.6, color: Colors.black87)),
        subtitle: Text('List of reviews that you made', style: TextStyle( fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.7))),
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance.collection('histories').where('type', isEqualTo: 'Review').where('uid', isEqualTo: widget.uid).orderBy('dateTime', descending: true).snapshots(),
              builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container(child: Center(child: Text('')));
                }
                final List<DocumentSnapshot> document = snapshot.data.documents;
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount:  document.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: FutureBuilder(
                            future: Firestore.instance.collection('locations').where('docID', isEqualTo: document[index].data['locID']).getDocuments(),
                            builder: (BuildContext context, AsyncSnapshot snap) {
                              if (!snap.hasData) {
                                return Center(
                                    child: Text('Loading...'));
                              }
                              String timeString = document[index].data['dateTime'].toDate().toString();
                              final date1 =document[index].data['dateTime'].toDate().subtract(new Duration(minutes: 0));
                              DateTime date2 =  DateTime.parse(timeString);
                              return Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Column(
                                            children: <Widget>[
                                              SizedBox(height:22),
                                              Container(
                                                padding: EdgeInsets.only(),
                                                margin:EdgeInsets.only(right: 11),
                                                width: 22,
                                                height: 22,
                                                decoration: new BoxDecoration(
                                                    color: Colors.black,
                                                    shape: BoxShape.circle,
                                                ),
                                                child: Center(child: Text('${index + 1}', style: TextStyle(color: Colors.white,  fontSize: 13, fontWeight: FontWeight.bold)))
                                              ),
                                            ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //Text(document[index].data['locID'],  style: TextStyle( fontSize: 18, fontWeight: FontWeight.w700)),
                                            Container(
                                              width: 345,
                                              child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(DateFormat('yyyy-MM-dd').format(date2).toString(), style: TextStyle(fontSize: 14,  fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.5))),
                                                    Text(timeago.format(date1), style: TextStyle(fontSize: 14,  fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.5))),
                                                  ],
                                              ),
                                            ),
                                            SizedBox(height: 3),
                                            Container(
                                              width: 320,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(snap.data.documents.toList()[0].data['placeName'],  style: TextStyle( fontFamily: 'SFProText', letterSpacing: -0.6, fontSize: 18, fontWeight: FontWeight.w700)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(snap.data.documents.toList()[0].data['placeCategory'],  style: TextStyle(  fontSize: 14, fontWeight: FontWeight.bold)),
                                            Text('Rate you gave: ', style: TextStyle(fontSize: 13,  fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.5))),
                                            Row(
                                                children: <Widget>[
                                                    SizedBox(width: 6),
                                                    SmoothStarRating(
                                                    rating: document[index].data['rate'].toDouble(),
                                                    size: 19,
                                                    isReadOnly: true,
                                                    filledIconData: Icons.stars,
                                                    defaultIconData: Icons.stars,
                                                    starCount: 5,
                                                    allowHalfRating: false,
                                                    spacing:  - 1,
                                                    borderColor: Colors.grey,
                                                    //color: Colors.black54,
                                                  ),
                                                ],
                                            ),
                                            Text('Review you made: ', style: TextStyle(fontSize: 13,  fontWeight: FontWeight.bold, color: Colors.black87.withOpacity(0.5))),
                                            Row(
                                                children: <Widget>[
                                                  SizedBox(width: 6),
                                                  Container(
                                                    width: 310,
                                                    child: Text(document[index].data['review'].toString(), textAlign: TextAlign.left),
                                                  ),
                                                ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Padding(
                                      padding:EdgeInsets.symmetric(horizontal:1.0),
                                      child: Container(
                                          height:1.0,
                                          width:380,
                                          color:Colors.grey.withOpacity(0.5)
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                        ),
                      );
                    });

              }
          ),
        ],
      ),
    );
  }
}



