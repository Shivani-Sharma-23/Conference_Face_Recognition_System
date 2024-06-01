// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'ML/Recognition.dart';
// import 'ML/Recognizer.dart';
// import 'main.dart';
// import 'package:projectapp/RegistrationScreen.dart';
// import 'package:projectapp/RecognitionScreen.dart';
// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({Key? key}) : super(key: key);

//   @override
//   State<RecognitionScreen> createState() => _HomePageState();
// }

// class _HomePageState extends State<RecognitionScreen> {
//   //TODO declare variables
//   late ImagePicker imagePicker;
//   File? _image;
//   var image;
//   List<Recognition> recognitions = [];
//   List<Face> faces = [];
//   //TODO declare detector
//   dynamic faceDetector;

//   //TODO declare face recognizer
//   late Recognizer _recognizer;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     imagePicker = ImagePicker();

//     //TODO initialize detector
//     final options = FaceDetectorOptions(
//         enableClassification: false,
//         enableContours: false,
//         enableLandmarks: false);

//     //TODO initalize face detector
//     faceDetector = FaceDetector(options: options);

//     //TODO initalize face recognizer
//     _recognizer = Recognizer();
//   }

//   //TODO capture image using camera
//   _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _image = File(pickedFile.path);
//       doFaceDetection();
//     }
//   }

//   //TODO choose image using gallery
//   _imgFromGallery() async {
//     XFile? pickedFile =
//     await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _image = File(pickedFile.path);
//       doFaceDetection();
//     }
//   }

//   //TODO face detection code here
//   TextEditingController textEditingController = TextEditingController();
//   doFaceDetection() async {
//     faces.clear();

//     //TODO remove rotation of camera images
//     _image = await removeRotation(_image!);

//     //TODO passing input to face detector and getting detected faces
//     final inputImage = InputImage.fromFile(_image!);
//     faces = await faceDetector.processImage(inputImage);

//     //TODO call the method to perform face recognition on detected faces
//     performFaceRecognition();
//   }

//   //TODO remove rotation of camera images
//   removeRotation(File inputImage) async {
//     final img.Image? capturedImage = img.decodeImage(await File(inputImage!.path).readAsBytes());
//     final img.Image orientedImage = img.bakeOrientation(capturedImage!);
//     return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
//   }

//   //TODO perform Face Recognition
//   performFaceRecognition() async {
//     image = await _image?.readAsBytes();
//     image = await decodeImageFromList(image);
//     print("${image.width}   ${image.height}");

//     recognitions.clear();
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//       num left = faceRect.left<0?0:faceRect.left;
//       num top = faceRect.top<0?0:faceRect.top;
//       num right = faceRect.right>image.width?image.width-1:faceRect.right;
//       num bottom = faceRect.bottom>image.height?image.height-1:faceRect.bottom;
//       num width = right - left;
//       num height = bottom - top;

//       //TODO crop face
//       File cropedFace = await FlutterNativeImage.cropImage(
//           _image!.path,
//           left.toInt(),top.toInt(),width.toInt(),height.toInt());
//       final bytes = await File(cropedFace!.path).readAsBytes();
//       final img.Image? faceImg = img.decodeImage(bytes);
//       Recognition recognition = _recognizer.recognize(faceImg!, face.boundingBox);
//       if(recognition.distance>1) {
//         recognition.name = "Unknown";
//       }
//       recognitions.add(recognition);
//     }
//     drawRectangleAroundFaces();
//   }

//   //TODO draw rectangles
//   drawRectangleAroundFaces() async {
//     setState(() {
//       image;
//       faces;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           image != null
//               ? Container(
//             margin: const EdgeInsets.only(
//                 top: 60, left: 30, right: 30, bottom: 0),
//             child: FittedBox(
//               child: SizedBox(
//                 width: image.width.toDouble(),
//                 height: image.width.toDouble(),
//                 child: CustomPaint(
//                   painter: FacePainter(
//                       facesList: recognitions, imageFile: image),
//                 ),
//               ),
//             ),
//           )
//               : Container(
//             margin: const EdgeInsets.only(top: 100),
//             child: Image.network(
//               " https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
//               width: screenWidth - 100,
//               height: screenWidth - 100,
//             ),
//           ),

