import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netninja/services/auth.dart';
import 'package:netninja/shared/loading.dart';
import 'package:netninja/shared/constant.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '' ;
  String password = '' ;
  String error = '';

  // Initially password is obscure
  bool _obscureText = true;

  // Toggles the password show status
  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Colors.red[50],
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(30.0, 120.0,30.0, 5.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    child: Image.asset('assets/images/map.png'),
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    keyboardType:  TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    decoration: new InputDecoration(
                        filled: true,
                        fillColor: Colors.red[50],
                        errorBorder: CustOutlineInputBorder,
                        focusedErrorBorder: CustOutlineInputBorder,
                        enabledBorder: CustOutlineInputBorder,
                        focusedBorder: CustOutlineInputBorder,
                        hintText: 'Email',
                        hintStyle: TextHint1,
                        prefixIcon: Icon(Icons.mail, color: Colors.red,)
                    ),
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                        setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    obscureText: _obscureText,
                    decoration: new InputDecoration(
                        filled: true,
                        fillColor: Colors.red.withOpacity(0.1),
                        errorBorder: CustOutlineInputBorder,
                        focusedErrorBorder: CustOutlineInputBorder,
                        enabledBorder: CustOutlineInputBorder,
                        focusedBorder: CustOutlineInputBorder,
                        hintText: 'Password',
                        hintStyle: TextHint1,
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
                  SizedBox(height: 30.0),
                  ButtonTheme(
                    height: 55,
                    minWidth: 360,
                    child: RaisedButton(
                      elevation: 1.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(3.5)
                      ),
                      color: Colors.red,
                      child: Text(
                        'LOGIN',
                        style: new TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic  result = await _auth.signInWithEmailAndPassword(email, password);
                          if ( result == null) {
                            setState(() {
                              error = 'could not sign in with those credentials';
                              loading = false;
                            } );
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 35.0),
                  FlatButton(
                    onPressed: widget.toggleView,
                    child: Text(
                        'Create an Account if you\'re new',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  )
                ],
              ))
      ),
    );
  }
}
