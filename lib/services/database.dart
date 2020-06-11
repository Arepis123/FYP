
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:netninja/models/newuser.dart';

class DatabaseService {

  final String uid ;
  final String email;
  final File file;
  DatabaseService({ this.uid, this.email, this.file });

  final CollectionReference reviewCollection = Firestore.instance.collection('reviews');
  final CollectionReference userCollection= Firestore.instance.collection("users");
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://netninja-6cb94.appspot.com');


  Future createUser(NewUser user) async {
      try {
          await userCollection.document(user.id).setData(user.toJson())
              .whenComplete((){
                  print('New User Created');
              });
      } catch (e) {
          return e.message;
      }
  }

  void _changePassword(String password) async{
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      print("Succesfull changed password");
    }).catchError((error){
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  // Upload profile picture into FireStorage
  uploadImage() async {
    String filePath = 'profiles/${DateTime.now()}.png' ;
    StorageUploadTask task = _storage.ref().child(filePath).putFile(file);

    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();
    updateImageURL(url);
    print('Download URL :  $url');

    return url;
  }

  // Update profile picture's link
  Future updateImageURL(url) async {
      return await userCollection.document(uid).updateData({
          'imageURL': url.toString()

      });
  }

  Future updateProfile(String name,String gender,DateTime age) async {
    return await userCollection.document(uid).updateData({
      'name': name,
      'gender': gender,
      'age': age,
    })
        .whenComplete((){
            print('User Profile Updated');
        });
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