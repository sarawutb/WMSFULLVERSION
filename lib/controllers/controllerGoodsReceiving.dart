import 'package:flutter/foundation.dart';

import '../models/GoodsReceiving.dart';

class ControllerGoodsReceiving extends ChangeNotifier {
  GoodsReceiving? goodsReceiving;

  // ! UPDATE GOODSRECEIVEING
  void updateGoodsReseiving({required GoodsReceiving item}) async {
    goodsReceiving = item;
    notifyListeners();
  }

  // ! SET NULL GOODSRECEIVEING
  void setNullGoodsReseiving({required GoodsReceiving item}) async {
    goodsReceiving = null;
    notifyListeners();
  }
}
