import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:netninja/screens/drawer.dart';

class Home extends StatefulWidget {

  final String uuid ;
  Home({ this.uuid });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    print('Home: your uid is ' + widget.uuid);
//    FirebaseAuth.instance.currentUser().then(setUser);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: willPopBack,
        child: Scaffold(
          drawer: MainDrawer(uid: widget.uuid),
          appBar: AppBar(
            title: Text('JomShare', style: TextStyle( fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
        ),
    );
  }

Future <bool> willPopBack() async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text('Do you really want to exit the application?', style: TextStyle(  fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'SFUIDisplay')),
          actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('NO', style: TextStyle(  fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'SFUIDisplay')),
              ),
            FlatButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('YES', style: TextStyle(  fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'SFUIDisplay')),
            )
          ],
      )
  );
}

}


