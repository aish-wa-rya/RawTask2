import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';


//TODO use this https://stackoverflow.com/questions/53194574/flutter-start-app-with-different-routes-depending-on-login-state to connect to firebase

class AuthService {
  ///Service providing authentication

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  String firebaseUID;

  Future<String> checkUID() async {
    /// Checks the user UID and returns it as a string
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      this.firebaseUID = user.uid;
      return user.uid;
    } catch (e) {
      print("failed");
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    /// Checks if the user is logged in
    /// Returns a bool
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      print('[L] auth:isLoggedIn ' + user.uid);
      return true;
    } catch (e) {
      print("failed log in");
      return false;
    }
  }

  Future<FirebaseUser> getUser() async {
    /// Gets the firebase user
    try {
      final FirebaseUser user = await _firebaseAuth.currentUser();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
//    Database().databaseDestructor();
    try{
      return await _firebaseAuth.signOut();
    }catch(e){
      print(e.toString());
      print("ERROR SIGNING OUT");
      return null;
    }
  }

  Future signInGoogle() async{
    /**
     * Signs in with google, returns a future (isn't used)
     */
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null){
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      AuthResult result = await _firebaseAuth.signInWithCredential(credential);
      //print("IS NEW USER?");
      FirebaseUser user = await _firebaseAuth.currentUser();
//      print(result.additionalUserInfo.isNewUser);

      if(result.additionalUserInfo.isNewUser){
        print("[L][Auth] NEW USER GOOGLE");
        Database().generateFirebaseUserInfo(user.uid);
      }

      await Database().setLocalUser(user.uid);

      print("[L][Auth] Google sign in with " + user.uid);
      return Database().getLocalUser();
    }
    return null;
  }

  Future signInAnon() async {
    /**
    Signs in the user anonymously, i.e. not with google
        and user data is kept in firebase
     */

    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();

      FirebaseUser user = result.user;

      if(result.additionalUserInfo.isNewUser){
        Database().generateFirebaseUserInfo(user.uid);
      }
      print("[L][Auth] Anon sign in with " + user.uid);

      await Database().setLocalUser(user.uid);

      return Database().getLocalUser();

    }catch(e){
      print(e.toString());
      return null;
    }
  }
}




















