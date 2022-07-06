// import 'package:flutter/foundation.dart';
// import '../models/GoodsReceiving.dart';
import 'package:flutter/foundation.dart';

import '../models/GoodsReceiving.dart';

class ControllerGetPoScreen extends ChangeNotifier {
//   // ! NEW VERSION

  GoodsReceiving? goodsReceiving;

  void updateGoodReceiving({required GoodsReceiving ojb}) {
    goodsReceiving = ojb;
    print("UPDATE GoodsReceiving MODEL IS SUCCESS");
  }

  String updateStatusSearch({required String docNo, bool? status}) {
    // 'PO นี้ไม่ได้อยู่ในเจ้าหนี้นี้หรือประเภทภาษีไม่ตรงกัน'
    print(docNo);

    int index = goodsReceiving!.head!
        .indexWhere((element) => element.refDocNo == docNo);
    print("index$index");
    if (index != -1) {
      print("approveStatus ${goodsReceiving!.head![index].approveStatus}");

      if (goodsReceiving!.head![index].approveStatus! == 0) {
        return '2';
      } else {
        int index2 = goodsReceiving!.head!
            .indexWhere((element) => element.statusSearch == true);
        if (index2 != -1) {
          if (goodsReceiving!.head![index2].docDate ==
              goodsReceiving!.head![index].docDate) {
            goodsReceiving!.head![index].statusSearch = true;
            notifyListeners();
            return '';
          } else {
            return '4';
          }
        } else {
          goodsReceiving!.head![index].statusSearch = true;
          notifyListeners();
          return '';
        }
      }
    } else {
      return '1';
    }
  }

  void updateStatusSearchFromIndex({required String docNo}) {
    print(docNo);
    int index = goodsReceiving!.head!.indexWhere(
        (element) => element.refDocNo == docNo && element.refDocNo == docNo);
    if (index != -1) {
      goodsReceiving!.head![index].statusSearch = true;
      notifyListeners();
    }

    print(index);
  }

  void updateIsShowHead({required int index}) {
    goodsReceiving!.head![index].isShow = !goodsReceiving!.head![index].isShow;
    notifyListeners();
  }

  void removeHeadFromIndex({required String docNo}) {
    print(docNo);
    int index = goodsReceiving!.head!.indexWhere(
        (element) => element.refDocNo == docNo && element.refDocNo == docNo);
    if (index != -1) {
      goodsReceiving!.head![index].statusSearch = false;
      notifyListeners();
    }

    print(index);
  }

  void updateItemInGoodsReceivingIsTrue(
      {required String docNo, required int linenumber}) {
    if (goodsReceiving != null) {
      goodsReceiving!.head!.asMap().forEach((key, element) {
        if (element.docNo == docNo) {
          // goodsReceiving!.head![key].statusSearch = true;
          int _index = goodsReceiving!.head![key].detail!
              .indexWhere((element) => element.lineNumber == linenumber);
          if (_index != -1) {
            goodsReceiving!.head![key].detail![_index].statusSearch = true;
            goodsReceiving!.head![key].detail![_index].statusSuccess = false;
          }
        }
      });
    }
    notifyListeners();
  }

  updateRemarkHead({required String remark}) {
    print("UPDATE REMARK PO1 $remark");
    print("UPDATE REMARK PO2 $remark");
    print("UPDATE REMARK PO3 $remark");
    print("UPDATE REMARK PO4 $remark");
    print("UPDATE REMARK PO5 $remark");
    print("UPDATE REMARK PO6 $remark");
    goodsReceiving!.head![0].remark = remark;
    // listpodetail[index].statusSuccess = true;
    notifyListeners();
  }

  void updateItemInGoodsReceivingIsFalseOnlyFeil(
      {required String index, required int linenumber}) {
    print("UPDATE GOODSRECEIVING  IS $index Success $linenumber");

    if (goodsReceiving != null) {
      goodsReceiving!.head!.asMap().forEach((key, element) {
        if (element.docNo == index) {
          goodsReceiving!.head![key].statusSuccess = true;
          int _index = goodsReceiving!.head![key].detail!
              .indexWhere((element) => element.lineNumber == linenumber);
          if (_index != -1) {
            goodsReceiving!.head![key].detail![_index].statusSearch = false;
            // goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
            //     .statusSuccess = false;

          }
        }
      });
    }
    notifyListeners();
  }

