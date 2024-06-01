import 'package:flutter/material.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/VideoConferencePage.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/providerpage.dart';
import 'package:projectapp/screens/imageuploadscreen.dart';
import 'package:share/share.dart';
import '../utils/colors.dart';
import '../widgets/appbar.dart';
import '../widgets/gradientbutton.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/zegcloudjoinmeetingpage.dart';
import 'package:projectapp/widgets/dialogbox.dart';

class Zegcloudjoinmeetingpage extends StatefulWidget {
  const Zegcloudjoinmeetingpage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ZegcloudjoinmeetingpageState();
}

class _ZegcloudjoinmeetingpageState extends State<Zegcloudjoinmeetingpage> {
  TextEditingController username = TextEditingController();
  TextEditingController conferenceId = TextEditingController();

  /// Users who use the same conferenceID can in the same conference.
  // var conferenceDTextCtrl = TextEditingController(text: 'hello');
  @override
  Widget build(BuildContext context) {
    final RandomNumberProvider randomNumberProvider = RandomNumberProvider();

    int? randomNumber = randomNumberProvider.randomNumber;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: backgroundColor,
      //   elevation: 110,
      //   title: const Text('MEET & CHAT'),
      //   centerTitle: true,
      // ),
      appBar: GradientAppBarFb1(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: conferenceId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'Enter the Shared conference ID',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    hintText: 'your Username',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GradientButtonFb1(
                  text: 'Join Meeting',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return VideoConferencePage(
                          controller: username,
                          conferenceID: conferenceId.text,
                        );
                      }),
                    );

                    // if (conferenceId.text.isNotEmpty &&
                    //     conferenceId.text == randomNumber.toString()) {
                    //   print(randomNumber);
                    //   // Numbers match, show success message
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         icon: Icon(Icons.abc),
                    //         backgroundColor: Colors.green,
                    //         title: Text('Success'),
                    //         content: Text('The code matched!'),
                    //         actions: [
                    //           TextButton(
                    //             onPressed: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(builder: (context) {
                    //                   return VideoConferencePage(
                    //                     controller: username,
                    //                     conferenceID: conferenceId.text,
                    //                   );
                    //                 }),
                    //               );
                    //             },
                    //             child: Text('OK'),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    // }
                    // else {
                    //   // Numbers don't match, show error message
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return DialogFb3(); // Replace Dialog() with DialogFb3()
                    //     },
                    //   );
                    //   // showDialog(
                    //   //   context: context,
                    //   //   builder: (context) {
                    //   //     return AlertDialog(
                    //   //       backgroundColor: Colors.red,
                    //   //       title: Text('Error'),
                    //   //       content: Text('Reference Id Not Matched'),
                    //   //       actions: [
                    //   //         TextButton(
                    //   //           onPressed: () {
                    //   //             Navigator.pop(context);
                    //   //           },
                    //   //           child: Text('OK'),
                    //   //         ),
                    //   //       ],
                    //   //     );
                    //   //   },
                    //   // );
                    // }
                  }),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
