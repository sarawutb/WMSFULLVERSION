import 'package:flutter/foundation.dart';

class ControllerConnectivity with ChangeNotifier {
  bool statusConnectivity = true;
  bool get getstatusConnectivity => statusConnectivity;
  void updateStatusConnectivity({required bool status}) {
    print(status);
    statusConnectivity = status;
    notifyListeners();
  }
}
