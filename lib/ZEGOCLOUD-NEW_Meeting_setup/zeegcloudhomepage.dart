import 'package:flutter/material.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/VideoConferencePage.dart';
import 'package:projectapp/screens/imageuploadscreen.dart';
import 'package:share/share.dart';
import '../utils/colors.dart';
import '../widgets/appbar.dart';
import '../widgets/gradientbutton.dart';

class ZeegcloudhomePage extends StatefulWidget {
  const ZeegcloudhomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ZeegcloudhomePageState();
}

class _ZeegcloudhomePageState extends State<ZeegcloudhomePage> {
  TextEditingController username = TextEditingController();
  TextEditingController conferenceId = TextEditingController();

  /// Users who use the same conferenceID can in the same conference.
  // var conferenceDTextCtrl = TextEditingController(text: 'hello');
  @override
  Widget build(BuildContext context) {
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
                    hintText: 'Enter your conference ID',
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
                  text: 'Start Meeting',
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
                  }),
              SizedBox(
                height: 10,
              ),
              GradientButtonFb1(
                  text: 'Share',
                  onPressed: () {
                    if (conferenceId.text != null &&
                        conferenceId.text.isNotEmpty) {
                      Share.share(conferenceId.text);
                    } else {
                      // Show a snackbar indicating that the conference ID is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Conference ID DAL PHELE!!'),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
