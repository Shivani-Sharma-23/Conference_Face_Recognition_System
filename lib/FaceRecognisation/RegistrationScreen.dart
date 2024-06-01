import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:projectapp/FaceRecognisation/RecognitionScreen.dart';
import 'package:projectapp/uploadingregisteruserscreen.dart';
import 'Face_homescreen.dart';
import '../ML/Recognition.dart';
import '../ML/Recognizer.dart';
import 'package:projectapp/FaceRecognisation/RegistrationScreen.dart';
import 'package:projectapp/FaceRecognisation/RecognitionScreen.dart';
import 'package:projectapp/FaceRecognisation/Face_homescreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

//----------------------------------------------------------------------------------------------------------------------
//TODO declare variables
late ImagePicker imagePicker;
File? _image;
var image;
List<Face> faces = [];
//TODO declare detector
dynamic faceDetector;

//TODO declare face recognizer
late Recognizer _recognizer;

//-------------------------------------------------------------------------------------------------------------------------------

class _HomePageState extends State<RegistrationScreen> {
  String? imageName;

//-------------------------------------------------------------------------------------------------------------------------------
  Future<void> uploadImageAndSaveToDatabase() async {
    File? pickedFilee = await _imgFromGallery();
    if (pickedFilee == null) {
      SnackBar(
          content: Text(
              'Image not found')); // Exit the function if no image was picked
    }
    File imageFile = File(pickedFilee!.path);
    await doFaceDetection();

    try {
      // Step 1: Upload the image to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child(
          'RegisterdImages/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
      TaskSnapshot taskSnapshot = await storageReference.putFile(imageFile);
      //-------------------------------------------------------------------------------------------------------------------------------
      // Step 2: Get the download URL of the uploaded image
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Step 3: Save the image data (including the download URL) to Firebase Realtime Database

      // DatabaseReference databaseReference =
      await FirebaseFirestore.instance
          .collection('RegisterdImages')
          .doc()
          .set({'imageUrl': imageUrl});
      // databaseReference.set(
      //   ImageData(
      //     imageUrl: imageUrl,
      //     imageName: imageName!,
      //   ).toJson(),
      // );
      print('Image uploaded and data saved successfully!');
    } catch (e) {
      // Handle any errors that occur during the upload and save process
      print("Error uploading image to Firebase or saving data: $e");
    }
  }
//-------------------------------------------------------------------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();

    //TODO initialize detector
    final options = FaceDetectorOptions(
        enableClassification: false,
        enableContours: false,
        enableLandmarks: false);

    //TODO initialize face detector
    faceDetector = FaceDetector(options: options);

    //TODO initialize face recognizer
    _recognizer = Recognizer();
  }

  //TODO capture image using camera
  Future<File?> _imgFromCamera() async {
    XFile? pickedFilee =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFilee != null) {
      _image = File(pickedFilee.path);
      // return _image;
      await doFaceDetection();
     
    }
 
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      return _image;
      // doFaceDetection();
    }
  }

  //TODO face detection code here
  TextEditingController textEditingController = TextEditingController();
  doFaceDetection() async {
    faces.clear();

    //TODO remove rotation of camera images
    _image = await removeRotation(_image!);

    //TODO passing input to face detector and getting detected faces
    final inputImage = InputImage.fromFile(_image!);
    faces = await faceDetector.processImage(inputImage);

    //TODO call the method to perform face recognition on detected faces
    performFaceRecognition();
  }

  //TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //TODO perform Face Recognition
  performFaceRecognition() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left < 0 ? 0 : faceRect.left;
      num top = faceRect.top < 0 ? 0 : faceRect.top;
      num right =
          faceRect.right > image.width ? image.width - 1 : faceRect.right;
      num bottom =
          faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      File cropedFace = await FlutterNativeImage.cropImage(_image!.path,
          left.toInt(), top.toInt(), width.toInt(), height.toInt());
      final bytes = await File(cropedFace!.path).readAsBytes();
      final img.Image? faceImg = img.decodeImage(bytes);

      //here it is sending the registerdImage to the recognizer-------------------------------------------------------------------------
      Recognition recognition =
          await _recognizer.recognize(faceImg!, face.boundingBox);
//----------------------------------------------------------------------------------------------------------------------------------------
      //TODO show face registration dialogue
      showFaceRegistrationDialogue(cropedFace, recognition);
    }
    drawRectangleAroundFaces();
  }

  //TODO Face Registration Dialogue
  showFaceRegistrationDialogue(File cropedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.file(
                cropedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name")),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Facehomescreen.registered.putIfAbsent(
                        textEditingController.text, () => recognition);
                    imageName = textEditingController.text;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, minimumSize: const Size(200, 40)),
                  child: const Text("Register"))
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  //TODO draw rectangles
  drawRectangleAroundFaces() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");
    setState(() {
      image;
      faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ? Container(
                  margin: const EdgeInsets.only(
                      top: 60, left: 30, right: 30, bottom: 0),
                  child: FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble(),
                      height: image.width.toDouble(),
                      child: CustomPaint(
                        painter:
                            FacePainter(facesList: faces, imageFile: image),
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Image.network(
                    "https://www.pngitem.com/pimgs/m/421-4212617_person-placeholder-image-transparent-hd-png-download.png",
                    width: screenWidth - 100,
                    height: screenWidth - 100,
                  ),
                ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Facehomescreen()));
                print('sfsdg');
              },
              child: Text('press')),
          Container(
            height: 50,
          ),
          //section which displays buttons for choosing and capturing images
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      uploadImageAndSaveToDatabase();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.image,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: InkWell(
                    onTap: () {
                      _imgFromCamera();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 70,
                      height: screenWidth / 2 - 70,
                      child: Icon(Icons.camera,
                          color: Colors.blue, size: screenWidth / 7),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Face> facesList;
  dynamic imageFile;
  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 3;

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }

    Paint p2 = Paint();
    p2.color = Colors.green;
    p2.style = PaintingStyle.stroke;
    p2.strokeWidth = 3;

    Paint p3 = Paint();
    p3.color = Colors.yellow;
    p3.style = PaintingStyle.stroke;
    p3.strokeWidth = 1;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
