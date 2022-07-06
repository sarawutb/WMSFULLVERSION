// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:wms/controllers/controller_login_screen.dart';
// import 'package:wms/models/GoodsReceiving.dart';
// import 'package:wms/screens/get_po_screen/get_po_screen.dart';
// import 'package:wms/themes/colors.dart';

// import '../../../controllers/controller_get_po_screen.dart';
// import '../../../services/http_reponse_service.dart';
// import '../../../widgets/simpleText.dart';

// class BeginGetPoFinal extends StatefulWidget {
//   const BeginGetPoFinal({
//     Key? key,
//     required this.date,
//   }) : super(key: key);
//   final DateTime date;

//   @override
//   _BeginGetPoFinalState createState() => _BeginGetPoFinalState();
// }

// class _BeginGetPoFinalState extends State<BeginGetPoFinal>
//     with TickerProviderStateMixin {
//   TextEditingController _invoiceNumber = TextEditingController();
//   // TextEditingController _reMark = TextEditingController();
//   FocusNode _node = FocusNode();
//   var now = DateTime.now().toLocal();
//   DateTime? dateTime;
//   final f = new DateFormat('dd-MM-yyyy');
//   bool searchContainerHeight = true;
//   final scrollDirection = Axis.vertical;

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
//     final ControllerLoginScreen db = context.read<ControllerLoginScreen>();
//     return WillPopScope(
//         onWillPop: () {
//           // controller.mclearListPodetail();
//           return Future.value(true);
//         },
//         child: Scaffold(
//           backgroundColor: white,
//           body: SafeArea(child: Consumer<ControllerGetPoScreen>(
//             builder: (context, controllerGetPoScreen, child) {
//               GoodsReceiving? goodsReceiving =
//                   controllerGetPoScreen.goodsReceiving;
//               return goodsReceiving != null
//                   ? Stack(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               AnimatedSize(
//                                 vsync: this,
//                                 curve: Curves.bounceIn,
//                                 duration: new Duration(milliseconds: 160),
//                                 child: Container(
//                                   height: searchContainerHeight ? 320 : 120,
//                                   padding: EdgeInsets.all(10),
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           blurRadius: 7,
//                                           color: Colors.grey.shade300,
//                                           offset: Offset(2, 2),
//                                           spreadRadius: 4,
//                                         ),
//                                       ]),
//                                   child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                           height:
//                                               !searchContainerHeight ? 0 : 5,
//                                         ),
//                                         Container(
//                                           alignment: Alignment.center,
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 5, horizontal: 10),
//                                           decoration: BoxDecoration(
//                                             color: Colors.indigo,
//                                             border: Border.all(
//                                                 color: Colors.indigo),
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                           ),
//                                           child: Text(
//                                             "สรุปรายการรับสินค้า",
//                                             textAlign: TextAlign.center,
//                                             style: _styledefult.copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 13,
//                                                 color: Colors.white),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Container(
//                                           alignment: Alignment.centerLeft,
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 5, horizontal: 10),
//                                           decoration: BoxDecoration(
//                                             // color: Colors.indigo,
//                                             border: Border.all(
//                                                 color: Colors.indigo),
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                           ),
//                                           child: Text(
//                                             "เจ้าหนี้ : ${goodsReceiving.supplier!.name ?? ''} [ ${goodsReceiving.supplier!.poDocNo!.length} ]",
//                                             style: _styledefult.copyWith(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 13,
//                                                 color: Colors.indigo),
//                                           ),
//                                         ),
//                                         if (searchContainerHeight) ...[
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topLeft:
//                                                           Radius.circular(5),
//                                                       bottomLeft:
//                                                           Radius.circular(5),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     "วันที่ใบกำกับ",
//                                                     style: _styledefult.copyWith(
//                                                         color: white
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: GestureDetector(
//                                                   onTap: () async {
//                                                     // DateTime? newDateTime =
//                                                     //     await showRoundedDatePicker(
//                                                     //   context: context,
//                                                     //   locale:
//                                                     //       Locale("th", "TH"),
//                                                     //   era:
//                                                     //       EraMode.BUDDHIST_YEAR,
//                                                     //   background:
//                                                     //       Colors.transparent,
//                                                     //   theme: ThemeData(
//                                                     //     primarySwatch:
//                                                     //         Colors.indigo,
//                                                     //   ),
//                                                     //   initialDate: dateTime,
//                                                     //   firstDate: DateTime(
//                                                     //       DateTime.now().year -
//                                                     //           1),
//                                                     //   lastDate: DateTime(
//                                                     //       DateTime.now().year +
//                                                     //           1),
//                                                     //   styleDatePicker:
//                                                     //       MaterialRoundedDatePickerStyle(
//                                                     //     paddingMonthHeader:
//                                                     //         EdgeInsets.all(8),
//                                                     //   ),
//                                                     // );
//                                                     // if (newDateTime != null) {
//                                                     //   setState(() => dateTime =
//                                                     //       newDateTime);
//                                                     // }
//                                                   },
//                                                   child: Container(
//                                                     alignment:
//                                                         Alignment.centerLeft,
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                             .size
//                                                             .width,
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             vertical: 5,
//                                                             horizontal: 10),
//                                                     decoration: BoxDecoration(
//                                                       // color: Colors.indigo,
//                                                       border: Border.all(
//                                                           color: Colors.indigo),
//                                                       borderRadius:
//                                                           BorderRadius.only(
//                                                         topRight:
//                                                             Radius.circular(5),
//                                                         bottomRight:
//                                                             Radius.circular(5),
//                                                       ),
//                                                     ),
//                                                     child: Text(
//                                                       "${dateTime!.day}/${dateTime!.month}/" +
//                                                           (dateTime!.year + 543)
//                                                               .toString(),
//                                                       style: _styledefult.copyWith(
//                                                           color: Colors.indigo
//                                                           // fontWeight: FontWeight.bold,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topLeft:
//                                                           Radius.circular(5),
//                                                       bottomLeft:
//                                                           Radius.circular(5),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     "เลขที่ใบกำกับ",
//                                                     style: _styledefult.copyWith(
//                                                         color: white
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     // color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topRight:
//                                                           Radius.circular(5),
//                                                       bottomRight:
//                                                           Radius.circular(5),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     "${goodsReceiving.supplier!.code}",
//                                                     style: _styledefult.copyWith(
//                                                         color: Colors.indigo
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topLeft:
//                                                           Radius.circular(5),
//                                                       bottomLeft:
//                                                           Radius.circular(5),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     "วันที่สินค้าถึงร้าน",
//                                                     style: _styledefult.copyWith(
//                                                         color: white
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     // color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topRight:
//                                                           Radius.circular(5),
//                                                       bottomRight:
//                                                           Radius.circular(5),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     "${goodsReceiving.supplier?.deliveryDate}",
//                                                     style: _styledefult.copyWith(
//                                                         color: Colors.indigo
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 7,
//                                           ),
//                                           SimpleTextField(
//                                             verticalPadding: 10,
//                                             accentColor: Colors.indigo,
//                                             // labelText: 'หมายเหตุ',
//                                             enabled: false,

//                                             hintStyle: _styledefult.copyWith(
//                                               color: black,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                             hintText:
//                                                 goodsReceiving.supplier!.remark,
//                                           ),
//                                           SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Expanded(
//                                                 child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topLeft:
//                                                           Radius.circular(5),
//                                                       bottomLeft:
//                                                           Radius.circular(5),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     "ประเภทภาษี",
//                                                     style: _styledefult.copyWith(
//                                                         color: white
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Container(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   width: MediaQuery.of(context)
//                                                       .size
//                                                       .width,
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 5,
//                                                       horizontal: 10),
//                                                   decoration: BoxDecoration(
//                                                     // color: Colors.indigo,
//                                                     border: Border.all(
//                                                         color: Colors.indigo),
//                                                     borderRadius:
//                                                         BorderRadius.only(
//                                                       topRight:
//                                                           Radius.circular(5),
//                                                       bottomRight:
//                                                           Radius.circular(5),
//                                                     ),
//                                                   ),
//                                                   child: Text(
//                                                     "${goodsReceiving.supplier!.vatType == 0 ? "แยกนอก" : goodsReceiving.supplier!.vatType == 1 ? "รวมใน" : "อัตราศูนย์"}",
//                                                     style: _styledefult.copyWith(
//                                                         color: Colors.indigo
//                                                         // fontWeight: FontWeight.bold,
//                                                         ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                         Spacer(),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   searchContainerHeight =
//                                                       !searchContainerHeight;
//                                                 });
//                                               },
//                                               child: Icon(
//                                                   searchContainerHeight
//                                                       ? Icons
//                                                           .keyboard_arrow_down_outlined
//                                                       : Icons
//                                                           .keyboard_arrow_up_outlined,
//                                                   color: Colors.indigo),
//                                             ),
//                                           ],
//                                         ),
//                                       ]),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Expanded(
//                                   child: ListView.builder(
//                                 controller: controller,
//                                 itemCount:
//                                     goodsReceiving.supplier!.poDocNo!.length,
//                                 itemBuilder: (context, index) {
//                                   List<PoDocNo> poDocNo =
//                                       goodsReceiving.supplier!.poDocNo!;
//                                   return Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // if (poDocNo[index].head!.detail!.any(
//                                       //     (element) =>
//                                       //         element.statusSuccess == true))
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 5),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${poDocNo[index].head?.docNo ?? ''} (${poDocNo[index].head!.detail!.where((element) => element.statusSuccess == true).length.toString()}) / แผนก ${poDocNo[index].head!.departMentName}",
//                                               style: _styledefult.copyWith(
//                                                   color: Colors.indigo,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 controllerGetPoScreen
//                                                     .updateIsShowHead(
//                                                         index: index);
//                                               },
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.indigo,
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                 ),
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 10,
//                                                     vertical: 3),
//                                                 child: Text(
//                                                   '${poDocNo[index].head!.isShow ? "แสดง" : "ซ่อน"}',
//                                                   style: _styledefult.copyWith(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       if (!poDocNo[index].head!.isShow)
//                                         ...List.generate(
//                                             poDocNo[index].head!.detail!.length,
//                                             (index2) {
//                                           List<Detail> detail =
//                                               poDocNo[index].head!.detail!;
//                                           return (detail[index2]
//                                                           .statusSuccess ==
//                                                       true ||
//                                                   true)
//                                               ? Container(
//                                                   alignment: Alignment.center,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                     // border: Border.all(
//                                                     //     color: detail[index2]
//                                                     //                 .statusSearch ==
//                                                     //             true
//                                                     //         ? Colors.green.shade500
//                                                     //         : Colors.transparent,
//                                                     //     width: 2),
//                                                     color: detail[index2]
//                                                             .statusSuccess!
//                                                         ? Colors.green.shade100
//                                                         : Colors.grey.shade100,
//                                                   ),
//                                                   margin: EdgeInsets.symmetric(
//                                                       vertical: 4),
//                                                   child: ListTile(
//                                                     title: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Text(
//                                                           (detail[index2].lineNumber! +
//                                                                       1)
//                                                                   .toString() +
//                                                               ' ' +
//                                                               (detail[index2]
//                                                                       .itemCode ??
//                                                                   '') +
//                                                               ' ' +
//                                                               (detail[index2]
//                                                                       .itemName ??
//                                                                   '') +
//                                                               ' ' +
//                                                               (detail[index2]
//                                                                       .unitCode ??
//                                                                   '') +
//                                                               '~' +
//                                                               (detail[index2]
//                                                                       .unitCode ??
//                                                                   ''),
//                                                           style: _styledefult
//                                                               .copyWith(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   fontSize: 12),
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Text(
//                                                               "${detail[index2].shelfCode ?? ''} - ${detail[index2].whName ?? ''}",
//                                                               style: _styledefult
//                                                                   .copyWith(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       fontSize:
//                                                                           12),
//                                                             ),
//                                                             Row(
//                                                               children: [
//                                                                 Text(
//                                                                   "จำนวนรับ ",
//                                                                   style: _styledefult.copyWith(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       fontSize:
//                                                                           12),
//                                                                 ),
//                                                                 Text(
//                                                                   "${(detail[index2].receivingQty == 0.0 && detail[index2].statusSuccess == false) ? '' : detail[index2].receivingQty}",
//                                                                   style: _styledefult.copyWith(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       color:
//                                                                           red,
//                                                                       fontSize:
//                                                                           12),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             Text(
//                                                               "ราคา ${detail[index2].price ?? ''}",
//                                                               style: _styledefult
//                                                                   .copyWith(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       fontSize:
//                                                                           12),
//                                                             ),
//                                                           ],
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 )
//                                               : SizedBox.shrink();
//                                         })
//                                     ],
//                                   );
//                                 },
//                               )),
//                               SizedBox(
//                                 height: 50,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       showDialog(
//                                           barrierDismissible: false,
//                                           context: context,
//                                           builder: (builder) => AlertDialog(
//                                                 content: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   children: [
//                                                     Container(
//                                                       alignment:
//                                                           Alignment.topCenter,
//                                                       color: white,
//                                                       width: double.infinity,
//                                                       child:
//                                                           SingleChildScrollView(
//                                                         child: Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .center,
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             SizedBox(
//                                                               height: 5,
//                                                             ),
//                                                             Text(
//                                                               "บันทึกรับสินค้าสำเร็จ",
//                                                               style: _styledefult
//                                                                   .copyWith(
//                                                                       color:
//                                                                           black,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       fontSize:
//                                                                           16),
//                                                             ),
//                                                             Text(
//                                                               "ใบรับสินค้าเลขที่",
//                                                               style:
//                                                                   _styledefult
//                                                                       .copyWith(
//                                                                 color: black,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               ),
//                                                             ),
//                                                             ...List.generate(
//                                                                 controllerGetPoScreen
//                                                                     .goodsReceiving!
//                                                                     .supplier!
//                                                                     .poDocNo!
//                                                                     .length,
//                                                                 (index) {
//                                                               List<PoDocNo>
//                                                                   _list =
//                                                                   controllerGetPoScreen
//                                                                       .goodsReceiving!
//                                                                       .supplier!
//                                                                       .poDocNo!;
//                                                               return Text(
//                                                                 "${_list[index].head!.docNo ?? ''}",
//                                                                 style:
//                                                                     _styledefult
//                                                                         .copyWith(
//                                                                   color: black,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                 ),
//                                                               );
//                                                             }),
//                                                             SizedBox(
//                                                               height: 20,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment.end,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                               child:
//                                                                   GestureDetector(
//                                                                 onTap:
//                                                                     () async {
//                                                                   // print(goodsReceivingToJson(context
//                                                                   //     .read<
//                                                                   //         ControllerGetPoScreen>()
//                                                                   //     .goodsReceiving!));
//                                                                   debugPrint(goodsReceivingToJson(context
//                                                                       .read<
//                                                                           ControllerGetPoScreen>()
//                                                                       .goodsReceiving!));
//                                                                   var response =
//                                                                       goodsReceivingToJson(context
//                                                                           .read<
//                                                                               ControllerGetPoScreen>()
//                                                                           .goodsReceiving!);
//                                                                   var res = await RequestAssistant.postRequestHttpResponse(
//                                                                       url:
//                                                                           "http://192.168.65.109:5000/jsonFile",
//                                                                       body: json
//                                                                           .encode(
//                                                                               response));

//                                                                   // await controllerGetPoScreen
//                                                                   //     .clearItemInGoodsReceiving();
//                                                                   // Navigator.pushAndRemoveUntil(
//                                                                   //     context,
//                                                                   //     MaterialPageRoute(
//                                                                   //         builder: (BuildContext context) =>
//                                                                   //             GetPoScreen()),
//                                                                   //     (route) =>
//                                                                   //         false);
//                                                                 },
//                                                                 child:
//                                                                     Container(
//                                                                   alignment:
//                                                                       Alignment
//                                                                           .center,
//                                                                   width: MediaQuery.of(
//                                                                           context)
//                                                                       .size
//                                                                       .width,
//                                                                   padding: EdgeInsets.symmetric(
//                                                                       vertical:
//                                                                           10,
//                                                                       horizontal:
//                                                                           10),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     color: Colors
//                                                                         .green,
//                                                                     border: Border.all(
//                                                                         color: Colors
//                                                                             .green),
//                                                                     // borderRadius:
//                                                                     //     BorderRadius.only(
//                                                                     //   topLeft:
//                                                                     //       Radius.circular(5),
//                                                                     // ),
//                                                                   ),
//                                                                   child: Text(
//                                                                     "ยืนยันรับสินค้า",
//                                                                     style: _styledefult.copyWith(
//                                                                         color:
//                                                                             white
//                                                                         // fontWeight: FontWeight.bold,
//                                                                         ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         )
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ));
//                                     },
//                                     child: Container(
//                                         alignment: Alignment.center,
//                                         margin: EdgeInsets.symmetric(
//                                             vertical: 10, horizontal: 10),
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 10, horizontal: 10),
//                                         decoration: BoxDecoration(
//                                           color: Colors.green,
//                                           border:
//                                               Border.all(color: Colors.green),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10)),
//                                         ),
//                                         child: Text(
//                                           "บันทึกรับสินค้า",
//                                           style: _styledefult.copyWith(
//                                               color: white
//                                               // fontWeight: FontWeight.bold,
//                                               ),
//                                         )),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     )
//                   : SizedBox.shrink();
//             },
//           )),
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
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/models/GoodsReceiving.dart';
import 'package:wms/screens/get_po_screen/get_po_screen.dart';
import 'package:wms/themes/colors.dart';