//           Container(
//             height: 50,
//           ),

//           //section which displays buttons for choosing and capturing images
//           Container(
//             margin: const EdgeInsets.only(bottom: 50),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Card(
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(200))),
//                   child: InkWell(
//                     onTap: () {
//                       _imgFromGallery();
//                     },
//                     child: SizedBox(
//                       width: screenWidth / 2 - 70,
//                       height: screenWidth / 2 - 70,
//                       child: Icon(Icons.image,
//                           color: Colors.blue, size: screenWidth / 7),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(200))),
//                   child: InkWell(
//                     onTap: () {
//                       _imgFromCamera();
//                     },
//                     child: SizedBox(
//                       width: screenWidth / 2 - 70,
//                       height: screenWidth / 2 - 70,
//                       child: Icon(Icons.camera,
//                           color: Colors.blue, size: screenWidth / 7),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class FacePainter extends CustomPainter {
//   List<Recognition> facesList;
//   dynamic imageFile;
//   FacePainter({required this.facesList, @required this.imageFile});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (imageFile != null) {
//       canvas.drawImage(imageFile, Offset.zero, Paint());
//     }

//     Paint p = Paint();
//     p.color = Colors.red;
//     p.style = PaintingStyle.stroke;
//     p.strokeWidth = 3;

//     for (Recognition rectangle in facesList) {
//       canvas.drawRect(rectangle.location, p);
//       TextSpan span = TextSpan(
//           style: const TextStyle(color: Colors.white, fontSize: 90),
//           text: "${rectangle.name}  ${rectangle.distance.toStringAsFixed(2)}");
//       TextPainter tp = TextPainter(
//           text: span,
//           textAlign: TextAlign.left,
//           textDirection: TextDirection.ltr);
//       tp.layout();
//       tp.paint(canvas, Offset(rectangle.location.left, rectangle.location.top));
//     }

//     Paint p2 = Paint();
//     p2.color = Colors.green;
//     p2.style = PaintingStyle.stroke;
//     p2.strokeWidth = 3;

//     Paint p3 = Paint();
//     p3.color = Colors.yellow;
//     p3.style = PaintingStyle.stroke;
//     p3.strokeWidth = 1;
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'ML/Recognition.dart';
// import 'ML/Recognizer.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class RecognitionScreen extends StatefulWidget {
//   const RecognitionScreen({Key? key}) : super(key: key);

//   @override
//   State<RecognitionScreen> createState() => _HomePageState();
// }

// class _HomePageState extends State<RecognitionScreen> {
//   //TODO declare variables
//   late ImagePicker imagePicker;
//   TextEditingController textEditingController = TextEditingController();
//   late Text text;
//   File? _image;
//   var _registeredImage;
//   Uint8List? imageBytes;
//   var image;
//   List<Recognition> recognitions = [];
//   List<Face> faces = [];
//   //TODO declare detector
//   dynamic faceDetector;

//   //TODO declare face recognizer
//   late Recognizer _recognizer;
//   FirebaseDatabase database = FirebaseDatabase.instance;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     imagePicker = ImagePicker();

//     //TODO initialize detector
//     final options = FaceDetectorOptions(
//       enableClassification: false,
//       enableContours: false,
//       enableLandmarks: false,
//     );

//     //TODO initalize face detector
//     faceDetector = FaceDetector(options: options);

//     //TODO initalize face recognizer
//     _recognizer = Recognizer();
//   }

//   // Method to fetch registered image from Firebase Storage
//   _fetchRegisteredImage() async {
//     // String? imageUrl = await fetchImageUrl('1690434511438.jpg');

//     try {
//       // Replace 'RegisterdImages' with the actual path of your images in Firebase Storage
//       Reference reference =
//           FirebaseStorage.instance.ref().child('RegisterdImages/1690434511438');

//       // Download the image as a byte array
//       imageBytes = await reference.getData();
//       _registeredImage = await decodeImageFromList(imageBytes!);
//       performFaceRecognition(_registeredImage!);
//     } catch (e) {
//       // Handle any errors that occur during the fetching process
//       print("Error fetching image from Firebase: $e");
//     }
//   }

