// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'ML/Recognition.dart';
// // import 'RecognitionScreen.dart';
// // import 'RegistrationScreen.dart';

// import 'package:projectapp/RegistrationScreen.dart';
// import 'package:projectapp/RecognitionScreen.dart';
// class HomeScreen1 extends StatefulWidget {
//   const HomeScreen1({Key? key}) : super(key: key);
//   static Map<String, Recognition> registered = Map();
//   @override
//   State<HomeScreen1> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomeScreen1> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//               margin: const EdgeInsets.only(top: 100),
//               child: Image.network(
//                 " https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
//                 // width: screenWidth-40,height: screenWidth-40,
//               )),
//           Container(
//             margin: const EdgeInsets.only(bottom: 50),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const RegistrationScreen()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                       minimumSize: Size(screenWidth - 30, 50)),
//                   child: const Text("Register"),
//                 ),
//                 Container(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const RecognitionScreen()));
//                   },
//                   style: ElevatedButton.styleFrom(
//                       minimumSize: Size(screenWidth - 30, 50)),
//                   child: const Text("Recognize"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ML/Recognition.dart';
// import 'RecognitionScreen.dart';
// import 'RegistrationScreen.dart';

import 'package:projectapp/FaceRecognisation/RegistrationScreen.dart';
import 'package:projectapp/FaceRecognisation/RecognitionScreen.dart';
import 'package:projectapp/FaceRecognisation/Face_homescreen.dart';

class Facehomescreen extends StatefulWidget {
  const Facehomescreen({Key? key}) : super(key: key);
  static Map<String, Recognition> registered = Map();
  @override
  State<Facehomescreen> createState() => _HomePageState();
}

class _HomePageState extends State<Facehomescreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //     margin: const EdgeInsets.only(top: 100),
          //     child: Image.network(
          //       " https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
          //       width: screenWidth-40,height: screenWidth-40,
          //     )
          //     ),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth - 30, 50)),
                  child: const Text("Register"),
                ),
                Container(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecognitionScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth - 30, 50)),
                  child: const Text("Recognize"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