  addImagePathItemInGoodsReceviceing(
      {required String index, required int index2, required String value}) {
    print("ADD IMAGES  GOODSRECEIVING 1 IS $index Success");
    print("ADD IMAGES  GOODSRECEIVING 2 IS $index Success");
    print("ADD IMAGES  GOODSRECEIVING 3 IS $index Success");
    print("ADD IMAGES  GOODSRECEIVING 4 IS $index Success");
    print("ADD IMAGES  GOODSRECEIVING 5 IS $index Success");
    print("ADD IMAGES  GOODSRECEIVING 6 IS $index Success");
    if (goodsReceiving != null) {
      goodsReceiving!.head!.forEach((element) {
        if (element.docNo == index) {
          print("IamgePath == >>" + value);
          element.detail![index2].imagePathDetail.add(value);
        }
      });
      // .add(value);
      notifyListeners();
    }
  }

  clearGoodsReceviceing({required String index, required int linenumber}) {
    if (goodsReceiving != null) {
      goodsReceiving!.head!.asMap().forEach((key, element) {
        if (element.docNo == index) {
          int _index = goodsReceiving!.head![key].detail!
              .indexWhere((element) => element.lineNumber == linenumber);

          if (_index != -1) {
            element.detail![_index].remark = "";
            element.detail![_index].imagePathDetail.clear();
            element.detail![_index].eventQty!.clear();
            element.detail![_index].controllerdiffreceivingRemark!.clear();
            print(
                "CLEAR ALL DATA IN  GOODSRECEIVING 1 IS $index Success $linenumber");
            print("CLEAR ALL DATA IN  GOODSRECEIVING 2 IS $index Success");
            print("CLEAR ALL DATA IN  GOODSRECEIVING 3 IS $index Success");
            print("CLEAR ALL DATA IN  GOODSRECEIVING 4 IS $index Success");
            print("CLEAR ALL DATA IN  GOODSRECEIVING 5 IS $index Success");
            print("CLEAR ALL DATA IN  GOODSRECEIVING 6 IS $index Success");
          }
        }
      });
    }
  }

  updateEventQtyItemInGoodsReceviceing(
      {required String index, required int index2, required double eventQty}) {
    goodsReceiving!.head!.asMap().forEach((key, element) {
      if (element.docNo == index) {
        goodsReceiving!.head![key].detail![index2].eventQty!.text =
            eventQty.toString();
        print("UPDATE GOODSRECEIVING 1 IS $index Success  Value is $eventQty ");
        print("UPDATE GOODSRECEIVING 2 IS $index Success  Value is $eventQty ");
        print("UPDATE GOODSRECEIVING 3 IS $index Success  Value is $eventQty ");
        print("UPDATE GOODSRECEIVING 4 IS $index Success  Value is $eventQty ");
        print("UPDATE GOODSRECEIVING 5 IS $index Success  Value is $eventQty ");
        print("UPDATE GOODSRECEIVING 6 IS $index Success  Value is $eventQty ");

        notifyListeners();
      }
    });
  }

  updateItemInGoodsReceivingSuccessIsTrue(
      {required String index, required int index2}) {
    print("UPDATE GOODSRECEIVING 1 IS $index Success");
    print("UPDATE GOODSRECEIVING 2 IS $index Success");
    print("UPDATE GOODSRECEIVING 3 IS $index Success");
    print("UPDATE GOODSRECEIVING 4 IS $index Success");
    print("UPDATE GOODSRECEIVING 5 IS $index Success");
    print("UPDATE GOODSRECEIVING 6 IS $index Success");
    if (goodsReceiving != null) {
      goodsReceiving!.head!.asMap().forEach((key, element) {
        if (element.docNo == index) {
          goodsReceiving!.head![key].detail![index2].statusSuccess = true;
        }
      });
    }
    notifyListeners();
  }

  updateItemInGoodsReceivingIsSearchFalse(
      {required String index, required int linenumber}) {
    print("UPDATE GOODSRECEIVING  IS $index Success $linenumber");

    if (goodsReceiving != null) {
      goodsReceiving!.head!.asMap().forEach((key, element) {
        if (element.docNo == index) {
          goodsReceiving!.head![key].statusSearch = true;
          int _index = goodsReceiving!.head![key].detail!
              .indexWhere((element) => element.lineNumber == linenumber);
          if (_index != -1) {
            goodsReceiving!.head![key].detail![_index].statusSearch = false;
            goodsReceiving!.head![key].detail![_index].statusSuccess = false;
          }
        }
      });
    }
    notifyListeners();
  }

