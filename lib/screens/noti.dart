import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:netninja/shared/loading.dart';

class Noti extends StatefulWidget {

  final String uid;
  Noti({this.uid});

  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification' , style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0,10.0, 5.0),
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance.collection('notifications').snapshots(),
                  builder:  (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                    if(!snapshot.hasData) {
                      return Loading();
                    }
                    final List<DocumentSnapshot> document = snapshot.data.documents;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount:  document.length,
                       itemBuilder: (BuildContext context, int index) {
                         String text = document[index].data['text'];
                         return Card(
                           elevation: 3,
                           child: InkWell(
                             splashColor: Colors.red.withAlpha(30),
                             onTap: () { },
                             child: ListTile(
                               title: Text('Notification', style: new TextStyle(fontSize: 16, letterSpacing: 0)),
                               subtitle: Text(text, style: new TextStyle( fontWeight: FontWeight.bold,letterSpacing: 0)),
                               onTap: (){},
                             ),
                           ),
                         );
                       }
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
