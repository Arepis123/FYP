  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
  import 'package:netninja/services/auth.dart';
  import 'package:netninja/shared/loading.dart';
  import 'package:netninja/shared/constant.dart';

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
    bool _obscureText = true;

    String email = '' ;
    String password = '' ;
    String name = '' ;
    String age = '' ;
    String gender = '' ;
    String error = '';
    String _selectedType;
    List <String> genderList = <String> ['Male','Female'];

    void _toggleVisibility() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    DateTime selectedDate =DateTime.now();
    TextEditingController _date = new TextEditingController();

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1901, 1),
          lastDate: DateTime.now());
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          _date.value = TextEditingValue(text: DateFormat('dd-MM-yyyy').format(picked).toString());
        });
    }

    @override
    Widget build(BuildContext context) {
        return loading ? Loading() : Scaffold(
            backgroundColor: Colors.white,
            body:SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(30.0, 100.0,30.0, 0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Sign Up', style: TextStyle( fontSize: 38, fontWeight: FontWeight.w400, color: Colors.black))
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
                                  fillColor: Colors.red[50],
                                  errorBorder: CustOutlineInputBorder,
                                  focusedErrorBorder: CustOutlineInputBorder,
                                  enabledBorder: CustOutlineInputBorder,
                                  focusedBorder: CustOutlineInputBorder,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
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
                                  fillColor: Colors.red[50],
                                  errorBorder: CustOutlineInputBorder,
                                  focusedErrorBorder: CustOutlineInputBorder,
                                  enabledBorder: CustOutlineInputBorder,
                                  focusedBorder: CustOutlineInputBorder,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
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
                                  fillColor: Colors.red[50],
                                  errorBorder: CustOutlineInputBorder,
                                  focusedErrorBorder: CustOutlineInputBorder,
                                  enabledBorder: CustOutlineInputBorder,
                                  focusedBorder: CustOutlineInputBorder,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                                  hintText: 'Name',
                                  hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                  prefixIcon: Icon(Icons.account_circle, color: Colors.red,)
                              ),
                              validator: (val) => val.isEmpty ? 'Enter name' : null,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                            ),
                            SizedBox(height: 20.0),
                            GestureDetector(
                                onTap: () => _selectDate(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _date,
                                    keyboardType: TextInputType.datetime,
                                  readOnly: true,
                                  decoration: new InputDecoration(
                                      filled: true,
                                      fillColor: Colors.red[50],
                                      errorBorder: CustOutlineInputBorder,
                                      focusedErrorBorder: CustOutlineInputBorder,
                                      enabledBorder: CustOutlineInputBorder,
                                      focusedBorder: CustOutlineInputBorder,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                                      hintText:'Enter birth date',
                                      hintStyle: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey),
                                      prefixIcon: Icon(Icons.calendar_today, color: Colors.red,)
                                  ),
                              ),
                                ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              height: 52,
                              margin: EdgeInsets.all(0.2),                                                                                        // spacing outside border
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3.5),        // spacing inside border
                              //padding: EdgeInsets.symmetric(horizontal: 73, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(3.5),
                                border: Border.all(
                                    color: Colors.red,style: BorderStyle.solid, width: 1.5),
                              ),
                                child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text('Choose gender', style: TextStyle(fontFamily: 'SFUIDisplay', fontSize: 16.0, fontWeight: FontWeight.bold, color:  Colors.grey)),
                                    value: _selectedType,
                                    onChanged: (newValue) {
                                        setState(() {
                                            _selectedType = newValue;
                                        });
                                    },
                                    items: genderList.map((jantina) {
                                        return DropdownMenuItem(
                                            child: new Text(jantina),
                                            value: jantina,
                                        );
                                    }).toList(),
                                ),

                          ),
                            SizedBox(height: 46.0),
                            ButtonTheme(
                                height: 55,
                                minWidth: 360,
                                child: RaisedButton(
                                    elevation: 1.0,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(3.5)
                                    ),
                                  color: Colors.red,
                                  child: Text( 'REGISTER',
                                      style: new TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold )
                                  ),
                                  onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                          gender = _selectedType;
                                          dynamic result = await _auth
                                                .registerWithEmailAndPassword(email, password,name,selectedDate,gender);
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
                            SizedBox(height: 35.0),
                            FlatButton(
                              onPressed: widget.toggleView,
                              //onPressed: () {print(DateFormat('dd-MM-yy').format(_date));},
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