  void addImageToHead({required String path, required int index}) {
    goodsReceiving!.head![index].imagePath.add(path);
    notifyListeners();
  }
}

//   GoodsReceiving? goodsReceiving;


//   updateGoodsReceiving({required GoodsReceiving oject}) {
//     print("UPDATE GOODSRECEIVING 1 IS Success");
//     print("UPDATE GOODSRECEIVING 2 IS Success");
//     print("UPDATE GOODSRECEIVING 3 IS Success");
//     print("UPDATE GOODSRECEIVING 4 IS Success");
//     print("UPDATE GOODSRECEIVING 5 IS Success");
//     print("UPDATE GOODSRECEIVING 6 IS Success");
//     goodsReceiving = oject;
//     notifyListeners();
//   }

//   removeItemInGoodsReceiving({required int index}) {
//     print("UPDATE GOODSRECEIVING 1 IS Success");
//     print("UPDATE GOODSRECEIVING 2 IS Success");
//     print("UPDATE GOODSRECEIVING 3 IS Success");
//     print("UPDATE GOODSRECEIVING 4 IS Success");
//     print("UPDATE GOODSRECEIVING 5 IS Success");
//     print("UPDATE GOODSRECEIVING 6 IS Success");
//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.removeAt(index);
//     }

//     notifyListeners();
//   }

//   updateItemInGoodsReceivingIsTrue(
//       {required String index, required int linenumber}) {
//     print("UPDATE GOODSRECEIVING  IS $index Success");

//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//         if (element.head!.docNo == index) {
//           goodsReceiving!.supplier!.poDocNo![key].statusSearching = true;
//           int _index = goodsReceiving!.supplier!.poDocNo![key].head!.detail!
//               .indexWhere((element) => element.lineNumber == linenumber);
//           if (_index != -1) {
//             goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//                 .statusSearch = true;
//             goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//                 .statusSuccess = false;
//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].statusSearching}");
//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].statusSearch} ==>$linenumber ${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].itemName}");
//           }
//         }
//       });
//     }
//     notifyListeners();
//   }

//   updateItemInGoodsReceivingIsFalse(
//       {required String index, required int linenumber}) {
//     print("UPDATE GOODSRECEIVING  IS $index Success");

//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//         if (element.head!.docNo == index) {
//           goodsReceiving!.supplier!.poDocNo![key].statusSearching = true;
//           int _index = goodsReceiving!.supplier!.poDocNo![key].head!.detail!
//               .indexWhere((element) => element.lineNumber == linenumber);
//           if (_index != -1) {
//             goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//                 .statusSearch = true;
//             goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//                 .statusSuccess = false;
//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].statusSearching}");
//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].statusSearch} ==>$linenumber ${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].itemName}");
//           }
//         }
//       });
//     }
//     notifyListeners();
//   }

//   updateItemInGoodsReceivingIsSearchFalse(
//       {required String index, required int linenumber}) {
//     print("UPDATE GOODSRECEIVING  IS $index Success $linenumber");

//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//         if (element.head!.docNo == index) {
//           goodsReceiving!.supplier!.poDocNo![key].statusSearching = true;
//           int _index = goodsReceiving!.supplier!.poDocNo![key].head!.detail!
//               .indexWhere((element) => element.lineNumber == linenumber);
//           if (_index != -1) {
//             goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//                 .statusSearch = false;
//             goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//                 .statusSuccess = false;

//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].statusSearch} ==>$linenumber ${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].itemName}");

//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].statusSuccess} ==>$linenumber ${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].itemName}");
//           }
//         }
//       });
//     }
//     notifyListeners();
//   }

//   updateItemInGoodsReceivingIsFalseOnlyFeil(
//       {required String index, required int linenumber}) {
//     print("UPDATE GOODSRECEIVING  IS $index Success $linenumber");

//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//         if (element.head!.docNo == index) {
//           goodsReceiving!.supplier!.poDocNo![key].statusSearching = true;
//           int _index = goodsReceiving!.supplier!.poDocNo![key].head!.detail!
//               .indexWhere((element) => element.lineNumber == linenumber);
//           if (_index != -1) {
//             goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//                 .statusSearch = false;
//             // goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index]
//             //     .statusSuccess = false;

//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].statusSearch} ==>$linenumber ${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].itemName}");

