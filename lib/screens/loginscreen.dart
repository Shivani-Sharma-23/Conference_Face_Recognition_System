import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectapp/screens/homescree.dart';
import 'package:projectapp/google_authentication/authentication.dart';
import 'package:projectapp/widgets/custom_button.dart';
import 'package:projectapp/widgets/googlbutton.dart';
import 'package:projectapp/widgets/topbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: TopBarFb3(title: 'WELCOME TO', upperTitle: "Mukul's App"),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Center(child: Image.network('https://cdn-images-1.medium.com/max/1600/1*NqrtHQbUxB7PWBsWeFZENA.jpeg')),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 150),
                  child: GoogleBtn1(
                    onPressed: () async {
                      bool res = await GoogleAuth().signinwithgoogle();
                      if (res) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Homescreen()),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