//   //TODO capture image using camera
//   _imgFromCamera() async {
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _image = File(pickedFile.path);
//       _performFaceDetection();
//     }
//   }

//   //TODO choose image using gallery
//   _imgFromGallery() async {
//     XFile? pickedFile =
//         await imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _image = File(pickedFile.path);
//       _performFaceDetection();
//     }
//   }

//   //TODO face detection code here
//   _performFaceDetection() async {
//     faces.clear();

//     // Passing input to face detector and getting detected faces
//     final inputImage = InputImage.fromFile(_image!);
//     faces = await faceDetector.processImage(inputImage);

//     // Call the method to fetch the registered image and perform face recognition
//     // _fetchRegisteredImage(textEditingController.text);
//   }

//   //TODO perform Face Recognition
//   performFaceRecognition(List<int> imageBytes) async {
//     image = await _image?.readAsBytes();
//     image = await decodeImageFromList(image);
//     print("${image.width}   ${image.height}");

//     recognitions.clear();
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//       num left = faceRect.left < 0 ? 0 : faceRect.left;
//       num top = faceRect.top < 0 ? 0 : faceRect.top;
//       num right =
//           faceRect.right > image.width ? image.width - 1 : faceRect.right;
//       num bottom =
//           faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
//       num width = right - left;
//       num height = bottom - top;

//       // Crop face
//       File croppedFace = await FlutterNativeImage.cropImage(
//         _image!.path,
//         left.toInt(),
//         top.toInt(),
//         width.toInt(),
//         height.toInt(),
//       );
//       final bytes = await File(croppedFace!.path).readAsBytes();
//       final img.Image? faceImg = img.decodeImage(bytes);
//       Recognition recognition =
//           await _recognizer.recognize(faceImg!, face.boundingBox);
//       if (recognition.distance > 1) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Unknown User")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("User Found")),
//         );
//       }
//       recognitions.add(recognition);
//     }
//     drawRectangleAroundFaces();
//   }

//   //TODO draw rectangles
//   drawRectangleAroundFaces() async {
//     setState(() {
//       _registeredImage;
//       faces;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           image != null
//               ? Container(
//                   margin: const EdgeInsets.only(
//                       top: 60, left: 30, right: 30, bottom: 0),
//                   child: FittedBox(
//                     child: SizedBox(
//                       width: image.width.toDouble(),
//                       height: image.width.toDouble(),
//                       child: CustomPaint(
//                         painter: FacePainter(
//                             facesList: recognitions,
//                             imageFile: _registeredImage),
//                       ),
//                     ),
//                   ),
//                 )
//               : Container(
//                   margin: const EdgeInsets.only(top: 100),
//                   child: Image.network(
//                     "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png",
//                     width: screenWidth - 100,
//                     height: screenWidth - 100,
//                   ),
//                 ),
//           Container(
//             height: 50,
//           ),
//           // Section which displays buttons for choosing and capturing images
//           Container(
//             margin: const EdgeInsets.only(bottom: 50),
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         _fetchRegisteredImage();
//                       },
//                       child: Center(child: Text('FETCH IMAGE')),
//                     ),
//                     // TextField(
//                     //   controller: textEditingController,
//                     // ),
//                     // Card(
//                     //   shape: const RoundedRectangleBorder(
//                     //       borderRadius: BorderRadius.all(Radius.circular(200))),
//                     //   child: InkWell(
//                     //     onTap: () {
//                     //       // _fetchRegisteredImage(textEditingController.text);
//                     //     },
//                     //     child: SizedBox(
//                     //       width: screenWidth / 2 - 70,
//                     //       height: screenWidth / 2 - 70,
//                     //       child: Icon(Icons.image,
//                     //           color: Colors.blue, size: screenWidth / 7),
//                     //     ),
//                     //   ),
//                     // )
//                   ],
//                 ),
//                 Card(
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(200))),
//                   child: InkWell(
//                     onTap: () {
//                       _imgFromCamera();
//                     },
//                     child: SizedBox(
//                       width: screenWidth / 2 - 70,
//                       height: screenWidth / 2 - 70,
//                       child: Icon(Icons.camera,
//                           color: Colors.blue, size: screenWidth / 7),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FacePainter extends CustomPainter {
//   List<Recognition> facesList;
//   dynamic imageFile;
//   FacePainter({required this.facesList, @required this.imageFile});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (imageFile != null) {
//       canvas.drawImage(imageFile, Offset.zero, Paint());
//     }