//             print(
//                 "$index == >${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].statusSuccess} ==>$linenumber ${goodsReceiving!.supplier!.poDocNo![key].head!.detail![_index].itemName}");
//           }
//         }
//       });
//     }
//     notifyListeners();
//   }

//   updateItemInGoodsReceivingSuccessIsTrue(
//       {required String index, required int index2}) {
//     print("UPDATE GOODSRECEIVING 1 IS $index Success");
//     print("UPDATE GOODSRECEIVING 2 IS $index Success");
//     print("UPDATE GOODSRECEIVING 3 IS $index Success");
//     print("UPDATE GOODSRECEIVING 4 IS $index Success");
//     print("UPDATE GOODSRECEIVING 5 IS $index Success");
//     print("UPDATE GOODSRECEIVING 6 IS $index Success");
//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//         if (element.head!.docNo == index) {
//           goodsReceiving!.supplier!.poDocNo![key].head!.detail![index2]
//               .statusSuccess = true;
//         }
//       });
//     }
//     notifyListeners();
//   }

//   updateItemInGoodsReceivingSuccessIsFalse(
//       {required String index, required int index2}) {
//     print("UPDATE GOODSRECEIVING 1 IS $index Success");
//     print("UPDATE GOODSRECEIVING 2 IS $index Success");
//     print("UPDATE GOODSRECEIVING 3 IS $index Success");
//     print("UPDATE GOODSRECEIVING 4 IS $index Success");
//     print("UPDATE GOODSRECEIVING 5 IS $index Success");
//     print("UPDATE GOODSRECEIVING 6 IS $index Success");
//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//         if (element.head!.docNo == index) {
//           goodsReceiving!.supplier!.poDocNo![key].head!.detail![index2]
//               .statusSuccess = true;
//         }
//       });
//     }
//     notifyListeners();
//   }

//   clearItemInGoodsReceiving() async {
//     goodsReceiving = null;
//     print("UPDATE GOODSRECEIVING 1 IS NULL Success");
//     print("UPDATE GOODSRECEIVING 2 IS NULL Success");
//     print("UPDATE GOODSRECEIVING 3 IS NULL Success");
//     print("UPDATE GOODSRECEIVING 4 IS NULL Success");
//     print("UPDATE GOODSRECEIVING 5 IS NULL Success");
//     print("UPDATE GOODSRECEIVING 6 IS NULL Success");
//     notifyListeners();
//   }

//   updateEventQtyItemInGoodsReceviceing(
//       {required String index, required int index2, required double eventQty}) {
//     goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//       if (element.head!.docNo == index) {
//         goodsReceiving!.supplier!.poDocNo![key].head!.detail![index2]
//             .receivingQty = eventQty;
//         print("UPDATE GOODSRECEIVING 1 IS $index Success  Value is $eventQty ");
//         print("UPDATE GOODSRECEIVING 2 IS $index Success  Value is $eventQty ");
//         print("UPDATE GOODSRECEIVING 3 IS $index Success  Value is $eventQty ");
//         print("UPDATE GOODSRECEIVING 4 IS $index Success  Value is $eventQty ");
//         print("UPDATE GOODSRECEIVING 5 IS $index Success  Value is $eventQty ");
//         print("UPDATE GOODSRECEIVING 6 IS $index Success  Value is $eventQty ");

//         notifyListeners();
//       }
//     });
//   }

//   addImagePathItemInGoodsReceviceing(
//       {required String index, required int index2, required String value}) {
//     print("ADD IMAGES  GOODSRECEIVING 1 IS $index Success");
//     print("ADD IMAGES  GOODSRECEIVING 2 IS $index Success");
//     print("ADD IMAGES  GOODSRECEIVING 3 IS $index Success");
//     print("ADD IMAGES  GOODSRECEIVING 4 IS $index Success");
//     print("ADD IMAGES  GOODSRECEIVING 5 IS $index Success");
//     print("ADD IMAGES  GOODSRECEIVING 6 IS $index Success");
//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.forEach((element) {
//         if (element.head!.docNo == index) {
//           print("IamgePath == >>" + value);
//           element.head!.detail![index2].imagePath!.add(value);
//         }
//       });
//       // .add(value);
//       notifyListeners();
//     }
//   }

