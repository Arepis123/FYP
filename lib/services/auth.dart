import 'package:firebase_auth/firebase_auth.dart';
import 'package:netninja/models/newuser.dart';
import 'package:netninja/models/user.dart';
import 'package:netninja/services/database.dart';

class AuthService {

    final FirebaseAuth _auth = FirebaseAuth.instance;

    NewUser _currentUser;
    NewUser get currentUser => _currentUser;
    String role = 'User';
    int noReview = 0;
    int noPlaceAdded = 0;
    String imageURL= 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQsKNbGtuXiKKlaS0oDJ72NksP7CS-tl7YInR67NXNTgfvTfkXk&usqp=CAU';

    // create user obj based on FirebaseUser
    User _userFromFirebaseUser(FirebaseUser user) {
            return user != null ? User(uid: user.uid) : null;
    }

    // auth change user stream
    Stream<User> get user {
            return _auth.onAuthStateChanged
                .map(_userFromFirebaseUser);
    }

    // sign in anonymously
    Future signInAnon() async {
        try {
            AuthResult result = await _auth.signInAnonymously();
            FirebaseUser user = result.user;
            return _userFromFirebaseUser(user);
        } catch(e) {
          print(e.toString());
          return null;
        }
    }

    // sign in with email and password
    Future registerWithEmailAndPassword(String email, String password, String name, DateTime age, String gender) async {
        try {

            // create user authenticate
            AuthResult result = await _auth.createUserWithEmailAndPassword(email:email, password: password);
            FirebaseUser user = result.user;

            //create user profile
            _currentUser = NewUser(
                id: result.user.uid,
                email: email,
                name: name,
                age: age,
                gender: gender,
                role: role,
                imageURL: imageURL,
                noReview: noReview,
                noPlaceAdded: noPlaceAdded,
            );
            await DatabaseService().createUser(_currentUser);

            return _userFromFirebaseUser(user);
        }  catch(e) {
            print(e.toString());
            return null;
        }
    }

    // register with email and password
    Future signInWithEmailAndPassword( String email, String password) async {
        try {
            AuthResult result = await _auth.signInWithEmailAndPassword(email:email, password: password);
            FirebaseUser user = result.user;

            //  await  DatabaseService(uid: user.uid, email: user.email).updateUserData('New User', 'Not set', 'Not set');

            //  create a new document for the user with the uid
            return _userFromFirebaseUser(user);
        }  catch(e) {
            print(e.toString());
            return null;
        }
    }

    // sign out
    Future signOut() async {
        try {
            return await _auth.signOut();
        }  catch(e){
            print(e.toString());
            return null;
        }
    }

}