// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui';
// // import 'package:Face_Recognition/HomeScreen.dart';
// // import 'package:projectapp/FaceRecognisation/cropedFaceImage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image/image.dart';
// // import 'package:projectapp/FaceRecognisation/Register_user_screen.dart';
// import '../startscreen.dart';
// import 'Recognition.dart';
// import '../main.dart';
// import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// // import 'package:projectapp/ML/Recognition.dart';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// // import 'package:projectapp/Ml/Recognizer.dart';

// import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';

// import 'package:projectapp/RegistrationScreen.dart';
// import 'package:projectapp/RecognitionScreen.dart';

// class Recognizer {
//     Uint8List? imageBytes;
//       var _registeredImage;
//   late Interpreter interpreter;
//   late InterpreterOptions _interpreterOptions;

//   late List<int> _inputShape;
//   late List<int> _outputShape;

//   late TensorImage _inputImage;
//   late TensorBuffer _outputBuffer;

//   late TfLiteType _inputType;
//   late TfLiteType _outputType;

//   late var _probabilityProcessor;

//   @override
//   String get modelName => 'mobile_face_net.tflite';

//   @override
//   NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.5, 127.5);

//   @override
//   NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);

//   Recognizer({int? numThreads}) {
//     _interpreterOptions = InterpreterOptions();

//     if (numThreads != null) {
//       _interpreterOptions.threads = numThreads;
//     }
//     loadModel();
//   }

//   Future<void> loadModel() async {
//     try {
//       interpreter =
//           await Interpreter.fromAsset(modelName, options: _interpreterOptions);
//       print('Interpreter Created Successfully');

//       _inputShape = interpreter.getInputTensor(0).shape;
//       _outputShape = interpreter.getOutputTensor(0).shape;
//       _inputType = interpreter.getInputTensor(0).type as TfLiteType;
//       _outputType = interpreter.getOutputTensor(0).type as TfLiteType;

//       _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
//       _probabilityProcessor =
//           TensorProcessorBuilder().add(postProcessNormalizeOp).build();
//     } catch (e) {
//       print('Unable to create interpreter, Caught Exception: ${e.toString()}');
//     }
//   }

//   TensorImage _preProcess() {
//     int cropSize = min(_inputImage.height, _inputImage.width);
//     return ImageProcessorBuilder()
//         .add(ResizeWithCropOrPadOp(cropSize, cropSize))
//         .add(ResizeOp(
//             _inputShape[1], _inputShape[2], ResizeMethod.nearestneighbour))
//         .add(preProcessNormalizeOp)
//         .build()
//         .process(_inputImage);
//   }

//    _fetchRegisteredImage() async {
//     // String? imageUrl = await fetchImageUrl('1690434511438.jpg');

//     try {
//       // Replace 'RegisterdImages' with the actual path of your images in Firebase Storage
//       Reference reference =
//           FirebaseStorage.instance.ref().child('RegisterdImages/1692538026605');
//           //a function to fetych all docs ofa collections => get all images url and then use it for recogniser

//       // Download the image as a byte array
//       imageBytes = await reference.getData();
//       // _registeredImage = await decodeImageFromList(imageBytes!);
//       // performFaceRecognition(_registeredImage!);
//     } catch (e) {
//       // Handle any errors that occur during the fetching process
//       print("Error fetching image from Firebase: $e");
//     }
//   }

//  Future<Recognition> recognize(Image image, Rect location) async{
//     final pres = DateTime.now().millisecondsSinceEpoch;
//     _inputImage = TensorImage(_inputType);
//     _inputImage.loadImage(image);
//     _inputImage = _preProcess();
//     final pre = DateTime.now().millisecondsSinceEpoch - pres;
//     print('Time to load image: $pre ms');
//     final runs = DateTime.now().millisecondsSinceEpoch;
//     interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
//     final run = DateTime.now().millisecondsSinceEpoch - runs;
//     print('Time to run inference: $run ms');
//     //
//     _probabilityProcessor.process(_outputBuffer);
//     //     .getMapWithFloatValue();
//     // final pred = getTopProbability(labeledProb);
//     print(_outputBuffer.getDoubleList());
//     Pair pair = await findNearest(_outputBuffer.getDoubleList());
//     return Recognition(
//         pair.name, location, _outputBuffer.getDoubleList(), pair.distance);
//   }
//     Future<List<Map<String, dynamic>>> fetchFirebaseData() async {
//     List<Map<String, dynamic>> firebaseData = [];
//     try {
//       // Replace 'registered_users' with the actual name of your Firestore collection
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('RegisterdImages').get();
//       // await FirebaseFirestore.instance.collection( 'RegisterdImages').doc('1690434511438').set({'imageUrl': imageUrl});

