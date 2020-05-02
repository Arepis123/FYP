import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:netninja/models/newuser.dart';

class DatabaseService {

  final String uid ;
  final String email;
  DatabaseService({ this.uid, this.email });


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference reviewCollection = Firestore.instance.collection('reviews');
  final CollectionReference userCollection= Firestore.instance.collection("users");


  Future createUser(NewUser user) async {
      try {
          await userCollection.document(user.id).setData(user.toJson());
      } catch (e) {
          return e.message;
      }
  }

  // sudah ditinggalkan cara kuno ini
  Future updateUserData(String name, String age, String gender) async {
      return await reviewCollection.document(uid).setData({
          'uid': uid,
          'Email': email,
          'Name': name,
          'Age': age,
          'Gender': gender,
      });
  }

  Future<String> getCurrentUID() async {
      return (await _firebaseAuth.currentUser()).uid;
  }

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    }  else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    if (isLoggedIn()) {

//            Firestore.instance.collection('testcrud').add(carData).catchError((e) {
//                print(e);
//            });

      Firestore.instance.runTransaction((Transaction crudTransaction) async {
        CollectionReference reference = Firestore.instance.collection('testcrud');
        reference.add(carData);
      });

    }  else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return Firestore.instance.collection('testcrud').snapshots();
  }

  updateData( selectedDoc, newValues) {
    Firestore.instance
        .collection('testcrud')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(docId) {
    Firestore.instance
        .collection('testcrud')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

}