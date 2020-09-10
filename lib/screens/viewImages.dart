import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ViewImage extends StatefulWidget {

  final String locID;
  ViewImage({this.locID});

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {

  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  List<NetworkImage> _listOfImages = <NetworkImage>[];

  setImages() {
    Firestore.instance.collection('images').where('locID', isEqualTo: widget.locID).getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        _listOfImages = [];
        for (int i=0; i<docs.documents.length; i++) {
          for(int x=0; x<docs.documents[i].data['urls'].length; x++)
            _listOfImages.add(NetworkImage(docs.documents[i].data['urls'][x]));
        }
      }
    });
  }

  @override
  void initState() {
      setImages();
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("View Image",style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body:  Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('images').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        _listOfImages = [];
                        for (int i = 0; i < snapshot.data.documents[index].data['urls'].length; i++) {
                          _listOfImages.add(NetworkImage(snapshot.data.documents[index].data['urls'][i]));
                        }
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(10.0),
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Carousel(
                                  boxFit: BoxFit.cover,
                                  images: _listOfImages,
                                  autoplay: false,
                                  indicatorBgPadding: 5.0,
                                  dotPosition: DotPosition.bottomCenter,
                                  animationCurve: Curves.fastOutSlowIn,
                                  animationDuration:
                                  Duration(milliseconds: 2000)),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                            )
                          ],
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
//child: GridView.count(
//scrollDirection: Axis.vertical,
//crossAxisCount: 2,
//childAspectRatio: 1.0,
//mainAxisSpacing: 4.0,
//crossAxisSpacing: 1.0,
//children: _listOfImages.map((i){
//return  Container(
//height: 200,
//width: 362,
//padding: EdgeInsets.only(right:10),
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(5.0),
//color: Colors.grey,
//image: DecorationImage(image: NetworkImage(
//i.url),
//fit: BoxFit.cover),
//),
//);
//}).toList(),
//)