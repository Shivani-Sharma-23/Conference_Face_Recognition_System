import 'package:flutter/foundation.dart';
import 'package:projectapp/ZEGOCLOUD-NEW_Meeting_setup/providerpage.dart';
class RandomNumberProvider with ChangeNotifier {
  int? _randomNumber;

  int? get randomNumber => _randomNumber;

  void setRandomNumber(int number) {
    _randomNumber = number;
    notifyListeners();
  }
  int? getRandomNumber() {
    return _randomNumber;
  }
}