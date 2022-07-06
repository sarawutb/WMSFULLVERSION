import 'package:flutter/foundation.dart';

import '../models/CancelListPrinterModel.dart';

class ControllerCancelListPrinter extends ChangeNotifier {
  List<CancelListPrinterModel> listPrinterMonitorPrinter = [];
  List<CancelListPrinterModel> listPrinterSelectPrinter = [];

  // !! SelectPrinterMoniterPrinter
  void updatelistPrinterMonitorPrinter(
      {required List<CancelListPrinterModel> list}) {
    listPrinterMonitorPrinter = list;
    print("UPDATE LIST PRINTER1");
    print("UPDATE LIST PRINTER2");
    print("UPDATE LIST PRINTER3");
    print("UPDATE LIST PRINTER4");
    print("UPDATE LIST PRINTER5");
    notifyListeners();
  }

  // !! SelectPrinterMoniterPrinter
  void clearlistPrinterMonitorPrinter() {
    listPrinterSelectPrinter.clear();
    print("CLEAR LIST PRINTER1");
    print("CLEAR LIST PRINTER2");
    print("CLEAR LIST PRINTER3");
    print("CLEAR LIST PRINTER4");
    print("CLEAR LIST PRINTER5");
    notifyListeners();
  }

  // !! SelectPrinter
  void updatelistPrinterSelectPrinter(
      {required List<CancelListPrinterModel> list}) {
    print("UPDATE LIST PRINTER1");
    print("UPDATE LIST PRINTER2");
    print("UPDATE LIST PRINTER3");
    print("UPDATE LIST PRINTER4");
    print("UPDATE LIST PRINTER5");
    listPrinterSelectPrinter = list;
    notifyListeners();
  }

  // !! SelectPrinter
  void clearlistPrinterSelectPrinter() {
    listPrinterSelectPrinter.clear();
    print("CLEAR LIST PRINTER1");
    print("CLEAR LIST PRINTER2");
    print("CLEAR LIST PRINTER3");
    print("CLEAR LIST PRINTER4");
    print("CLEAR LIST PRINTER5");
    notifyListeners();
  }
}
