import 'package:cloud_firestore/cloud_firestore.dart';
class ImageService {
  final CollectionReference _imageCollection =
      FirebaseFirestore.instance.collection('images');

  Future<void> saveImage(String imageUrl) async {
    await _imageCollection.add({
      'url': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
// ImageService _imageService = ImageService();

// // Inside the function where you have the image URL
// String imageUrl = 'https://example.com/image.jpg';
// await _imageService.saveImage(imageUrl);