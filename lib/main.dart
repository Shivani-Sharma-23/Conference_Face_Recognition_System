import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:projectapp/FaceRecognisation/Face_homescreen.dart';
import 'package:projectapp/FaceRecognisation/RegistrationScreen.dart';
import 'package:projectapp/screens/homescree.dart';
import 'package:projectapp/screens/meetingScreen.dart';
import 'package:projectapp/utils/colors.dart';
import 'package:projectapp/screens/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projectapp/google_authentication/authentication.dart';
import 'package:provider/provider.dart';

import 'FaceRecognisation/RecognitionScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
        //  MultiProvider(
        //   providers: [
        //     // ChangeNotifierProvider(create: (_) => croppedprovider()), // Register your provider here
        //   ],
        //   child:
        MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conference App',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        // scaffoldBackgroundColor: Colors.black
      ),
      routes: {
        'login': (context) => LoginScreen(),
        // 'meetingscreen':(context) => MeetingScreen(),
        'home': (context) => Homescreen(),
        '/recognition': (context) => RecognitionScreen(),
        '/recognition': (context) => Facehomescreen(),
        '/recognition': (context) => RegistrationScreen(),
      },
      home: StreamBuilder(
        stream: GoogleAuth().authstream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return Homescreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
    // );
  }
}
