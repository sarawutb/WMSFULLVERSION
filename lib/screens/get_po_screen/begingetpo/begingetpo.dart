// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:wms/controllers/controller_login_screen.dart';
// import 'package:wms/models/GoodsReceiving.dart';
// import 'package:wms/themes/colors.dart';

// import '../../../controllers/controller_get_po_screen.dart';
// import '../../../widgets/simpleText.dart';
// import 'begingetpofinal.dart';
// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/services.dart' show rootBundle;

// import 'dialogBox.dart';

// class BeginGetPo extends StatefulWidget {
//   const BeginGetPo({
//     Key? key,
//     required this.date,
//     required this.dbReceiving,
//   }) : super(key: key);
//   final DateTime date;
//   final GoodsReceiving dbReceiving;

//   @override
//   _BeginGetPoState createState() => _BeginGetPoState();
// }

// class _BeginGetPoState extends State<BeginGetPo> with TickerProviderStateMixin {
//   TextEditingController _query = TextEditingController();
//   TextEditingController _invoiceNumber = TextEditingController();
//   TextEditingController _reMark = TextEditingController();
//   FocusNode _node = FocusNode();
//   var now = DateTime.now().toLocal();
//   DateTime? dateTime;
//   final f = new DateFormat('dd-MM-yyyy');
//   bool searchContainerHeight = true;
//   final scrollDirection = Axis.vertical;
//   String queryString = '';
//   AutoScrollController? controller;
//   @override
//   void initState() {
//     dateTime = widget.date;
//     _node.requestFocus();

//     controller = AutoScrollController(
//         viewportBoundaryGetter: () =>
//             Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
//         axis: scrollDirection);

//     Future.delayed(Duration(milliseconds: 400),
//         () => SystemChannels.textInput.invokeListMethod('TextInput.hide'));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle _styledefult =
//         Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12);
//     Size size = MediaQuery.of(context).size;

//     return WillPopScope(
//         onWillPop: () {
//           return Future.value(true);
//         },
//         child: Scaffold(
//           body: buildWidgetStack(_styledefult),
//         ));
//   }

//   Future _scrollToIndex(index) async {
//     await controller!
//         .scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
//   }