//       for (var doc in snapshot.docs) {
//          // Explicitly cast data to Map<String, dynamic>
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         firebaseData.add({
//           'name': data?['name'],
//           'embeddings': data?['embeddings'],
//         }
//         );
//       }
//     } catch (e) {
//       print("Error fetching data from Firebase: $e");
//     }
//     return firebaseData;
//   }
//   //TODO  looks for the nearest embeeding in the dataset
//   // and retrurns the pair <id, distance>
//  Future<Pair> findNearest(List<double> emb)async {
//     Pair pair = Pair("Unknown", -5);
//     List<Map<String, dynamic>> firebaseData = await fetchFirebaseData();
//     for (Map item in firebaseData) {
//       final String name = item['name'];
//        List<double> knownEmb = List.castFrom<dynamic, double>(item['embeddings']);
//       // List<double> knownEmb = item.values.embeddings;
//       double distance = 0;
//       for (int i = 0; i < emb.length; i++) {
//         double diff = emb[i] - knownEmb[i];
//         distance += diff * diff;
//       }
//       distance = sqrt(distance);
//       if (pair.distance == -5 || distance < pair.distance) {
//         pair.distance = distance;
//         pair.name = name;
//       }
//     }
//     return pair;
//   }

//   void close() {
//     interpreter.close();
//   }
// }

// class _registeredImage {
// }

// class Pair {
//   String name;
//   double distance;
//   Pair(this.name, this.distance);
// }
import 'dart:math';
import 'dart:ui';

import 'package:image/image.dart';
import 'package:projectapp/FaceRecognisation/Face_homescreen.dart';

import 'package:tflite_flutter_helper_plus/tflite_flutter_helper_plus.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus.dart';
import 'Recognition.dart';
import '../main.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;

  late List<int> _inputShape;
  late List<int> _outputShape;

  late TensorImage _inputImage;
  late TensorBuffer _outputBuffer;

  late TfLiteType _inputType;
  late TfLiteType _outputType;

  late var _probabilityProcessor;

  @override
  String get modelName => 'mobile_face_net.tflite';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.5, 127.5);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter =
          await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      print('Interpreter Created Successfully');

      _inputShape = interpreter.getInputTensor(0).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      _inputType = interpreter.getInputTensor(0).type;
      _outputType = interpreter.getOutputTensor(0).type;

      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.nearestneighbour))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  Recognition recognize(Image image, Rect location) {
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = TensorImage(_inputType);
    _inputImage.loadImage(image);
    _inputImage = _preProcess();
    final pre = DateTime.now().millisecondsSinceEpoch - pres;
    print('Time to load image: $pre ms');
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
    print("it is processing");
    final run = DateTime.now().millisecondsSinceEpoch - runs;
    print('Time to run inference: $run ms');
    //
    _probabilityProcessor.process(_outputBuffer);
    //     .getMapWithFloatValue();
    // final pred = getTopProbability(labeledProb);
    print(_outputBuffer.getDoubleList());
    Pair pair = findNearest(_outputBuffer.getDoubleList());
    // Important step--------------------------------------------------------------------------------------------------------------
    return Recognition(
        pair.name, location, _outputBuffer.getDoubleList(), pair.distance);
  }

  //TODO  looks for the nearest embeeding in the dataset
  // and retrurns the pair <id, distance>
  findNearest(List<double> emb) {
    Pair pair = Pair("Unknown", -5);
    for (MapEntry<String, Recognition> item
        in Facehomescreen.registered.entries) {
      final String name = item.key;
      List<double> knownEmb = item.value.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }
}

class Pair {
  String name;
  double distance;
  Pair(this.name, this.distance);
}
