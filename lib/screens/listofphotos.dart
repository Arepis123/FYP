import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netninja/shared/loading.dart';

class ListOfPhotos extends StatefulWidget {

  final String uid;
  final String revID;
  final String locID;
  ListOfPhotos({this.uid, this.revID, this.locID});

  @override
  _ListOfPhotosState createState() => _ListOfPhotosState();
}

class _ListOfPhotosState extends State<ListOfPhotos> {

  bool adedata =false;

  countReviewUser() {
    Firestore.instance.collection('images').where('locID', isEqualTo: widget.locID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i=0; i<docs.documents.length; i++) {
          adedata = true;
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
          child: StreamBuilder(
              stream: Firestore.instance.collection('images').where('locID', isEqualTo: widget.locID).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                }
                //final List<DocumentSnapshot> document = snapshot.data.documents;
                else return adedata ? Material(
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
                          Center(child: Text(snapshot.data['locID'], style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16))),
                          Center(child: Text(snapshot.data['uID'], style: TextStyle( fontWeight: FontWeight.w500, fontSize: 14)))
                        ],
                      )
                  ),
                ) : Container(height: 20.0, width: 100.0, child: Text('data')) ;
              }
          ),
      );

  }
}

class justIcon extends StatefulWidget {

  final String uid;
  justIcon({this.uid});

  @override
  _justIconState createState() => _justIconState();
}

class _justIconState extends State<justIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: <Widget>[
                StreamBuilder(
                    stream: Firestore.instance.collection('images').where('uID', isEqualTo:  widget.uid).snapshots(),
                    builder: (context,  snapshot) {
                      if (!snapshot.hasData) {
                        return Loading();
                      }
                        return GestureDetector(
                          onTap: () {
                          },
                          child: Icon(
                              Icons.image,
                          ),
                        );
                    }
                ),
            ],
        ),
    );
  }
}
