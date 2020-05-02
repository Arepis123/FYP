  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:netninja/services/auth.dart';
  import 'package:netninja/shared/constants.dart';
  import 'package:netninja/shared/loading.dart';

  class Register extends StatefulWidget {

    final Function toggleView;
    Register({ this.toggleView });

    @override
    _RegisterState createState() => _RegisterState();
  }

  class _RegisterState extends State<Register> {

    final AuthService _auth = AuthService();
    final _formKey = GlobalKey<FormState>();

    bool loading = false;
    // Initially password is obscure
    bool _obscureText = true;

    // text field state
    String email = '' ;
    String password = '' ;
    String name = '' ;
    String age = '' ;
    String gender = '' ;
    String error = '';
    String _selectedType;
    List <String> genderList = <String> ['Male','Female'];

    // Toggles the password show status
    void _toggleVisibility() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    @override
    Widget build(BuildContext context) {
        return loading ? Loading() : Scaffold(
            backgroundColor: Colors.red[50],
            body:SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(30.0, 70.0,30.0, 5.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Sign Up', style: TextStyle( fontSize: 38, fontWeight: FontWeight.w600))
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                            SizedBox(height: 30.0),
                            TextFormField(
                              keyboardType:  TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              decoration: new InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
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
                                  hintText: 'Email',
                                  hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                  prefixIcon: Icon(Icons.mail, color: Colors.red,)
                              ),
                              validator: (val) => val.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              obscureText: _obscureText,
                              decoration: new InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
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
                                  hintText: 'Password',
                                  hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                  prefixIcon: Icon(Icons.lock, color: Colors.red),
                                  suffixIcon: IconButton(
                                    onPressed: _toggleVisibility,
                                    icon: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                  )
                              ),
                              validator: (val) => val.length < 6 ? 'Password must be at least  6 characters' : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType:  TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              decoration: new InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
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
                                  hintText: 'Name',
                                  hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                  prefixIcon: Icon(Icons.account_circle, color: Colors.red,)
                              ),
                              validator: (val) => val.isEmpty ? 'Enter name' : null,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType:  TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              decoration: new InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
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
                                  hintText: 'Age',
                                  hintStyle: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                  prefixIcon: Icon(Icons.child_care, color: Colors.red,)
                              ),
                              validator: (val) => val.isEmpty ? 'Enter age' : null,
                              onChanged: (val) {
                                setState(() => age = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              
                              margin: EdgeInsets.all(0.2),                                                                                        // spacing outside border
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3.5),        // spacing inside border
                              //padding: EdgeInsets.symmetric(horizontal: 73, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3.5),
                                border: Border.all(
                                    color: Colors.red,style: BorderStyle.solid, width: 1.5),
                              ),
                                child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text('Please choose a location', style: TextStyle(fontFamily: 'SFDisplay', fontSize: 18.0, fontWeight: FontWeight.bold, color:  Colors.grey)),

                                    value: _selectedType,
                                    onChanged: (newValue) {
                                        setState(() {
                                            _selectedType = newValue;
                                        });
                                    },
                                    items: genderList.map((location) {
                                        return DropdownMenuItem(
                                            child: new Text(location),
                                            value: location,
                                        );
                                    }).toList(),
                                ),

                          ),
                            SizedBox(height: 20.0),
                            ButtonTheme(
                                height: 55,
                                minWidth: 360,
                                child: RaisedButton(
                                    elevation: 5.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(3.5)
                                    ),
                                  color: Colors.red,
                                  child: Text( 'Register',
                                      style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                          gender = _selectedType;
                                          dynamic result = await _auth
                                                .registerWithEmailAndPassword(email, password,name,age,gender);
                                          if (result == null) {
                                              setState(() {
                                                  error = 'Please suppy a valid email';
                                                  loading = false;
                                              } );
                                          }
                                      }
                                   }
                                ),
                            ),
                            SizedBox(height: 20.0),
                            FlatButton(
                              onPressed: widget.toggleView,
                              child: Text(
                                  'Already have Account ?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                            ),
                            SizedBox(height: 12.0),
                        ],
                      ))
            ),
        );
    }
  }
