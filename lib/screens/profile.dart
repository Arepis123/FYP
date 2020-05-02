import 'package:flutter/material.dart';
import 'package:netninja/models/newuser.dart';

class Profile extends StatefulWidget {

  final String userId ;
  Profile({ this.userId });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Profile",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 125,
                    height:  125,
                    margin: EdgeInsets.only(top: 30, bottom: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 5, color: Colors.red),
                      image: DecorationImage(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQsKNbGtuXiKKlaS0oDJ72NksP7CS-tl7YInR67NXNTgfvTfkXk&usqp=CAU'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(),                                 // readonly
                  enableInteractiveSelection: false,             // readonly
                  readOnly: true,                                                        // readonly
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.text,
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
                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[300])),
                    hintText: 'Muhd Hafiz',
                    hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.black),
                    prefixIcon: Icon(Icons.face,color:  Colors.red),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(),                                 // readonly
                  enableInteractiveSelection: false,             // readonly
                  readOnly: true,                                                        // readonly
                  maxLines: 1,
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
                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[300])),
                    hintText: 'Male',
                    hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.black),
                    prefixIcon: Icon(Icons.wc,color:  Colors.red),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(),                                 // readonly
                  enableInteractiveSelection: false,             // readonly
                  readOnly: true,                                                        // readonly
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
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
                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[300])),
                    hintText: '23',
                    hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.black),
                    prefixIcon: Icon(Icons.child_care,color:  Colors.red),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(),                                 // readonly
                  enableInteractiveSelection: false,             // readonly
                  readOnly: true,                                                        // readonly
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
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
                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[300])),
                    hintText: 'test@test.com',
                    hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.black),
                    prefixIcon: Icon(Icons.email,color:  Colors.red),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  focusNode: FocusNode(),                                 // readonly
                  enableInteractiveSelection: false,             // readonly
                  readOnly: true,                                                        // readonly
                  maxLines: 1,
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
                    // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[300])),
                    hintText: '*******',
                    hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.black),
                    prefixIcon: Icon(Icons.lock,color:  Colors.red),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                    height: 55,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(2.0)),
                      color: Colors.red,
                      child: Text('Edit',
                        style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold ),
                        textAlign: TextAlign.right,
                      ),
                      onPressed: () {
                        //Navigator.pop(context);
                        //navigateToMainPage(context);
                        print(widget.userId);
                      },
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
