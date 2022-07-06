import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/models/page_view_model.dart';

class ControllerTranOutProduct extends ChangeNotifier {
  List<PageViewModel> data = [];

  void updateData({required List<PageViewModel> datas}) {
    debugPrint("UPDATE PageViewModel 1");
    debugPrint("UPDATE PageViewModel 2");
    debugPrint("UPDATE PageViewModel 3");
    debugPrint("UPDATE PageViewModel 4");
    debugPrint("UPDATE PageViewModel 5");
    data = datas;
    notifyListeners();
  }

  void updateDetail(
      {required List<Detail> detail,
      required int index1,
      required int index2}) {
    debugPrint("UPDATE DETAIL 1");
    debugPrint("UPDATE DETAIL 2");
    debugPrint("UPDATE DETAIL 3");
    debugPrint("UPDATE DETAIL 4");
    debugPrint("UPDATE DETAIL 5");
    data[index1].head?[index2].detail = detail;
    notifyListeners();
  }

  void updateStatus({
    required int index1,
    required int index2,
    required int linenumber,
  }) {
    debugPrint("UPDATE DETAIL 1");
    debugPrint("UPDATE DETAIL 2");
    debugPrint("UPDATE DETAIL 3");
    debugPrint("UPDATE DETAIL 4");
    debugPrint("UPDATE DETAIL 5");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;
    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].statussuccess = false;
      }
    });
    notifyListeners();
  }

  void updateStatusSuccess({
    required int index1,
    required int index2,
    required int linenumber,
  }) {
    debugPrint("UPDATE DETAIL 1 true");
    debugPrint("UPDATE DETAIL 2 true");
    debugPrint("UPDATE DETAIL 3 true");
    debugPrint("UPDATE DETAIL 4 true");
    debugPrint("UPDATE DETAIL 5 true");
    // data[index1].head?[index2].detail?[index3].statussuccess = true;
    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].statussuccess = true;
      }
    });

    notifyListeners();
  }

  void updateEventQty(
      {required int index1,
      required int index2,
      required int linenumber,
      required double eventQty}) {
    debugPrint("UPDATE1 eventQty  จำนวน $eventQty");
    debugPrint("UPDATE2 eventQty  จำนวน $eventQty");
    debugPrint("UPDATE3 eventQty  จำนวน $eventQty");
    debugPrint("UPDATE4 eventQty  จำนวน $eventQty");
    debugPrint("UPDATE5 eventQty  จำนวน $eventQty");

    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].eventQty = eventQty;
        data[index1].head?[index2].detail![key].controllerPayQty!.text =
            eventQty.toString();
      }
    });

    notifyListeners();
  }

  void updatePayQty(
      {required int index1,
      required int index2,
      required int linenumber,
      required double payQty}) {
    debugPrint("UPDATE1 payQty  จำนวน $payQty");
    debugPrint("UPDATE2 payQty  จำนวน $payQty");
    debugPrint("UPDATE3 payQty  จำนวน $payQty");
    debugPrint("UPDATE4 payQty  จำนวน $payQty");
    debugPrint("UPDATE5 payQty  จำนวน $payQty");

    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].payQty = payQty;
      }
    });

    notifyListeners();
  }

  void updateRemark(
      {required int index1,
      required int index2,
      required int linenumber,
      required String remark}) {
    debugPrint("UPDATE Remark $remark");
    debugPrint("UPDATE Remark $remark");
    debugPrint("UPDATE Remark $remark");
    debugPrint("UPDATE Remark $remark");
    debugPrint("UPDATE Remark $remark");
    // data[index1].head?[index2].detail?[index3].remark = remark;
    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].remark = remark;
      }
    });

    notifyListeners();
  }

  // ! อัพเดทสถานะหมายเหตุจัดจ่ายไม่ครบ
  void updatereason({
    required int index1,
    required int index2,
    required int linenumber,
    required String reason,
    required String reasonCode,
  }) {
    debugPrint("UPDATE1 reason  จำนวน $reason");
    debugPrint("UPDATE2 reason  จำนวน $reason");
    debugPrint("UPDATE3 reason  จำนวน $reason");
    debugPrint("UPDATE4 reason  จำนวน $reason");
    debugPrint("UPDATE5 reason  จำนวน $reason");

    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].season = reason;
        data[index1].head?[index2].detail![key].reasonCode = reasonCode;
      }
    });

    notifyListeners();
  }

  ListItem? selectedItem;
  List<ListItem> dropdownItems = [];
  updateDropdownbutton({required ListItem listItem}) {
    debugPrint("UPDATE1 listItem  =  ${listItem.name}");
    debugPrint("UPDATE2 listItem  = ${listItem.name}");
    debugPrint("UPDATE3 listItem  = ${listItem.name}");
    debugPrint("UPDATE4 listItem  = ${listItem.name}");
    debugPrint("UPDATE5 listItem  = ${listItem.name}");
    selectedItem = listItem;
    notifyListeners();
  }

  updateListDropdownbutton({required List<ListItem> listItem}) {
    debugPrint("UPDATE1 listItem  =  ${listItem.length}");
    debugPrint("UPDATE2 listItem  = ${listItem.length}");
    debugPrint("UPDATE3 listItem  = ${listItem.length}");
    debugPrint("UPDATE4 listItem  = ${listItem.length}");
    debugPrint("UPDATE5 listItem  = ${listItem.length}");
    dropdownItems = listItem;
    notifyListeners();
  }

  List<ListItem> listReason1 = [];
  List<ListItem> listReason2 = [];
  ListItem? selectedReason1;
  ListItem? selectedReason2;

  updateDropdownbuttonlistReason1({required ListItem item}) {
    debugPrint("UPDATE1 listItem  =  ${item.name}");
    debugPrint("UPDATE2 listItem  = ${item.name}");
    debugPrint("UPDATE3 listItem  = ${item.name}");
    debugPrint("UPDATE4 listItem  = ${item.name}");
    debugPrint("UPDATE5 listItem  = ${item.name}");
    selectedReason1 = item;
    notifyListeners();
  }

  updateListDropdownbuttonlistReason1({required List<ListItem> list}) {
    debugPrint("UPDATE1 list  =  ${list.length}");
    debugPrint("UPDATE2 list  = ${list.length}");
    debugPrint("UPDATE3 list  = ${list.length}");
    debugPrint("UPDATE4 list  = ${list.length}");
    debugPrint("UPDATE5 list  = ${list.length}");
    listReason1 = list;
    notifyListeners();
  }

  updateDropdownbuttonlistReason2({required ListItem item}) {
    debugPrint("UPDATE1 listItem  =  ${item.name}");
    debugPrint("UPDATE2 listItem  = ${item.name}");
    debugPrint("UPDATE3 listItem  = ${item.name}");
    debugPrint("UPDATE4 listItem  = ${item.name}");
    debugPrint("UPDATE5 listItem  = ${item.name}");
    selectedReason2 = item;
    notifyListeners();
  }

  updateListDropdownbuttonlistReason2({required List<ListItem> list}) {
    debugPrint("UPDATE1 list  =  ${list.length}");
    debugPrint("UPDATE2 list  = ${list.length}");
    debugPrint("UPDATE3 list  = ${list.length}");
    debugPrint("UPDATE4 list  = ${list.length}");
    debugPrint("UPDATE5 list  = ${list.length}");
    listReason2 = list;
    notifyListeners();
  }

  // ! ค้นหาสินค้าในรายการ
  void updateStatusSearch({
    required int index1,
    required int index2,
    required int linenumber,
  }) {
    debugPrint("UPDATE SEARCH 1");
    debugPrint("UPDATE SEARCH 2");
    debugPrint("UPDATE SEARCH 3");
    debugPrint("UPDATE SEARCH 4");
    debugPrint("UPDATE SEARCH 5");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;
    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].statussearch = true;
      }
    });
    notifyListeners();
  }

  // ! ค้นหาสินค้าในรายการ
  void updateStatusSearchComfirm({
    required int index1,
    required int index2,
    required int linenumber,
  }) {
    debugPrint("UPDATE SEARCH 1");
    debugPrint("UPDATE SEARCH 2");
    debugPrint("UPDATE SEARCH 3");
    debugPrint("UPDATE SEARCH 4");
    debugPrint("UPDATE SEARCH 5");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;
    data[index1].head?[index2].detail!.asMap().forEach((key, value) {
      if (value.lineNumber == linenumber) {
        data[index1].head?[index2].detail![key].statussearchConfirm = true;
      }
    });
    notifyListeners();
  }

  // ! บันทึกรูปภาพในเอกสาร
  void updateImageDetail(
      {required int index1, required int index2, String? imagepath}) {
    debugPrint("UPDATE IMAGEPATH 1 $imagepath ");
    debugPrint("UPDATE IMAGEPATH 2 $imagepath ");
    debugPrint("UPDATE IMAGEPATH 3 $imagepath ");
    debugPrint("UPDATE IMAGEPATH 4 $imagepath ");
    debugPrint("UPDATE IMAGEPATH 5 $imagepath ");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;
    if (imagepath != null) {
      data[index1].head?[index2].imagepath!.add(imagepath);
    }
    notifyListeners();
  }

  // ! บันทึกลายเซ็นในเอกสาร
  void updateSigntureDocument(
      {required int index1, required int index2, String? signture}) {
    debugPrint("UPDATE signture 1 ");
    debugPrint("UPDATE signture 2 ");
    debugPrint("UPDATE signture 3 ");
    debugPrint("UPDATE signture 4 ");
    debugPrint("UPDATE signture 5 ");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;
    data[index1].head?[index2].signture = signture;
    notifyListeners();
  }

  // ! บันทึกลายเซ็นในเอกสาร
  void clearSignture({required int index1, required int index2}) {
    debugPrint("CLEAR SIGNTURE 1 ");
    debugPrint("CLEAR SIGNTURE 2 ");
    debugPrint("CLEAR SIGNTURE 3 ");
    debugPrint("CLEAR SIGNTURE 4 ");
    debugPrint("CLEAR SIGNTURE 5 ");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;
    data[index1].head?[index2].signture = null;
    notifyListeners();
  }

  // ! บันทึกลายเซ็นในเอกสาร
  void updateStatusButtomInDocument(
      {required int index1, required int index2, required bool status}) {
    debugPrint("Update  Status  Buttom  In  Document 1 ");
    debugPrint("Update  Status  Buttom  In  Document 2 ");
    debugPrint("Update  Status  Buttom  In  Document 3 ");
    debugPrint("Update  Status  Buttom  In  Document 4 ");
    debugPrint("Update  Status  Buttom  In  Document 5 ");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;
    data[index1].head?[index2].statusButtonInDocument = status;
    notifyListeners();
  }

  void clearData() {
    debugPrint("CLEAR DATA 1 ");
    debugPrint("CLEAR DATA 2 ");
    debugPrint("CLEAR DATA 3 ");
    debugPrint("CLEAR DATA 4 ");
    debugPrint("CLEAR DATA 5 ");
    data.clear();
    notifyListeners();
  }

  void updateStatusstatusButtonClick(
      {required int index1, required int index2, required bool status}) {
    debugPrint("updateStatusstatusButtonClick Document 1 ");
    debugPrint("updateStatusstatusButtonClick Document 2 ");
    debugPrint("updateStatusstatusButtonClick Document 3 ");
    debugPrint("updateStatusstatusButtonClick Document 4 ");
    debugPrint("updateStatusstatusButtonClick Document 5 ");
    // data[index1].head?[index2].detail?[index3].statussuccess = false;

    data[index1].head?[index2].statusButtonClick = status;
    // notifyListeners();
  }
}
