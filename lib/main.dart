import 'package:flutter/material.dart';
import 'package:netninja/screens/wrapper.dart';
import 'package:netninja/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:netninja/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: new ThemeData(
                primarySwatch: Colors.red,
                fontFamily:  'SFUIDisplay',
                textTheme: TextTheme(subhead: TextStyle(fontWeight: FontWeight.bold)),
            ),
            home: Wrapper(),
        )
    );
  }
}