//     Paint p = Paint();
//     p.color = Colors.red;
//     p.style = PaintingStyle.stroke;
//     p.strokeWidth = 3;

//     for (Recognition rectangle in facesList) {
//       canvas.drawRect(rectangle.location, p);
//       TextSpan span = TextSpan(
//         style: const TextStyle(color: Colors.white, fontSize: 90),
//         text: "${rectangle.name}  ${rectangle.distance.toStringAsFixed(2)}",
//       );
//       TextPainter tp = TextPainter(
//         text: span,
//         textAlign: TextAlign.left,
//         textDirection: TextDirection.ltr,
//       );
//       tp.layout();
//       tp.paint(canvas, Offset(rectangle.location.left, rectangle.location.top));
//     }

//     Paint p2 = Paint();
//     p2.color = Colors.green;
//     p2.style = PaintingStyle.stroke;
//     p2.strokeWidth = 3;

//     Paint p3 = Paint();
//     p3.color = Colors.yellow;
//     p3.style = PaintingStyle.stroke;
//     p3.strokeWidth = 1;
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
import 'dart:io';
// import 'package:Face_Recognition/ML/Recognition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../ML/Recognition.dart';
import '../ML/Recognizer.dart';
import '../main.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({Key? key}) : super(key: key);

  @override
  State<RecognitionScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RecognitionScreen> {
  //TODO declare variables
  late ImagePicker imagePicker;
  File? _image;
  var image;
  List<Recognition> recognitions = [];
  List<Face> faces = [];
  //TODO declare detector
  dynamic faceDetector;

  //TODO declare face recognizer
  late Recognizer _recognizer;

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

    //TODO initalize face detector
    faceDetector = FaceDetector(options: options);

    //TODO initalize face recognizer
    _recognizer = Recognizer();
  }

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      doFaceDetection();
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
    final img.Image? capturedImage = img.decodeImage(await File(inputImage!.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

  //TODO perform Face Recognition
  performFaceRecognition() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    print("${image.width}   ${image.height}");

    recognitions.clear();
    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      num left = faceRect.left<0?0:faceRect.left;
      num top = faceRect.top<0?0:faceRect.top;
      num right = faceRect.right>image.width?image.width-1:faceRect.right;
      num bottom = faceRect.bottom>image.height?image.height-1:faceRect.bottom;
      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      File cropedFace = await FlutterNativeImage.cropImage(
          _image!.path,
          left.toInt(),top.toInt(),width.toInt(),height.toInt());
      final bytes = await File(cropedFace!.path).readAsBytes();
      final img.Image? faceImg = img.decodeImage(bytes);
      Recognition recognition = _recognizer.recognize(faceImg!, face.boundingBox);
      if(recognition.distance>1) {
        recognition.name = "Unknown";
      }
      recognitions.add(recognition);
    }
    drawRectangleAroundFaces();
  }

  //TODO draw rectangles
  drawRectangleAroundFaces() async {
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
                  painter: FacePainter(
                      facesList: recognitions, imageFile: image),
                ),
              ),
            ),
          )
              : Container(
            margin: const EdgeInsets.only(top: 100),
            child: Image.network(
              "https://static.wikia.nocookie.net/moviedatabase/images/8/8c/Tony_Stark.jpg/revision/latest/scale-to-width-down/250?cb=20150430161420",
              width: screenWidth - 100,
              height: screenWidth - 100,
            ),
          ),

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
                      _imgFromGallery();
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
  List<Recognition> facesList;
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

    for (Recognition rectangle in facesList) {
      canvas.drawRect(rectangle.location, p);
      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 90),
          text: "${rectangle.name}  ${rectangle.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(rectangle.location.left, rectangle.location.top));
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
