class ImageData {
  final String imageUrl;
  final String imageName;

  ImageData({required this.imageUrl, required this.imageName});

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'imageName': imageName,
    };
  }

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      imageUrl: json['imageUrl'],
      imageName: json['imageName'],
    );
  }
}