import '../../../controllers/controller_get_po_screen.dart';
import '../../../models/product_model.dart';
import '../../../services/http_reponse_service.dart';
import '../../../widgets/simpleText.dart';
import 'package:http/http.dart' as http;

class BeginGetPoFinal extends StatefulWidget {
  const BeginGetPoFinal({
    Key? key,
    required this.date,
  }) : super(key: key);
  final DateTime date;

  @override
  _BeginGetPoFinalState createState() => _BeginGetPoFinalState();
}

class _BeginGetPoFinalState extends State<BeginGetPoFinal>
    with TickerProviderStateMixin {
  TextEditingController _invoiceNumber = TextEditingController();
  // TextEditingController _reMark = TextEditingController();
  FocusNode _node = FocusNode();
  var now = DateTime.now().toLocal();
  DateTime? dateTime;
  final f = new DateFormat('dd-MM-yyyy');
  bool searchContainerHeight = true;
  final scrollDirection = Axis.vertical;

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
    final ControllerLoginScreen db = context.read<ControllerLoginScreen>();
    return WillPopScope(
        onWillPop: () {
          // controller.mclearListPodetail();
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: white,
          body: SafeArea(child: Consumer<ControllerGetPoScreen>(
            builder: (context, controllerGetPoScreen, child) {
              GoodsReceiving? goodsReceiving =
                  controllerGetPoScreen.goodsReceiving;
              return goodsReceiving != null
                  ? Stack(
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
                                  height: searchContainerHeight ? 320 : 120,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height:
                                              !searchContainerHeight ? 0 : 5,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.indigo,
                                            border: Border.all(
                                                color: Colors.indigo),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            "สรุปรายการรับสินค้า",
                                            textAlign: TextAlign.center,
                                            style: _styledefult.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                            // color: Colors.indigo,
                                            border: Border.all(
                                                color: Colors.indigo),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            "เจ้าหนี้ : ${goodsReceiving.apName ?? ''}",
                                            style: _styledefult.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.indigo),
                                          ),
                                        ),
                                        if (searchContainerHeight) ...[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "วันที่ใบกำกับ",
                                                    style: _styledefult.copyWith(
                                                        color: white
                                                        // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    // DateTime? newDateTime =
                                                    //     await showRoundedDatePicker(
                                                    //   context: context,
                                                    //   locale:
                                                    //       Locale("th", "TH"),
                                                    //   era:
                                                    //       EraMode.BUDDHIST_YEAR,
                                                    //   background:
                                                    //       Colors.transparent,
                                                    //   theme: ThemeData(
                                                    //     primarySwatch:
                                                    //         Colors.indigo,
                                                    //   ),
                                                    //   initialDate: dateTime,
                                                    //   firstDate: DateTime(
                                                    //       DateTime.now().year -
                                                    //           1),
                                                    //   lastDate: DateTime(
                                                    //       DateTime.now().year +
                                                    //           1),
                                                    //   styleDatePicker:
                                                    //       MaterialRoundedDatePickerStyle(
                                                    //     paddingMonthHeader:
                                                    //         EdgeInsets.all(8),
                                                    //   ),
                                                    // );
                                                    // if (newDateTime != null) {
                                                    //   setState(() => dateTime =
                                                    //       newDateTime);
                                                    // }
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.indigo,
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(5),
                                                        bottomRight:
                                                            Radius.circular(5),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "${dateTime!.day}/${dateTime!.month}/" +
                                                          (dateTime!.year + 543)
                                                              .toString(),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "เลขที่ใบกำกับ",
                                                    style: _styledefult.copyWith(
                                                        color: white
                                                        // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "${goodsReceiving.supCode}",
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
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "วันที่สินค้าถึงร้าน",
                                                    style: _styledefult.copyWith(
                                                        color: white
                                                        // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    f.format(context
                                                        .read<
                                                            ControllerGetPoScreen>()
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
                                            enabled: false,

                                            hintStyle: _styledefult.copyWith(
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            hintText:
                                                goodsReceiving.head![0].remark,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "ประเภทภาษี",
                                                    style: _styledefult.copyWith(
                                                        color: white
                                                        // fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.indigo,
                                                    border: Border.all(
                                                        color: Colors.indigo),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(5),
                                                      bottomRight:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "${goodsReceiving.head![0].vatName}",
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                      ? Icons
                                                          .keyboard_arrow_down_outlined
                                                      : Icons
                                                          .keyboard_arrow_up_outlined,
                                                  color: Colors.indigo),
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                  child: ListView.builder(
                                controller: controller,
                                itemCount: goodsReceiving.head!.length,
                                itemBuilder: (context, index) {
                                  List<Head> poDocNo = goodsReceiving.head!;
                                  return poDocNo[index].statusSearch
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // if (poDocNo[index].head!.detail!.any(
                                            //     (element) =>
                                            //         element.statusSuccess == true))
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${poDocNo[index].docNo ?? ''} (${poDocNo[index].detail!.where((element) => element.statusSuccess == true).length.toString()}) / แผนก ${poDocNo[index].depName}",
                                                    style:
                                                        _styledefult.copyWith(
                                                            color:
                                                                Colors.indigo,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controllerGetPoScreen
                                                          .updateIsShowHead(
                                                              index: index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.indigo,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 3),
                                                      child: Text(
                                                        '${poDocNo[index].isShow ? "แสดง" : "ซ่อน"}',
                                                        style: _styledefult
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                        BorderRadius.circular(
                                                            10),
                                                    // border: Border.all(
                                                    //     color: detail[index2]
                                                    //                 .statusSearch ==
                                                    //             true
                                                    //         ? Colors.green.shade500
                                                    //         : Colors.transparent,
                                                    //     width: 2),
                                                    color: detail[index2]
                                                            .statusSuccess
                                                        ? Colors.green.shade100
                                                        : Colors.grey.shade100,
                                                  ),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 4),
                                                  child: ListTile(
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                                      .unitCode ??
                                                                  ''),
                                                          style: _styledefult
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${detail[index2].shelfCode ?? ''} - ${detail[index2].whCode ?? ''}",
                                                              style: _styledefult
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "จำนวนรับ ",
                                                                  style: _styledefult.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              3,
                                                                          horizontal:
                                                                              30),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    border: Border.all(
                                                                        color:
                                                                            kPrimaryColor),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child: Text(
                                                                    "${(double.parse(detail[index2].eventQty!.text) == 0 && detail[index2].statusSuccess == false) ? '' : detail[index2].eventQty!.text}",
                                                                    style: _styledefult.copyWith(
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
                                                                style: _styledefult.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })
                                          ],
                                        )
                                      : SizedBox.shrink();
                                },
                              )),
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
                                    onTap: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (builder) => AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      color: white,
                                                      width: double.infinity,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "บันทึกรับสินค้าสำเร็จ",
                                                              style: _styledefult
                                                                  .copyWith(
                                                                      color:
                                                                          black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                            Text(
                                                              "ใบรับสินค้าเลขที่",
                                                              style:
                                                                  _styledefult
                                                                      .copyWith(
                                                                color: black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            ...List.generate(
                                                                controllerGetPoScreen
                                                                    .goodsReceiving!
                                                                    .head!
                                                                    .length,
                                                                (index) {
                                                              List<Head> _list =
                                                                  controllerGetPoScreen
                                                                      .goodsReceiving!
                                                                      .head!;
                                                              return _list[
                                                                          index]
                                                                      .statusSearch
                                                                  ? Text(
                                                                      "${_list[index].docNo ?? ''}",
                                                                      style: _styledefult
                                                                          .copyWith(
                                                                        color:
                                                                            black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    )
                                                                  : SizedBox
                                                                      .shrink();
                                                            }),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  List<
                                                                      Map<String,
                                                                          dynamic>> jsonFile = List
                                                                      .generate(
                                                                          context
                                                                              .read<ControllerGetPoScreen>()
                                                                              .goodsReceiving!
                                                                              .head!
                                                                              .length,
                                                                          (index) => context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].statusSearch
                                                                              ? {
                                                                                  "head": {
                                                                                    "isTest": 1,
                                                                                    "docDate": "${context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].docDate}", //doc_date
                                                                                    "DeliveryDate": "2021-03-1",
                                                                                    "docFormat": "X01-RRV", //doc_format_code
                                                                                    "InquiryType": 1, //inquiry_type 0 = แยกนอก , 1 รวมใน
                                                                                    "VatType": 1, //vat_type ประเภทภาษี 0=แยกนอก ,1=รวมใน,2=อัตราศูนย์
                                                                                    "CustCode": "144904", //cust_code
                                                                                    "branchCode": "X01", //branch_code
                                                                                    "departCode": "001", //department_code
                                                                                    "creatorCode": "10862", //creator_code
                                                                                    "CreditDay": 45, //delivery_date
                                                                                    "VatRate": 7.0, //vat_rate
                                                                                    "TotalValue": 128112.25, //total_value
                                                                                    "discountWord": "", //discount_word
                                                                                    "TotalDiscount": 0.0, //total_discount
                                                                                    "TotalVatValue": 8381.18, //total_vat_value
                                                                                    "TotalAmount": 128112.25, //total_amount
                                                                                    "Remark": "ทดอบ MIS API WMS", //remark
                                                                                    "TotalBeforeVat": 119731.07, //total_before_vat
                                                                                    "totalAfterVat": 128112.25, //total_after_vat
                                                                                    "taxDocNo": "123456789", //tax_doc_no
                                                                                    "taxDocDate": "2022-03-02", //tax_doc_date
                                                                                    "DocRef": "X01-POV6506-00002-001" //doc_ref,
                                                                                    ,
                                                                                    "detail": List.generate(
                                                                                        context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].detail!.length,
                                                                                        (indexDetail) => context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].detail![indexDetail].statusSuccess
                                                                                            ? {
                                                                                                "itemCode": context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].detail![indexDetail].itemCode,
                                                                                                "itemName": context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].detail![indexDetail].itemName,
                                                                                                "unitCode": context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].detail![indexDetail].unitCode,
                                                                                                "qty": 175.00,
                                                                                                "price": 732.070,
                                                                                                "discountWord": null,
                                                                                                "discountAmount": 0.0,
                                                                                                "SumAmount": 128112.25,
                                                                                                "lineNumber": 0,
                                                                                                "whCode": "X01",
                                                                                                "shelfCode": "W2-Z03-2",
                                                                                                "priceGuid": null,
                                                                                                "priceExcludeVat": 684.18,
                                                                                                "totalVatValue": 8381.18,
                                                                                                "sumAmountExcludeVat": 119731.07,
                                                                                                "RefDocNo": "X01-POV6502-00006",
                                                                                                "RefDocDate": "2022-2-5",
                                                                                                "event_qty": context.read<ControllerGetPoScreen>().goodsReceiving!.head![index].detail![indexDetail].eventQty!.text,
                                                                                                "RefRow": 0,
                                                                                                "RefRemark": "สต้อกขายโครงการ ราคารวมภาษีอีก7%  เครดิต 60 วัน รับเองที่โรงงาน  X01-PR6401-00018 นน.6.7 ตัน"
                                                                                              }
                                                                                            : null)
                                                                                  },

                                                                                  // [

                                                                                  // ]
                                                                                }
                                                                              : {});

                                                                  var headers =
                                                                      {
                                                                    'Content-Type':
                                                                        'application/json'
                                                                  };
                                                                  var request =
                                                                      http.Request(
                                                                          'POST',
                                                                          Uri.parse(
                                                                              'http://192.168.65.109:5000/jsonFile?test=1'));
                                                                  request.body =
                                                                      json.encode(
                                                                          jsonFile);
                                                                  request
                                                                      .headers
                                                                      .addAll(
                                                                          headers);

                                                                  http.StreamedResponse
                                                                      response =
                                                                      await request
                                                                          .send();

                                                                  if (response
                                                                          .statusCode ==
                                                                      200) {
                                                                    print(await response
                                                                        .stream
                                                                        .bytesToString());
                                                                  } else {
                                                                    print(response
                                                                        .reasonPhrase);
                                                                  }

                                                                  Navigator.pop(
                                                                      context);
                                                                  // print(
                                                                  //     jsonFile);

                                                                  // var headers =
                                                                  //     {
                                                                  //   'Content-Type':
                                                                  //       'application/json'
                                                                  // };
                                                                  // await RequestAssistant.postRequestHttpResponse(
                                                                  //         url:
                                                                  //             "http://192.168.65.109:5000/jsonFile?test=1",
                                                                  //         headers:
                                                                  //             headers,
                                                                  //         body: json.encode(
                                                                  //             jsonFile))
                                                                  //     .catchError(
                                                                  //         (e) {
                                                                  //   print(e);
                                                                  // });

                                                                  // await controllerGetPoScreen
                                                                  //     .clearItemInGoodsReceiving();
                                                                  // Navigator.pushAndRemoveUntil(
                                                                  //     context,
                                                                  //     MaterialPageRoute(
                                                                  //         builder: (BuildContext context) =>
                                                                  //             GetPoScreen()),
                                                                  //     (route) =>
                                                                  //         false);
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .green),
                                                                    // borderRadius:
                                                                    //     BorderRadius.only(
                                                                    //   topLeft:
                                                                    //       Radius.circular(5),
                                                                    // ),
                                                                  ),
                                                                  child: Text(
                                                                    "ยืนยันรับสินค้า",
                                                                    style: _styledefult.copyWith(
                                                                        color:
                                                                            white
                                                                        // fontWeight: FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          border:
                                              Border.all(color: Colors.green),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Text(
                                          "บันทึกรับสินค้า",
                                          style: _styledefult.copyWith(
                                              color: white
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
                    )
                  : SizedBox.shrink();
            },
          )),
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
}
