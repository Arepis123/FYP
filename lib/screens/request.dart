import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'drawer.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {

  String placeName, placeDetails;

  getPlaceName(placeName) {
      this.placeName = placeName;
  }

  getPlaceDetails(placeDetails) {
      this.placeDetails = placeDetails;
  }

  createData() {
      DocumentReference ds = Firestore.instance.collection('request').document('Ananas').collection('sajaje').document('fd');
      Map<String,dynamic> place = {
          "placeName": placeName,
          "placeDetails": placeDetails,
      };
      ds.setData(place).whenComplete(() {
          print("Task created");
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Place'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding:  EdgeInsets.all(15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 15.0),
                      Text('Location Name' , style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.black87)),
                      const SizedBox(height: 10.0),
                      TextFormField(
//                        focusNode: FocusNode(),                                 // readonly
//                        enableInteractiveSelection: false,             // readonly
//                        readOnly: true,                                                        // readonly
                        maxLines: 1,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
//                          fillColor: Colors.grey.withOpacity(0.12),
//                          filled: true,
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
                          // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[300])),
                          hintText: 'Name',
                          hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                        onChanged: (String placeName) {
                          getPlaceName(placeName);
                        },
                      ),
                      const SizedBox(height: 15.0),
                      Text('Location Details' , style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.black87)),
                      const SizedBox(height: 10.0),
                      TextFormField(
//                        focusNode: FocusNode(),                                 // readonly
//                        enableInteractiveSelection: false,             // readonly
//                        readOnly: true,                                                        // readonly
                        maxLines: 1,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
//                          fillColor: Colors.grey.withOpacity(0.12),
//                          filled: true,
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
                          // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[300])),
                          hintText: 'Details',
                          hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                        ),
                        onChanged: (String placeDetails) {
                            getPlaceDetails(placeDetails);
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
                                  createData();
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => Request()));
                                },
                                color: Colors.red,
                                //textColor: Colors.white,
                                child: Text("Submit",
                                    style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold )),
                              ),
                          )
                        ],
                      )
                    ]
                ),
          ),
        )
    );
  }
  }

