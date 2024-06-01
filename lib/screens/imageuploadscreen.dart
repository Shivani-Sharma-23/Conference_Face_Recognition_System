import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/zeegcloudhomepage.dart';
import 'package:projectapp/modals/storingmeetingdetails.dart';
import 'package:projectapp/screens/authentication2.dart';
import 'package:http/http.dart';
import 'package:projectapp/widgets/appbar.dart';
import 'package:projectapp/widgets/gradientbutton.dart';
import '../ZEGOCLOUD-NEW_Meeting_setup/VideoConferencePage.dart';
import '../ZEGOCLOUD-NEW_Meeting_setup/providerpage.dart';
import '../utils/colors.dart';
import 'package:projectapp/widgets/uploadingbutton.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/providerpage.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final RandomNumberProvider randomNumberProvider = RandomNumberProvider();

  DateTime codeGeneratedDateTime = DateTime.now();
//fluter local notification code------------------------------------------------------------------
  void showRandomNumberNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final Random random = Random();
    final int randomNumber = random.nextInt(1000000);
    randomNumberProvider.setRandomNumber(randomNumber);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'random_number_channel', // Unique channel ID
      'Random Number', // Channel name
      // 'Displays a randomly generated number', // Channel description
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      sound: RawResourceAndroidNotificationSound('@raw/sound'),
      showWhen: false,
      playSound: true,
      // vibrationPattern:[],
    );
    // final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Conference Code', // Notification title
      'Conference ID: $randomNumber\n\nGenerated at: $codeGeneratedDateTime', // Notification body
      platformChannelSpecifics,
    );
  }

//---------------------------------------------------------------------------------------------------------------------------------
  File? _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      try {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No Image Selected!'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image upload failed.'),
          ),
        );
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) return;

    // Create a unique filename for the image
    String filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    String contentType = 'application/octet-stream';
    //----------------------------------------------------------------------------------------------------------Just trying something
    // String newfilename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    // if (filename == newfilename) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       duration: Duration(seconds: 3),
    //       backgroundColor: Colors.red,
    //       content: Text('Same Image Mat Dal Be!'),
    //     ),
    //   );
    // } else {

    //-------------------------------------------------------------------------------------------------------------------------------
    // Create a reference to the Firebase Storage
    final Reference storageRef = FirebaseStorage.instance.ref().child(filename);

    // Upload the file to Firebase Storage
    await storageRef.putFile(_image!,SettableMetadata(contentType: contentType));
    // Get the download URL of the uploaded image
    String imageUrl = await storageRef.getDownloadURL();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromARGB(255, 93, 195, 21),
        content: Text('Aaa Meri Jaan!! Image Uploaded'),
      ),
    );
    Future.delayed(Duration(seconds: 4), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ZeegcloudhomePage()),
      );
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    int? randomNumber = randomNumberProvider.getRandomNumber();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: backgroundColor,
      //   elevation: 110,
      //   title: const Text('Authentication'),
      //   centerTitle: true,
      // ),
      appBar: GradientAppBarFb1(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage:
                              MemoryImage(_image!.readAsBytesSync()),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.ndtvimg.com/mt/movies/2012-06/manoj-bajpai.jpg?ver-20230616.01'),
                        ),
                  Positioned(
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        getImage();
                      },
                      icon: Icon(Icons.add_a_photo),
                    ),
                    bottom: -10,
                    left: 80,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // _image == null
                //     ?
                Text(
                  'Upload Image For Authentication!',
                  style: TextStyle(color: Colors.white),
                )
                // :
                ,
                SizedBox(height: 20),
                Container(
                    width: 350,
                    height: 50,
                    child: LoadingAnimatedButton(
                        child: Text(
                          'Upload',
                          style: TextStyle(
                              color: Color.fromARGB(255, 208, 158, 9),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          uploadImage();
                          Future.delayed(Duration(seconds: 10), () {
                            showRandomNumberNotification();
                          });
                          uploadMeetingDetails(
                              randomNumber.toString(), codeGeneratedDateTime);
                          print(randomNumber);
                        })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
