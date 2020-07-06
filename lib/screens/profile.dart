
import 'package:age/age.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netninja/screens/home/editprofile.dart';
import 'package:netninja/shared/loading.dart';

class Profile extends StatefulWidget {

  final String userId ;
  Profile({ this.userId });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  AgeDuration age;
  DateTime birthday = DateTime(1997, 12, 30);
  DateTime today = DateTime.now();


  @override
  void initState() {
//    age = Age.dateDifference(
//        fromDate: birthday, toDate: today, includeToDate: false);
//      super.initState();
//    final Age =  today.difference(birthday).inDays;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Personal Information",style: TextStyle( fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
              child: StreamBuilder(
                  stream:Firestore.instance.collection('users').document(widget.userId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Loading();
                    }
                    return  Container(
                      padding: EdgeInsets.all(15.0),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              Tooltip(
                                message: 'Picture can be changed in edit session',
                                child: Center(
                                    child: Container(
                                        width: 125,
                                        height:  125,
                                        margin: EdgeInsets.only(top: 30, bottom: 20),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(width: 5, color: Colors.red),
                                            image: DecorationImage(
                                                image: NetworkImage( snapshot.data['imageURL']),
                                                fit: BoxFit.fill),
                                        ),
                                    ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                  readOnly: true,
                                  initialValue: snapshot.data['name'],
                                  decoration: new InputDecoration(
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
                                      hintText: 'Enter name',
                                      hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                      prefixIcon: Icon(Icons.face,color:  Colors.red),
                                  ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                  initialValue: snapshot.data['gender'],
                                  readOnly: true,
                                  decoration: new InputDecoration(
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
                                    hintText: 'Enter gender',
                                    hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                        prefixIcon: Icon(Icons.wc,color:  Colors.red),
                                  ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                  initialValue: DateFormat('dd-MM-yyyy').format(snapshot.data['age'].toDate()).toString(),
                                  readOnly: true,
                                  decoration: new InputDecoration(
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
                                      hintText: 'Enter age',
                                      hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                      prefixIcon: Icon(Icons.calendar_today,color:  Colors.red),
                                  ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                    initialValue: snapshot.data['email'],
                                    readOnly: true,
                                    decoration: new InputDecoration(
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
                                        prefixIcon: Icon(Icons.email,color:  Colors.red),
                                    ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                    readOnly: true,
                                    obscureText: true,
                                    autofocus: false,
                                    decoration: new InputDecoration(
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
                                        hintText: '*******',
                                        hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.black),
                                        prefixIcon: Icon(Icons.lock,color:  Colors.red),
                                    ),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                  height: 55,
                                  child: new RaisedButton(
                                      elevation: 0.0,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(2.0)),
                                      color: Colors.red,
                                      child: Text(  'Edit',
                                          style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => EditProfile(userId: widget.userId, name: snapshot.data['name'], gender: snapshot.data['gender'],age: snapshot.data['age'].toDate())));
                                      },
                                  )
                              ),
                          ],
                      ),
                    );
                  }
              ),
            ),
    );
  }

}