//   addImagePathHeadInGoodsReceviceing(
//       {required int index, required String value}) {
//     print("ADD IMAGES TO HEAD  GOODSRECEIVING 1 IS Success");
//     print("ADD IMAGES TO HEAD  GOODSRECEIVING 2 IS Success");
//     print("ADD IMAGES TO HEAD  GOODSRECEIVING 3 IS Success");
//     print("ADD IMAGES TO HEAD  GOODSRECEIVING 4 IS Success");
//     print("ADD IMAGES TO HEAD  GOODSRECEIVING 5 IS Success");
//     print("ADD IMAGES TO HEAD  GOODSRECEIVING 6 IS Success");
//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo![index].head!.imagePath!.add(value);
//       notifyListeners();
//     }
//   }

//   updateRemarkItemInGoodsReceviceing(
//       {required int index, required int index2, required String value}) {
//     print("ADD remark  GOODSRECEIVING 1 IS $index Success");
//     print("ADD remark  GOODSRECEIVING 2 IS $index Success");
//     print("ADD remark  GOODSRECEIVING 3 IS $index Success");
//     print("ADD remark  GOODSRECEIVING 4 IS $index Success");
//     print("ADD remark  GOODSRECEIVING 5 IS $index Success");
//     print("ADD remark  GOODSRECEIVING 6 IS $index Success");
//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo![index].head!.detail![index2].remark =
//           value;
//       notifyListeners();
//     }
//   }

//   clearGoodsReceviceing({required String index, required int linenumber}) {
//     if (goodsReceiving != null) {
//       goodsReceiving!.supplier!.poDocNo!.asMap().forEach((key, element) {
//         if (element.head!.docNo == index) {
//           int _index = goodsReceiving!.supplier!.poDocNo![key].head!.detail!
//               .indexWhere((element) => element.lineNumber == linenumber);

//           if (_index != -1) {
//             element.head!.detail![_index].remark = "";
//             element.head!.detail![_index].imagePath!.clear();
//             element.head!.detail![_index].receivingQty = 0;
//             element.head!.detail![_index].controllerdiffreceivingQty!.clear();
//             element.head!.detail![_index].controllerdiffreceivingRemark!
//                 .clear();
//             print(
//                 "CLEAR ALL DATA IN  GOODSRECEIVING 1 IS $index Success $linenumber");
//             print("CLEAR ALL DATA IN  GOODSRECEIVING 2 IS $index Success");
//             print("CLEAR ALL DATA IN  GOODSRECEIVING 3 IS $index Success");
//             print("CLEAR ALL DATA IN  GOODSRECEIVING 4 IS $index Success");
//             print("CLEAR ALL DATA IN  GOODSRECEIVING 5 IS $index Success");
//             print("CLEAR ALL DATA IN  GOODSRECEIVING 6 IS $index Success");
//           }
//         }
//       });
//       // .add(value);

//     }
//     notifyListeners();
//   }

//   updateRemarkHead({required String remark}) {
//     print("UPDATE REMARK PO1 $remark");
//     print("UPDATE REMARK PO2 $remark");
//     print("UPDATE REMARK PO3 $remark");
//     print("UPDATE REMARK PO4 $remark");
//     print("UPDATE REMARK PO5 $remark");
//     print("UPDATE REMARK PO6 $remark");
//     goodsReceiving!.supplier!.remark = remark;
//     // listpodetail[index].statusSuccess = true;
//     notifyListeners();
//   }

//   updateRemarkHeadsupplierCode({required String code}) {
//     print("UPDATE code PO1 $code");
//     print("UPDATE code PO2 $code");
//     print("UPDATE code PO3 $code");
//     print("UPDATE code PO4 $code");
//     print("UPDATE code PO5 $code");
//     print("UPDATE code PO6 $code");
//     goodsReceiving!.supplier!.code = code;
//     // listpodetail[index].statusSuccess = true;
//     notifyListeners();
//   }

//   updateIsShowHead({required int index}) {
//     print("UPDATE Is Show Status index PO1 $index");
//     print("UPDATE Is Show Status index PO2 $index");
//     print("UPDATE Is Show Status index PO3 $index");
//     print("UPDATE Is Show Status index PO4 $index");
//     print("UPDATE Is Show Status index PO5 $index");
//     print("UPDATE Is Show Status index PO6 $index");
//     goodsReceiving!.supplier!.poDocNo![index].head!.isShow =
//         !goodsReceiving!.supplier!.poDocNo![index].head!.isShow;
//     // listpodetail[index].statusSuccess = true;
//     notifyListeners();
//   }
// }
