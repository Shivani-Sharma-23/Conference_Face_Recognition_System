import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectapp/google_authentication/authentication.dart';
class GoogleAuth {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestor=FirebaseFirestore.instance;
Stream<User?> get authstream=>_auth.authStateChanges();
Future<bool>signinwithgoogle() async{

try {
 final GoogleSignInAccount ?signin=await GoogleSignIn().signIn(); 
 final GoogleSignInAuthentication ?googleauth=await signin?.authentication;
 final Credential=GoogleAuthProvider.credential(accessToken:googleauth?.accessToken ,idToken:googleauth?.idToken);
 final UserCredential userCredential=await _auth.signInWithCredential(Credential);
 User? user=userCredential.user;
 if (user!=null) {
   if (userCredential.additionalUserInfo!.isNewUser) {
     _firestor.collection('bhai ki details').doc(user!.uid).set(
    {
      'user':user.displayName,
      'uid':user.uid,
      'photo':user.photoURL,
    }
     );
    
   }
   return true;
 }

} catch (e) {
  print('Exception occurred: $e');
}
return false;
}
 void signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}