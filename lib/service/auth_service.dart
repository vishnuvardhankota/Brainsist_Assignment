import 'package:brainsist/model/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  // SignUp with Email & Password
  Future<void> signUp(
      Client user, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: password)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(value.user?.uid)
            .set({
          'id': value.user?.uid,
          'userName': user.userName,
          'phoneNumber': user.phoneNumber,
          'email': user.email,
        });
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
    notifyListeners();
  }
  
  // Login with Email & Password
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
    notifyListeners();
  }
  
  // Google Sign IN
  Future<void> handleSignIn(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
    try {
      var googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      var googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
    }  on PlatformException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar(reason: SnackBarClosedReason.remove)
        ..showSnackBar(SnackBar(
          content: Text(e.code),
          backgroundColor: Theme.of(context).errorColor,
        ));
      return;
    }
  }
}