//   showAlertDialog(BuildContext context, {required String text}) {
//     AlertDialog alert = AlertDialog(
//       content: Column(
//         children: [
//           new Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(margin: EdgeInsets.only(left: 5), child: Text("$text")),
//             ],
//           ),
//         ],
//       ),
//     );
//     showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   Widget buildWidgetStack(TextStyle textStyle) {
//     TextStyle _styledefult = textStyle;
//     return SafeArea(
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 AnimatedSize(
//                   vsync: this,
//                   curve: Curves.bounceIn,
//                   duration: new Duration(milliseconds: 160),
//                   child: Container(
//                     height: searchContainerHeight ? 345 : 100,
//                     padding: EdgeInsets.all(10),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 7,
//                             color: Colors.grey.shade300,
//                             offset: Offset(2, 2),
//                             spreadRadius: 4,
//                           ),
//                         ]),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 5,
//                           ),
//                           SimpleTextField(
//                             hintText: "สแกน/ค้นหา บาร์โค้ด...",
//                             hintStyle: _styledefult,
//                             focusNode: _node,
//                             prefixIconData: Icons.search,
//                             accentColor: Colors.indigo,
//                             verticalPadding: 10,
//                             textEditingController: _query,
//                             fillColor: Colors.indigo.shade50,
//                             onChanged: (value) {
//                               print(value);
//                             },
//                             onSubmitted: (value) async {
//                               if (value.isNotEmpty) {
//                                 List<PoDocNo> _poDocNo = [];
//                                 queryString = value;
//                                 _poDocNo = Provider.of<ControllerGetPoScreen>(
//                                         context,
//                                         listen: false)
//                                     .goodsReceiving!
//                                     .supplier!
//                                     .poDocNo!
//                                     .where((oject) {
//                                   if ((oject.head!.detail!.any((element) =>
//                                           (element.barcode!.any((element2) =>
//                                               element2 == value))) ||
//                                       oject.head!.detail!.any(
//                                         (element3) =>
//                                             element3.itemCode! == value,
//                                       ))) {
//                                     return true;
//                                   } else {
//                                     return false;
//                                   }
//                                 }).toList();

//                                 _poDocNo.forEach((element) {
//                                   element.head!.detail!
//                                       .asMap()
//                                       .forEach((key, data) {
//                                     if (data.barcode!.any(
//                                             (element2) => element2 == value) ||
//                                         data.itemCode == value) {
//                                       context
//                                           .read<ControllerGetPoScreen>()
//                                           .updateItemInGoodsReceivingIsTrue(
//                                               index: element.head!.docNo!,
//                                               linenumber: data.lineNumber!);
//                                     }
//                                   });
//                                 });
//                                 print("Lenght ==>${_poDocNo.length}");
//                                 if (_poDocNo.isNotEmpty) {
//                                   var res = await showDialog(
//                                       context: context,
//                                       builder: (_) => ShowDialogGetRecevices());
//                                   if (res == 'FALSE') {
//                                     setState(() {});
//                                     print("RES ==>>> $res");
//                                     Provider.of<ControllerGetPoScreen>(context,
//                                             listen: false)
//                                         .goodsReceiving!
//                                         .supplier!
//                                         .poDocNo!
//                                         .forEach((element) {
//                                       element.head!.detail!
//                                           .asMap()
//                                           .forEach((key, data) {
//                                         // if (data.barcode!.any((element2) =>
//                                         //         element2 == value) ||
//                                         //     data.itemCode == value) {
//                                         context
//                                             .read<ControllerGetPoScreen>()
//                                             .updateItemInGoodsReceivingIsFalseOnlyFeil(
//                                                 index: element.head!.docNo!,
//                                                 linenumber: data.lineNumber!);
//                                         // }
//                                       });
//                                     });
//                                   }
//                                 } else {
//                                   await showDialog(
//                                     context: context,
//                                     builder: (context) => Scaffold(
//                                       backgroundColor: Colors.white,
//                                       body: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           children: [
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Text(
//                                               queryString,
//                                               style: _styledefult.copyWith(
//                                                   fontSize: 20,
//                                                   color: black,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             Text(
//                                               "ไม่พบบาร์โค้ดนี้ในระบบ",
//                                               style: _styledefult.copyWith(
//                                                   fontSize: 18, color: red),
//                                             ),
//                                             Expanded(
//                                               child: ListView.builder(
//                                                 controller: controller,
//                                                 itemCount: context
//                                                     .read<
//                                                         ControllerGetPoScreen>()
//                                                     .goodsReceiving!
//                                                     .supplier!
//                                                     .poDocNo!
//                                                     .length,
//                                                 itemBuilder: (context, index) {
//                                                   List<PoDocNo> poDocNo = context
//                                                       .read<
//                                                           ControllerGetPoScreen>()
//                                                       .goodsReceiving!
//                                                       .supplier!
//                                                       .poDocNo!;
//                                                   return Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       if ((poDocNo[index]
//                                                           .head!
//                                                           .detail!
//                                                           .any((element) =>
//                                                               element
//                                                                   .statusSuccess ==
//                                                               false)))
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .symmetric(
//                                                                   vertical: 5),
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                             children: [
//                                                               Text(
//                                                                 poDocNo[index]
//                                                                         .head
//                                                                         ?.docNo ??
//                                                                     '',
//                                                                 style: _styledefult.copyWith(
//                                                                     color: Colors
//                                                                         .indigo,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ...List.generate(
//                                                           poDocNo[index]
//                                                               .head!
//                                                               .detail!
//                                                               .length,
//                                                           (index2) {
//                                                         List<Detail> detail =
//                                                             poDocNo[index]
//                                                                 .head!
//                                                                 .detail!;
//                                                         return !detail[index2]
//                                                                 .statusSuccess!
//                                                             ? Container(
//                                                                 alignment:
//                                                                     Alignment
//                                                                         .center,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10),
//                                                                   color: detail[
//                                                                               index2]
//                                                                           .statusSuccess!
//                                                                       ? Colors
//                                                                           .green
//                                                                           .shade100
//                                                                       : Colors
//                                                                           .blue
//                                                                           .shade100,
//                                                                 ),
//                                                                 margin: EdgeInsets
//                                                                     .symmetric(
//                                                                         vertical:
//                                                                             4),
//                                                                 child: ListTile(
//                                                                   onTap: !detail[index2]
//                                                                               .statusSuccess! ==
//                                                                           true
//                                                                       ? () async {
//                                                                           print(
//                                                                               "Edit");

//                                                                           // context.read<ControllerGetPoScreen>().updateItemInGoodsReceivingIsTrue(
//                                                                           //     index: poDocNo[index].head!.docNo!,
//                                                                           //     linenumber: detail[index2].lineNumber!);
//                                                                           // var res = await showDialog(
//                                                                           //     context: context,
//                                                                           //     builder: (_) => ShowDialogGetRecevices());
//                                                                           // if (res ==
//                                                                           //     'OK') {
//                                                                           //   Navigator.pop(context);
//                                                                           // }
//                                                                           context.read<ControllerGetPoScreen>().updateItemInGoodsReceivingIsTrue(
//                                                                               index: poDocNo[index].head!.docNo!,
//                                                                               linenumber: detail[index2].lineNumber!);

//                                                                           var res = await showDialog(
//                                                                               context: context,
//                                                                               builder: (_) => ShowDialogGetRecevices());
//                                                                           if (res ==
//                                                                               'FALSE') {
//                                                                             setState(() {});
//                                                                             print(res);
//                                                                             context.read<ControllerGetPoScreen>().updateItemInGoodsReceivingIsSearchFalse(
//                                                                                 index: poDocNo[index].head!.docNo!,
//                                                                                 linenumber: detail[index2].lineNumber!);
//                                                                           }
//                                                                           if (res ==
//                                                                               'OK') {
//                                                                             Navigator.pop(context);
//                                                                           }
//                                                                           Future.delayed(
//                                                                               Duration(milliseconds: 600),
//                                                                               () => SystemChannels.textInput.invokeListMethod('TextInput.hide'));
//                                                                         }
//                                                                       : null,
//                                                                   title: Column(
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .center,
//                                                                     children: [
//                                                                       Text(
//                                                                         (detail[index2].lineNumber! + 1).toString() +
//                                                                             ' ' +
//                                                                             (detail[index2].itemCode ??
//                                                                                 '') +
//                                                                             ' ' +
//                                                                             (detail[index2].itemName ??
//                                                                                 '') +
//                                                                             ' ' +
//                                                                             (detail[index2].unitCode ??
//                                                                                 '') +
//                                                                             '~' +
//                                                                             (detail[index2].unitCode ??
//                                                                                 ''),
//                                                                         style: _styledefult.copyWith(
//                                                                             fontWeight:
//                                                                                 FontWeight.bold,
//                                                                             fontSize: 12),
//                                                                       ),
//                                                                       Row(
//                                                                         mainAxisAlignment:
//                                                                             MainAxisAlignment.spaceBetween,
//                                                                         children: [
//                                                                           Text(
//                                                                             "${detail[index2].shelfCode ?? ''} - ${detail[index2].whName ?? ''}",
//                                                                             style:
//                                                                                 _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
//                                                                           ),
//                                                                           Row(
//                                                                             children: [
//                                                                               Text(
//                                                                                 "จำนวนรับ ",
//                                                                                 style: _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
//                                                                               ),
//                                                                               Text(
//                                                                                 "${detail[index2].controllerdiffreceivingQty!.text}",
//                                                                                 style: _styledefult.copyWith(fontWeight: FontWeight.bold, color: red, fontSize: 12),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           Text(
//                                                                             "ราคา ${detail[index2].price ?? ''}",
//                                                                             style:
//                                                                                 _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       Text(
//                                                                         "${detail[index2].statusSearch}::${detail[index2].statusSuccess}",
//                                                                         style: _styledefult.copyWith(
//                                                                             fontWeight:
//                                                                                 FontWeight.bold,
//                                                                             fontSize: 12),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             : SizedBox.shrink();
//                                                       })
//                                                     ],
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 height: 50,
//                                                 child: Text(
//                                                   "ปิด",
//                                                   style: _styledefult.copyWith(
//                                                       color: white,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 16),
//                                                 ),
//                                                 width: double.infinity,
//                                                 decoration: BoxDecoration(
//                                                     color: Color.fromARGB(
//                                                         255, 181, 63, 63),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             14)),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }

//                                 print(_poDocNo.length);
//                                 setState(() {
//                                   _query.clear();
//                                 });
//                                 _node.requestFocus();
//                                 Future.delayed(
//                                     Duration(milliseconds: 600),
//                                     () => SystemChannels.textInput
//                                         .invokeListMethod('TextInput.hide'));
//                               }
//                             },
//                           ),
//                           SizedBox(
//                             height: !searchContainerHeight ? 0 : 5,
//                           ),
//                           if (searchContainerHeight) ...[
//                             Container(
//                               alignment: Alignment.centerLeft,
//                               width: MediaQuery.of(context).size.width,
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.indigo,
//                                 border: Border.all(color: Colors.indigo),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Text(
//                                 "เจ้าหนี้ : ${context.read<ControllerGetPoScreen>().goodsReceiving!.supplier!.name ?? ''} [ ${context.read<ControllerGetPoScreen>().goodsReceiving!.supplier!.poDocNo!.length} ]",
//                                 style: _styledefult.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13,
//                                     color: white),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.indigo,
//                                       border: Border.all(color: Colors.indigo),
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(5),
//                                         bottomLeft: Radius.circular(5),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "วันที่ใบกำกับ",
//                                       style: _styledefult.copyWith(color: white
//                                           // fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () async {
//                                       DateTime? newDateTime =
//                                           await showRoundedDatePicker(
//                                         context: context,
//                                         locale: Locale("th", "TH"),
//                                         era: EraMode.BUDDHIST_YEAR,
//                                         background: Colors.transparent,
//                                         theme: ThemeData(
//                                           primarySwatch: Colors.indigo,
//                                         ),
//                                         initialDate: dateTime,
//                                         firstDate:
//                                             DateTime(DateTime.now().year - 1),
//                                         lastDate:
//                                             DateTime(DateTime.now().year + 1),
//                                         styleDatePicker:
//                                             MaterialRoundedDatePickerStyle(
//                                           paddingMonthHeader: EdgeInsets.all(8),
//                                         ),
//                                       );
//                                       if (newDateTime != null) {
//                                         setState(() => dateTime = newDateTime);
//                                       }
//                                     },
//                                     child: Container(
//                                       alignment: Alignment.centerLeft,
//                                       width: MediaQuery.of(context).size.width,
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 5, horizontal: 10),
//                                       decoration: BoxDecoration(
//                                         // color: Colors.indigo,
//                                         border:
//                                             Border.all(color: Colors.indigo),
//                                         borderRadius: BorderRadius.only(
//                                           topRight: Radius.circular(5),
//                                           bottomRight: Radius.circular(5),
//                                         ),
//                                       ),
//                                       child: Text(
//                                         "${dateTime!.day}/${dateTime!.month}/" +
//                                             (dateTime!.year + 543).toString(),
//                                         style: _styledefult.copyWith(
//                                             color: Colors.indigo
//                                             // fontWeight: FontWeight.bold,
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.indigo,
//                                       border: Border.all(color: Colors.indigo),
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(5),
//                                         bottomLeft: Radius.circular(5),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "เลขที่ใบกำกับ",
//                                       style: _styledefult.copyWith(color: white
//                                           // fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       // color: Colors.indigo,
//                                       border: Border.all(color: Colors.indigo),
//                                       borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(5),
//                                         bottomRight: Radius.circular(5),
//                                       ),
//                                     ),
//                                     child: TextFormField(
//                                       style: _styledefult.copyWith(
//                                         color: Colors.indigo,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       controller: context
//                                           .read<ControllerGetPoScreen>()
//                                           .goodsReceiving!
//                                           .supplier!
//                                           .controllerCode,
//                                       keyboardType: TextInputType.text,
//                                       decoration: new InputDecoration.collapsed(
//                                           hintText: ''),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.indigo,
//                                       border: Border.all(color: Colors.indigo),
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(5),
//                                         bottomLeft: Radius.circular(5),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "วันที่สินค้าถึงร้าน",
//                                       style: _styledefult.copyWith(color: white
//                                           // fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       // color: Colors.indigo,
//                                       border: Border.all(color: Colors.indigo),
//                                       borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(5),
//                                         bottomRight: Radius.circular(5),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "${context.read<ControllerGetPoScreen>().goodsReceiving!.supplier?.deliveryDate}",
//                                       style: _styledefult.copyWith(
//                                           color: Colors.indigo
//                                           // fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 7,
//                             ),
//                             SimpleTextField(
//                               verticalPadding: 10,
//                               accentColor: Colors.indigo,
//                               // labelText: 'หมายเหตุ',
//                               textEditingController: context
//                                   .read<ControllerGetPoScreen>()
//                                   .goodsReceiving!
//                                   .supplier!
//                                   .remarkHead,
//                               // hintStyle: _styledefult,
//                               // hintText: "หมายเหตุ",
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.indigo,
//                                       border: Border.all(color: Colors.indigo),
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(5),
//                                         bottomLeft: Radius.circular(5),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       "ประเภทภาษี",
//                                       style: _styledefult.copyWith(color: white
//                                           // fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     alignment: Alignment.centerLeft,
//                                     width: MediaQuery.of(context).size.width,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 5, horizontal: 10),
//                                     decoration: BoxDecoration(
//                                       // color: Colors.indigo,
//                                       border: Border.all(color: Colors.indigo),
//                                       borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(5),
//                                         bottomRight: Radius.circular(5),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       context
//                                                   .read<ControllerGetPoScreen>()
//                                                   .goodsReceiving!
//                                                   .supplier!
//                                                   .vatType ==
//                                               0
//                                           ? "แยกนอก"
//                                           : context
//                                                       .read<
//                                                           ControllerGetPoScreen>()
//                                                       .goodsReceiving!
//                                                       .supplier!
//                                                       .vatType ==
//                                                   1
//                                               ? "รวมใน"
//                                               : "อัตราศูนย์",
//                                       style: _styledefult.copyWith(
//                                           color: Colors.indigo
//                                           // fontWeight: FontWeight.bold,
//                                           ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                           Spacer(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     searchContainerHeight =
//                                         !searchContainerHeight;
//                                   });
//                                 },
//                                 child: Icon(
//                                     searchContainerHeight
//                                         ? Icons.keyboard_arrow_down_outlined
//                                         : Icons.keyboard_arrow_up_outlined,
//                                     color: Colors.indigo),
//                               ),
//                             ],
//                           ),
//                         ]),
//                   ),
//                 ),
//                 Consumer<ControllerGetPoScreen>(
//                   builder: (context, value, child) {
//                     return Expanded(
//                         child: ListView.builder(
//                       controller: controller,
//                       itemCount:
//                           value.goodsReceiving!.supplier!.poDocNo!.length,
//                       itemBuilder: (context, index) {
//                         List<PoDocNo> poDocNo = context
//                             .read<ControllerGetPoScreen>()
//                             .goodsReceiving!
//                             .supplier!
//                             .poDocNo!;
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 5),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "${poDocNo[index].head?.docNo ?? ''} (${poDocNo[index].head!.detail!.length.toString()}) / แผนก ${poDocNo[index].head!.departMentName}",
//                                     style: _styledefult.copyWith(
//                                         color: Colors.indigo,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       value.updateIsShowHead(index: index);
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.indigo,
//                                         borderRadius: BorderRadius.circular(5),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 3),
//                                       child: Text(
//                                         '${poDocNo[index].head!.isShow ? "แสดง" : "ซ่อน"}',
//                                         style: _styledefult.copyWith(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             if (!poDocNo[index].head!.isShow)
//                               ...List.generate(
//                                   poDocNo[index].head!.detail!.length,
//                                   (index2) {
//                                 List<Detail> detail =
//                                     poDocNo[index].head!.detail!;
//                                 return Container(
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: detail[index2].statusSuccess!
//                                         ? Colors.green.shade100
//                                         : Colors.blue.shade100,
//                                   ),
//                                   margin: EdgeInsets.symmetric(vertical: 4),
//                                   child: Stack(
//                                     children: [
//                                       ListTile(
//                                         title: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               (detail[index2].lineNumber! + 1)
//                                                       .toString() +
//                                                   ' ' +
//                                                   (detail[index2].itemCode ??
//                                                       '') +
//                                                   ' ' +
//                                                   (detail[index2].itemName ??
//                                                       '') +
//                                                   ' ' +
//                                                   (detail[index2].unitCode ??
//                                                       '') +
//                                                   '~' +
//                                                   (detail[index2].unitName ??
//                                                       ''),
//                                               style: _styledefult.copyWith(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   "${detail[index2].shelfCode ?? ''} - ${detail[index2].whName ?? ''}",
//                                                   style: _styledefult.copyWith(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 12),
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Text(
//                                                       "จำนวนรับ ",
//                                                       style:
//                                                           _styledefult.copyWith(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               fontSize: 12),
//                                                     ),
//                                                     Text(
//                                                       "${detail[index2].controllerdiffreceivingQty!.text}",
//                                                       style:
//                                                           _styledefult.copyWith(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color: red,
//                                                               fontSize: 12),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Text(
//                                                   "ราคา ${detail[index2].price ?? ''}",
//                                                   style: _styledefult.copyWith(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 12),
//                                                 ),
//                                               ],
//                                             ),
//                                             Text(
//                                                 "${detail[index2].statusSearch} :: ${detail[index2].statusSuccess}")
//                                           ],
//                                         ),
//                                       ),
//                                       if (detail[index2].statusSuccess!)
//                                         Positioned(
//                                             top: 0,
//                                             right: 0,
//                                             child: GestureDetector(
//                                               onTap: detail[index2]
//                                                           .statusSuccess! ==
//                                                       true
//                                                   ? () async {
//                                                       context
//                                                           .read<
//                                                               ControllerGetPoScreen>()
//                                                           .updateItemInGoodsReceivingIsTrue(
//                                                               index:
//                                                                   poDocNo[index]
//                                                                       .head!
//                                                                       .docNo!,
//                                                               linenumber: detail[
//                                                                       index2]
//                                                                   .lineNumber!);

//                                                       var res = await showDialog(
//                                                           context: context,
//                                                           builder: (_) =>
//                                                               ShowDialogGetRecevices());
//                                                       if (res == 'FALSE') {
//                                                         setState(() {});
//                                                         print(res);
//                                                         context
//                                                             .read<
//                                                                 ControllerGetPoScreen>()
//                                                             .updateItemInGoodsReceivingIsSearchFalse(
//                                                                 index: poDocNo[
//                                                                         index]
//                                                                     .head!
//                                                                     .docNo!,
//                                                                 linenumber: detail[
//                                                                         index2]
//                                                                     .lineNumber!);
//                                                       }
//                                                       Future.delayed(
//                                                           Duration(
//                                                               milliseconds:
//                                                                   600),
//                                                           () => SystemChannels
//                                                               .textInput
//                                                               .invokeListMethod(
//                                                                   'TextInput.hide'));
//                                                     }
//                                                   : null,
//                                               child: Container(
//                                                 padding: EdgeInsets.all(8),
//                                                 height: 30,
//                                                 width: 40,
//                                                 decoration: BoxDecoration(
//                                                     color:
//                                                         Colors.yellow.shade900,
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                             topRight:
//                                                                 Radius.circular(
//                                                                     5),
//                                                             bottomRight: Radius
//                                                                 .circular(5))),
//                                                 child: Icon(
//                                                   Icons.edit,
//                                                   color: white,
//                                                   size: 15,
//                                                 ),
//                                               ),
//                                             ))
//                                     ],
//                                   ),
//                                 );
//                               })
//                           ],
//                         );
//                       },
//                     ));
//                   },
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () async {
//                         showDialog(
//                             barrierDismissible: false,
//                             context: context,
//                             builder: (builder) => Dialog(
//                                   child: Container(
//                                     height: 200,
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                           " ระบุเหตุผลยกเลิก/เริ่มรับสินค้า",
//                                           style: _styledefult.copyWith(
//                                               color: red
//                                               // fontWeight: FontWeight.bold,
//                                               ),
//                                         ),
//                                         Container(
//                                           color: Colors.grey.shade100,
//                                           padding: EdgeInsets.all(10),
//                                           margin: EdgeInsets.symmetric(
//                                               vertical: 10, horizontal: 10),
//                                           child: TextField(
//                                             controller: _reMark,
//                                             style: _styledefult.copyWith(
//                                                 fontSize: 12),
//                                             maxLines: 3,
//                                             decoration: InputDecoration(
//                                               border: InputBorder.none,
//                                               focusedBorder: InputBorder.none,
//                                               enabledBorder: InputBorder.none,
//                                               errorBorder: InputBorder.none,
//                                               disabledBorder: InputBorder.none,
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   Navigator.pop(context);
//                                                   Future.delayed(
//                                                       Duration(
//                                                           milliseconds: 400),
//                                                       () => SystemChannels
//                                                           .textInput
//                                                           .invokeListMethod(
//                                                               'TextInput.hide'));
//                                                 },
//                                                 child: Container(
//                                                   alignment: Alignment.center,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 10,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     color: Color.fromARGB(
//                                                         255, 181, 63, 63),
//                                                     border: Border.all(
//                                                         color: Color.fromARGB(
//                                                             255, 181, 63, 63)),
//                                                   ),
//                                                   child: Text(
//                                                     "ปิด",
//                                                     style: _styledefult.copyWith(
//                                                         color: white
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   if (_reMark.text.isEmpty) {
//                                                     Fluttertoast.showToast(
//                                                         msg:
//                                                             "กรุณากรอกหมายเหตุ");
//                                                   } else {
//                                                     Navigator.pop(context);
//                                                     Navigator.pop(
//                                                         context, 'OK');

//                                                     context
//                                                         .read<
//                                                             ControllerGetPoScreen>()
//                                                         .clearItemInGoodsReceiving();
//                                                   }
//                                                 },
//                                                 child: Container(
//                                                   alignment: Alignment.center,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 10,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     // borderRadius:
//                                                     //     BorderRadius.only(
//                                                     //   topLeft:
//                                                     //       Radius.circular(5),
//                                                     // ),
//                                                   ),
//                                                   child: Text(
//                                                     "ยืนยันยกเลิก",
//                                                     style: _styledefult.copyWith(
//                                                         color: white
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ));
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         width: MediaQuery.of(context).size.width,
//                         padding:
//                             EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: Color.fromARGB(255, 181, 63, 63),
//                           border: Border.all(
//                               color: Color.fromARGB(255, 181, 63, 63)),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(5),
//                           ),
//                         ),
//                         child: Text(
//                           "ยกเลิก/เริ่มรับสินค้า",
//                           style: _styledefult.copyWith(color: white
//                               // fontWeight: FontWeight.bold,
//                               ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         if (context
//                             .read<ControllerGetPoScreen>()
//                             .goodsReceiving!
//                             .supplier!
//                             .remarkHead!
//                             .text
//                             .isNotEmpty) {
//                           context
//                               .read<ControllerGetPoScreen>()
//                               .updateRemarkHead(
//                                   remark: context
//                                       .read<ControllerGetPoScreen>()
//                                       .goodsReceiving!
//                                       .supplier!
//                                       .remarkHead!
//                                       .text);
//                         }

//                         if (context
//                             .read<ControllerGetPoScreen>()
//                             .goodsReceiving!
//                             .supplier!
//                             .controllerCode!
//                             .text
//                             .isNotEmpty) {
//                           context
//                               .read<ControllerGetPoScreen>()
//                               .updateRemarkHeadsupplierCode(
//                                   code: context
//                                       .read<ControllerGetPoScreen>()
//                                       .goodsReceiving!
//                                       .supplier!
//                                       .controllerCode!
//                                       .text);
//                         }

//                         if (context
//                             .read<ControllerGetPoScreen>()
//                             .goodsReceiving!
//                             .supplier!
//                             .controllerCode!
//                             .text
//                             .isEmpty) {
//                           Fluttertoast.showToast(msg: "กรุณากรอกเลขที่ใบกำกับ");
//                         } else {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (BuildContext context) =>
//                                       BeginGetPoFinal(date: widget.date)));
//                         }
//                       },
//                       child: Container(
//                           alignment: Alignment.center,
//                           width: MediaQuery.of(context).size.width,
//                           padding: EdgeInsets.symmetric(
//                               vertical: 10, horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.indigo,
//                             border: Border.all(color: Colors.indigo),
//                             borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(5),
//                             ),
//                           ),
//                           child: Text(
//                             "ยืนยันรับสินค้า",
//                             style: _styledefult.copyWith(color: white
//                                 // fontWeight: FontWeight.bold,
//                                 ),
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/models/GoodsReceiving.dart';
import 'package:wms/themes/colors.dart';

import '../../../controllers/controller_get_po_screen.dart';
import '../../../widgets/simpleText.dart';
import 'begingetpofinal.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import 'dialogBox.dart';

class BeginGetPo extends StatefulWidget {
  const BeginGetPo({
    Key? key,
    required this.date,
    required this.dbReceiving,
  }) : super(key: key);
  final DateTime date;
  final GoodsReceiving dbReceiving;

  @override
  _BeginGetPoState createState() => _BeginGetPoState();
}

class _BeginGetPoState extends State<BeginGetPo> with TickerProviderStateMixin {
  TextEditingController _query = TextEditingController();
  TextEditingController _invoiceNumber = TextEditingController();
  TextEditingController _reMark = TextEditingController();
  FocusNode _node = FocusNode();
  var now = DateTime.now().toLocal();
  DateTime? dateTime;
  final f = new DateFormat('dd-MM-yyyy');
  final oCcy = new NumberFormat("#,##0", "th_TH");
  bool searchContainerHeight = true;
  final scrollDirection = Axis.vertical;
  String queryString = '';
  AutoScrollController? controller;
  @override
  void initState() {
    dateTime = widget.date;
    _node.requestFocus();

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);

    Future.delayed(Duration(milliseconds: 400),
        () => SystemChannels.textInput.invokeListMethod('TextInput.hide'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _styledefult =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12);
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: Scaffold(
          body: buildWidgetStack(_styledefult),
        ));
  }

  Future _scrollToIndex(index) async {
    await controller!
        .scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }

  showAlertDialog(BuildContext context, {required String text}) {
    AlertDialog alert = AlertDialog(
      content: Column(
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(margin: EdgeInsets.only(left: 5), child: Text("$text")),
            ],
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildWidgetStack(TextStyle textStyle) {
    TextStyle _styledefult = textStyle;
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                AnimatedSize(
                  vsync: this,
                  curve: Curves.bounceIn,
                  duration: new Duration(milliseconds: 160),
                  child: Container(
                    height: searchContainerHeight ? 345 : 100,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            color: Colors.grey.shade300,
                            offset: Offset(2, 2),
                            spreadRadius: 4,
                          ),
                        ]),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          SimpleTextField(
                            hintText: "สแกน/ค้นหา บาร์โค้ด...",
                            hintStyle: _styledefult,
                            focusNode: _node,
                            prefixIconData: Icons.search,
                            accentColor: Colors.indigo,
                            verticalPadding: 10,
                            textEditingController: _query,
                            fillColor: Colors.indigo.shade50,
                            onChanged: (value) {
                              print(value);
                            },
                            onSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                List<Head> _poDocNo = [];
                                // queryString = value;
                                _poDocNo = Provider.of<ControllerGetPoScreen>(
                                        context,
                                        listen: false)
                                    .goodsReceiving!
                                    .head!
                                    .where((oject) {
                                  if ((oject.detail!.any((element) =>
                                          (element.barcode! == value)) ||
                                      oject.detail!.any(
                                        (element3) =>
                                            element3.itemCode! == value,
                                      ))) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                }).toList();

                                _poDocNo.forEach((element) {
                                  element.detail!.asMap().forEach((key, data) {
                                    if (data.barcode == value ||
                                        data.itemCode == value) {
                                      context
                                          .read<ControllerGetPoScreen>()
                                          .updateItemInGoodsReceivingIsTrue(
                                              docNo: element.docNo!,
                                              linenumber: data.lineNumber!);
                                    }
                                  });
                                });
                                // _poDocNo.forEach((element) {
                                //   element.detail!
                                //       .asMap()
                                //       .forEach((key, data) {
                                //     if (data.barcode!.any(
                                //             (element2) => element2 == value) ||
                                //         data.itemCode == value) {
                                //       context
                                //           .read<ControllerGetPoScreen>()
                                //           .updateItemInGoodsReceivingIsTrue(
                                //               index: element.head!.docNo!,
                                //               linenumber: data.lineNumber!);
                                //     }
                                //   });
                                // });
                                print("Lenght ==>${_poDocNo.length}");
                                if (_poDocNo.isNotEmpty) {
                                  var res = await showDialog(
                                      context: context,
                                      builder: (_) => ShowDialogGetRecevices());
                                  if (res == 'FALSE') {
                                    setState(() {});
                                    print("RES ==>>> $res");
                                    Provider.of<ControllerGetPoScreen>(context,
                                            listen: false)
                                        .goodsReceiving!
                                        .head!
                                        .forEach((element) {
                                      element.detail!
                                          .asMap()
                                          .forEach((key, data) {
                                        // if (data.barcode!.any((element2) =>
                                        //         element2 == value) ||
                                        //     data.itemCode == value) {
                                        context
                                            .read<ControllerGetPoScreen>()
                                            .updateItemInGoodsReceivingIsFalseOnlyFeil(
                                                index: element.docNo!,
                                                linenumber: data.lineNumber!);
                                        // }
                                      });
                                    });
                                  }
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => Scaffold(
                                      backgroundColor: Colors.white,
                                      body: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              queryString,
                                              style: _styledefult.copyWith(
                                                  fontSize: 20,
                                                  color: black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "ไม่พบบาร์โค้ดนี้ในระบบ",
                                              style: _styledefult.copyWith(
                                                  fontSize: 18, color: red),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                controller: controller,
                                                itemCount: context
                                                    .read<
                                                        ControllerGetPoScreen>()
                                                    .goodsReceiving!
                                                    .head!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  List<Head> poDocNo = context
                                                      .read<
                                                          ControllerGetPoScreen>()
                                                      .goodsReceiving!
                                                      .head!;
                                                  return poDocNo[index]
                                                          .statusSearch
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            if ((poDocNo[index]
                                                                .detail!
                                                                .any((element) =>
                                                                    element
                                                                        .statusSuccess ==
                                                                    false)))
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      poDocNo[index]
                                                                              .docNo ??
                                                                          '',
                                                                      style: _styledefult.copyWith(
                                                                          color: Colors
                                                                              .indigo,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ...List.generate(
                                                                poDocNo[index]
                                                                    .detail!
                                                                    .length,
                                                                (index2) {
                                                              List<Detail>
                                                                  detail =
                                                                  poDocNo[index]
                                                                      .detail!;
                                                              return !detail[
                                                                          index2]
                                                                      .statusSuccess
                                                                  ? Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: detail[index2].statusSuccess
                                                                            ? Colors.green.shade100
                                                                            : Colors.blue.shade100,
                                                                      ),
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          ListTile(
                                                                        onTap: !detail[index2].statusSuccess ==
                                                                                true
                                                                            ? () async {
                                                                                print("Edit");

                                                                                context.read<ControllerGetPoScreen>().updateItemInGoodsReceivingIsTrue(docNo: poDocNo[index].docNo!, linenumber: detail[index2].lineNumber!);
                                                                                var res = await showDialog(context: context, builder: (_) => ShowDialogGetRecevices());
                                                                                if (res == 'OK') {
                                                                                  Navigator.pop(context);
                                                                                }
                                                                                // context.read<ControllerGetPoScreen>().updateItemInGoodsReceivingIsTrue(
                                                                                //     docNo: poDocNo[index].docNo!,
                                                                                //     linenumber: detail[index2].lineNumber!);

                                                                                // var res = await showDialog(
                                                                                //     context: context,
                                                                                //     builder: (_) => ShowDialogGetRecevices());
                                                                                // if (res ==
                                                                                //     'FALSE') {
                                                                                //   setState(() {});
                                                                                //   print(res);
                                                                                //   context.read<ControllerGetPoScreen>().updateItemInGoodsReceivingIsSearchFalse(
                                                                                //       index: poDocNo[index].head!.docNo!,
                                                                                //       linenumber: detail[index2].lineNumber!);
                                                                                // }
                                                                                // if (res ==
                                                                                //     'OK') {
                                                                                //   Navigator.pop(context);
                                                                                // }
                                                                                Future.delayed(Duration(milliseconds: 600), () => SystemChannels.textInput.invokeListMethod('TextInput.hide'));
                                                                              }
                                                                            : null,
                                                                        title:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              (detail[index2].lineNumber! + 1).toString() + ' ' + (detail[index2].itemCode ?? '') + ' ' + (detail[index2].itemName ?? '') + ' ' + (detail[index2].unitCode ?? '') + '~' + (detail[index2].unitCode ?? ''),
                                                                              style: _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  "${detail[index2].shelfCode ?? ''} - ${detail[index2].whCode ?? ''}",
                                                                                  style: _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "จำนวนรับ ",
                                                                                      style: _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                                                                                    ),
                                                                                    Text(
                                                                                      "${detail[index2].eventQty!.text}",
                                                                                      style: _styledefult.copyWith(fontWeight: FontWeight.bold, color: red, fontSize: 12),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                if (detail[index2].price == 0)
                                                                                  Text(
                                                                                    "ราคา ${detail[index2].price ?? ''}",
                                                                                    style: _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              "${detail[index2].statusSearch}::${detail[index2].statusSuccess}",
                                                                              style: _styledefult.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : SizedBox
                                                                      .shrink();
                                                            })
                                                          ],
                                                        )
                                                      : SizedBox.shrink();
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 50,
                                                child: Text(
                                                  "ปิด",
                                                  style: _styledefult.copyWith(
                                                      color: white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 181, 63, 63),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                print(_poDocNo.length);
                                setState(() {
                                  _query.clear();
                                });
                                _node.requestFocus();
                                Future.delayed(
                                    Duration(milliseconds: 600),
                                    () => SystemChannels.textInput
                                        .invokeListMethod('TextInput.hide'));
                              }
                            },
                          ),
                          SizedBox(
                            height: !searchContainerHeight ? 0 : 5,
                          ),
                          if (searchContainerHeight) ...[
                            Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                border: Border.all(color: Colors.indigo),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "เจ้าหนี้ : ${context.read<ControllerGetPoScreen>().goodsReceiving!.apName} [ ${(context.read<ControllerGetPoScreen>().goodsReceiving!.head!.where((element) => element.statusSearch)).length} ]",
                                style: _styledefult.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: white),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      "วันที่ใบกำกับ",
                                      style: _styledefult.copyWith(color: white
                                          // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? newDateTime =
                                          await showRoundedDatePicker(
                                        context: context,
                                        locale: Locale("th", "TH"),
                                        era: EraMode.BUDDHIST_YEAR,
                                        background: Colors.transparent,
                                        theme: ThemeData(
                                          primarySwatch: Colors.indigo,
                                        ),
                                        initialDate: dateTime,
                                        firstDate:
                                            DateTime(DateTime.now().year - 1),
                                        lastDate:
                                            DateTime(DateTime.now().year + 1),
                                        styleDatePicker:
                                            MaterialRoundedDatePickerStyle(
                                          paddingMonthHeader: EdgeInsets.all(8),
                                        ),
                                      );
                                      if (newDateTime != null) {
                                        setState(() => dateTime = newDateTime);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        // color: Colors.indigo,
                                        border:
                                            Border.all(color: Colors.indigo),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        "${dateTime!.day}/${dateTime!.month}/" +
                                            (dateTime!.year + 543).toString(),
                                        style: _styledefult.copyWith(
                                            color: Colors.indigo
                                            // fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      "เลขที่ใบกำกับ",
                                      style: _styledefult.copyWith(color: white
                                          // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      // color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: TextFormField(
                                      style: _styledefult.copyWith(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      controller: context
                                          .read<ControllerGetPoScreen>()
                                          .goodsReceiving!
                                          .controllerCode,
                                      keyboardType: TextInputType.text,
                                      decoration: new InputDecoration.collapsed(
                                          hintText: ''),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      "วันที่สินค้าถึงร้าน",
                                      style: _styledefult.copyWith(color: white
                                          // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      // color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      f.format(context
                                          .read<ControllerGetPoScreen>()
                                          .goodsReceiving!
                                          .deliveryDateToShop!),
                                      style: _styledefult.copyWith(
                                          color: Colors.indigo
                                          // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            SimpleTextField(
                              verticalPadding: 10,
                              accentColor: Colors.indigo,
                              // labelText: 'หมายเหตุ',
                              textEditingController: context
                                  .read<ControllerGetPoScreen>()
                                  .goodsReceiving!
                                  .head![0]
                                  .remarkHead,
                              // hintStyle: _styledefult,
                              // hintText: "หมายเหตุ",
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      "ประเภทภาษี",
                                      style: _styledefult.copyWith(color: white
                                          // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      // color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      context
                                              .read<ControllerGetPoScreen>()
                                              .goodsReceiving!
                                              .head![0]
                                              .vatName ??
                                          '',
                                      style: _styledefult.copyWith(
                                          color: Colors.indigo
                                          // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchContainerHeight =
                                        !searchContainerHeight;
                                  });
                                },
                                child: Icon(
                                    searchContainerHeight
                                        ? Icons.keyboard_arrow_down_outlined
                                        : Icons.keyboard_arrow_up_outlined,
                                    color: Colors.indigo),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
                Consumer<ControllerGetPoScreen>(
                  builder: (context, value, child) {
                    return Expanded(
                        child: ListView.builder(
                      controller: controller,
                      itemCount: value.goodsReceiving!.head!.length,
                      itemBuilder: (context, index) {
                        List<Head> poDocNo = context
                            .read<ControllerGetPoScreen>()
                            .goodsReceiving!
                            .head!;
                        return poDocNo[index].statusSearch
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${poDocNo[index].docNo} (${poDocNo[index].detail!.length.toString()}) / แผนก ${poDocNo[index].depName}",
                                          style: _styledefult.copyWith(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            value.updateIsShowHead(
                                                index: index);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            child: Text(
                                              '${poDocNo[index].isShow ? "แสดง" : "ซ่อน"}',
                                              style: _styledefult.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (!poDocNo[index].isShow)
                                    ...List.generate(
                                        poDocNo[index].detail!.length,
                                        (index2) {
                                      List<Detail> detail =
                                          poDocNo[index].detail!;
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: detail[index2].statusSuccess
                                              ? Colors.green.shade100
                                              : Colors.blue.shade100,
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4),
                                        child: Stack(
                                          children: [
                                            ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    (detail[index2].lineNumber! +
                                                                1)
                                                            .toString() +
                                                        ' ' +
                                                        (detail[index2]
                                                                .itemCode ??
                                                            '') +
                                                        ' ' +
                                                        (detail[index2]
                                                                .itemName ??
                                                            '') +
                                                        ' ' +
                                                        (detail[index2]
                                                                .unitCode ??
                                                            '') +
                                                        '~' +
                                                        (detail[index2]
                                                                .unitName ??
                                                            ''),
                                                    style:
                                                        _styledefult.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${detail[index2].shelfCode ?? ''} - ${detail[index2].whCode ?? ''}",
                                                        style: _styledefult
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "จำนวนรับ ",
                                                            style: _styledefult
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 3,
                                                                    horizontal:
                                                                        30),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color:
                                                                      kPrimaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Text(
                                                              "${detail[index2].eventQty!.text}",
                                                              style: _styledefult
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          red,
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (detail[index2]
                                                              .price ==
                                                          0)
                                                        Text(
                                                          "ราคา ${detail[index2].price ?? ''}",
                                                          style: _styledefult
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                        ),
                                                    ],
                                                  ),
                                                  Text(
                                                      "${detail[index2].statusSearch} :: ${detail[index2].statusSuccess}")
                                                ],
                                              ),
                                            ),
                                            if (detail[index2].statusSuccess)
                                              Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: detail[index2]
                                                                .statusSuccess ==
                                                            true
                                                        ? () async {
                                                            context
                                                                .read<
                                                                    ControllerGetPoScreen>()
                                                                .updateItemInGoodsReceivingIsTrue(
                                                                    docNo: poDocNo[
                                                                            index]
                                                                        .docNo!,
                                                                    linenumber:
                                                                        detail[index2]
                                                                            .lineNumber!);

                                                            var res = await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    ShowDialogGetRecevices());
                                                            if (res ==
                                                                'FALSE') {
                                                              setState(() {});
                                                              print(res);
                                                              context.read<ControllerGetPoScreen>().updateItemInGoodsReceivingIsSearchFalse(
                                                                  index: poDocNo[
                                                                          index]
                                                                      .docNo!,
                                                                  linenumber: detail[
                                                                          index2]
                                                                      .lineNumber!);
                                                            }
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        600),
                                                                () => SystemChannels
                                                                    .textInput
                                                                    .invokeListMethod(
                                                                        'TextInput.hide'));
                                                          }
                                                        : null,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      height: 30,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .yellow.shade900,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          5),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          5))),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ))
                                          ],
                                        ),
                                      );
                                    })
                                ],
                              )
                            : SizedBox();
                      },
                    ));
                  },
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (builder) => Dialog(
                                  child: Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        Text(
                                          " ระบุเหตุผลยกเลิก/เริ่มรับสินค้า",
                                          style: _styledefult.copyWith(
                                              color: red
                                              // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Container(
                                          color: Colors.grey.shade100,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: TextField(
                                            controller: _reMark,
                                            style: _styledefult.copyWith(
                                                fontSize: 12),
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 400),
                                                      () => SystemChannels
                                                          .textInput
                                                          .invokeListMethod(
                                                              'TextInput.hide'));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 181, 63, 63),
                                                    border: Border.all(
                                                        color: Color.fromARGB(
                                                            255, 181, 63, 63)),
                                                  ),
                                                  child: Text(
                                                    "ปิด",
                                                    style: _styledefult.copyWith(
                                                        color: white
                                                        // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  // if (_reMark.text.isEmpty) {
                                                  //   Fluttertoast.showToast(
                                                  //       msg:
                                                  //           "กรุณากรอกหมายเหตุ");
                                                  // } else {
                                                  //   Navigator.pop(context);
                                                  //   Navigator.pop(
                                                  //       context, 'OK');

                                                  //   context
                                                  //       .read<
                                                  //           ControllerGetPoScreen>()
                                                  //       .clearItemInGoodsReceiving();
                                                  // }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    // borderRadius:
                                                    //     BorderRadius.only(
                                                    //   topLeft:
                                                    //       Radius.circular(5),
                                                    // ),
                                                  ),
                                                  child: Text(
                                                    "ยืนยันยกเลิก",
                                                    style: _styledefult.copyWith(
                                                        color: white
                                                        // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 181, 63, 63),
                          border: Border.all(
                              color: Color.fromARGB(255, 181, 63, 63)),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                          ),
                        ),
                        child: Text(
                          "ยกเลิก/เริ่มรับสินค้า",
                          style: _styledefult.copyWith(color: white
                              // fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // if (context
                        //     .read<ControllerGetPoScreen>()
                        //     .goodsReceiving!
                        //     .head![0]
                        //     .remarkHead!
                        //     .text
                        //     .isNotEmpty) {
                        //   context
                        //       .read<ControllerGetPoScreen>()
                        //       .updateRemarkHead(
                        //           remark: context
                        //               .read<ControllerGetPoScreen>()
                        //               .goodsReceiving!
                        //               .head![0]
                        //               .remarkHead!
                        //               .text);
                        // }

                        // if (context
                        //     .read<ControllerGetPoScreen>()
                        //     .goodsReceiving!
                        //     .head![0]
                        //     .remarkHead!
                        //     .text
                        //     .isNotEmpty) {
                        //   context
                        //       .read<ControllerGetPoScreen>()
                        //       .updateRemarkHeadsupplierCode(
                        //           code: context
                        //               .read<ControllerGetPoScreen>()
                        //               .goodsReceiving!
                        //               .supplier!
                        //               .controllerCode!
                        //               .text);
                        // }

                        if (context
                            .read<ControllerGetPoScreen>()
                            .goodsReceiving!
                            .controllerCode!
                            .text
                            .isEmpty) {
                          Fluttertoast.showToast(msg: "กรุณากรอกเลขที่ใบกำกับ");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BeginGetPoFinal(date: widget.date)));
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            border: Border.all(color: Colors.indigo),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            "ยืนยันรับสินค้า",
                            style: _styledefult.copyWith(color: white
                                // fontWeight: FontWeight.bold,
                                ),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
