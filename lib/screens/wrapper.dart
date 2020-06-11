import 'package:flutter/material.dart';
import 'package:netninja/screens/authenticate/authenticate.dart';
import 'package:netninja/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:netninja/models/user.dart';

class Wrapper  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return Home or Authenticate widget
    if (user == null) {
         return Authenticate();
    } else {
        return Home(uuid: user.uid);
    }
  }
}
