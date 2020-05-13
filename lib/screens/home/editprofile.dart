import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netninja/screens/profile.dart';
import 'package:netninja/services/database.dart';
import 'package:netninja/shared/dialogbox.dart';
import 'package:netninja/shared/loading.dart';

class EditProfile extends StatefulWidget {

  final String userId ;
  final String name;
  final String gender;
  final DateTime age;
  EditProfile({ this.userId, this.name, this.gender, this.age});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  File _image ;
  bool swap1 = true;
  bool swap2 = false;
  TextEditingController _nameController;
  TextEditingController _genderController;
  TextEditingController _ageController;

  Future _getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
          _image = image;
          print('_image: $_image');
       });
  }

  DateTime selectedDate =DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _ageController.value = TextEditingValue(text: DateFormat('dd-MM-yyyy').format(picked).toString());
      });
  }

  void _swap() {
      setState(() {
          swap1 =! swap1;
          swap2 =! swap2;
      });
  }

  @override
  void initState() {
    super.initState();
    _nameController = new TextEditingController(text: widget.name);
    _genderController = new TextEditingController(text: widget.gender);
    _ageController = new TextEditingController(text:DateFormat('dd-MM-yyyy').format(widget.age));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Edit Profile",style: TextStyle( fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream:Firestore.instance.collection('users').document(widget.userId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              return   Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        onTap: _getImage,
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
                     controller: _nameController,
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
                    Visibility(
                      visible: swap1,
                      child: TextFormField(
                        readOnly: true,
                        controller: _genderController,
                        onTap: () {
                            setState(() {
                              _genderController = new TextEditingController(text:'Female');
                              _swap();
                            });
                        },
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
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: swap2,
                      child: TextFormField(
                        readOnly: true,
                        controller: _genderController,
                        onTap: () {
                          setState(() {
                            _genderController = new TextEditingController(text:'Male');
                            _swap();
                          });
                        },
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
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _ageController,
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
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: snapshot.data['email'],
                      readOnly: true,
                      decoration: new InputDecoration(
                          fillColor: Colors.grey.withOpacity(0.12),
                          filled: true,
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
                        fillColor: Colors.grey.withOpacity(0.12),
                        filled: true,
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
                          child: Text(  'Submit',
                            style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold ),
                          ),
                          onPressed: () async {
                            final action = await DialogBox.yesAbortDialog(context, 'Update profile', 'Are you sure you want to update your profile?');
                            if (action == DialogAction.yes) {
                                setState(() {
                                    if (_image != null) {
                                        DatabaseService(uid: widget.userId,file: _image).uploadImage();
                                        print('Selamat sampai ke file database.dart');
                                    }
                                        DatabaseService( uid: widget.userId ).updateProfile(_nameController.text,_genderController.text,selectedDate);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(userId: widget.userId)));
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
                                        //Navigator.pop(context);
                                });
                            }
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
