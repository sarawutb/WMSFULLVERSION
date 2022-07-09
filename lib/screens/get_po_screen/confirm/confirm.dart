// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:wms/controllers/controller_get_po_screen.dart';
// import 'package:wms/models/podetail.dart';
// import 'package:wms/themes/app_color.dart';
// import 'package:wms/themes/colors.dart';
// import 'package:wms/widgets/serchbar.dart';

// class ConfirmScreen extends StatefulWidget {
//   const ConfirmScreen({Key? key, required this.date}) : super(key: key);
//   final DateTime date;
//   @override
//   _ConfirmScreenState createState() => _ConfirmScreenState();
// }

// class _ConfirmScreenState extends State<ConfirmScreen> {
//   final f = new DateFormat('yyyy-MM-dd');
//   @override
//   Widget build(BuildContext context) {
//     final TextStyle _style = Theme.of(context)
//         .textTheme
//         .headline6!
//         .copyWith(color: AppColor.kTextBlack, fontSize: kdefultsize - 8);
//     // ControllerGetPoScreen controller = context.read<ControllerGetPoScreen>();

//     return WillPopScope(
//       onWillPop: () {
//         // controller.mclearListPodetail();
//         return Future.value(true);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(
//               Icons.arrow_back_outlined,
//               size: kdefultsize,
//               color: black,
//             ),
//           ),
//           elevation: 0,
//           centerTitle: true,
//           title: Text("รับสินค้า"),
//         ),
//         backgroundColor: white,
//         body: Consumer<ControllerGetPoScreen>(
//           builder: (context, controllergetproductscreen, child) {
//             return Stack(
//               children: [
//                 SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SafeArea(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "เจ้าหนนี้ ${controllergetproductscreen.listProductPo?.arName ?? ''}",
//                                 style: _style.copyWith(
//                                     fontWeight: FontWeight.w700),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   controllergetproductscreen
//                                       .updateSubCheckBox();
//                                 },
//                                 child: Text(
//                                   "${!controllergetproductscreen.listProductPo!.boolcheckBox ? "แสดงน้อยลง" : "แสดงเพิ่ม"}",
//                                   style: _style.copyWith(
//                                       fontWeight: FontWeight.bold, color: red),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (!controllergetproductscreen
//                           .listProductPo!.boolcheckBox)
//                         Column(
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     " วันที่ใบกำกับ : ",
//                                     style: _style.copyWith(
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   Expanded(
//                                     child: SizedBox(
//                                       height: 30,
//                                       child: Card(
//                                         elevation: 0,
//                                         color: Colors.amber[50],
//                                         child: Text(
//                                           f.format(controllergetproductscreen
//                                               .listProductPo!.date!),
//                                           style: _style,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: SizedBox(
//                                       height: 30,
//                                       child: Card(
//                                         elevation: 0,
//                                         color: Colors.amber[50],
//                                         child: SearchBar(
//                                           fontSize: 12,
//                                           enabled: false,
//                                           iconSize: 0,
//                                           title:
//                                               "${controllergetproductscreen.listProductPo!.invoiceNumber ?? ''}",
//                                           contentPadding: 10,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     " วันที่สินค้าถึงร้าน  : ",
//                                     style: _style.copyWith(
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   Expanded(
//                                     child: SizedBox(
//                                       height: 30,
//                                       child: Card(
//                                         elevation: 0,
//                                         color: Colors.green[50],
//                                         child: Text(
//                                           f.format(widget.date),
//                                           style: _style,
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     " หมายเหตุ  : ",
//                                     style: _style.copyWith(
//                                         fontWeight: FontWeight.w700),
//                                   ),
//                                   Expanded(
//                                     child: SizedBox(
//                                       height: 80,
//                                       child: Card(
//                                         elevation: 0,
//                                         color: Colors.amber[50],
//                                         child: SearchBar(
//                                           fontSize: 12,
//                                           iconSize: 0,
//                                           enabled: false,
//                                           title:
//                                               "${controllergetproductscreen.listProductPo!.description ?? ''}",
//                                           contentPadding: 10,
//                                           maxLines: 4,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       if (controllergetproductscreen
//                               .listProductPo!.listdetail !=
//                           null)
//                         ...List.generate(
//                             controllergetproductscreen
//                                 .listProductPo!.listdetail!.length, (index) {
//                           List<PoDetail> _list = controllergetproductscreen
//                               .listProductPo!.listdetail!;
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 1),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     // Checkbox(
//                                     //   checkColor: Colors.white,
//                                     //   splashRadius: 0,
//                                     //   fillColor:
//                                     //       MaterialStateProperty.all(Colors.green),
//                                     //   value: _list[index].checkBox,
//                                     //   shape: CircleBorder(),
//                                     //   onChanged: (bool? value) {
//                                     //     controllergetproductscreen.updateCheckBox(
//                                     //         index: index);
//                                     //   },
//                                     // ),
//                                     Text(_list[index].docNo ?? '',
//                                         style: _style),
//                                     Spacer(),
//                                     Text(
//                                       "${_list[index].shelfName ?? ''}",
//                                       style: _style,
//                                     ),
//                                     // TextButton(
//                                     //     onPressed: () {
//                                     //       controllergetproductscreen.updateHide(
//                                     //           index: index);
//                                     //     },
//                                     //     child: Text(
//                                     //         "${_list[index].hide ? "แสดง" : "ซ่อน"}"))
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 ListTile(
//                                   // onTap: () => Navigator.push(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //         builder: (_) =>
//                                   //             GetPoUpdate(poDetail: _list[index]))),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(20.0)),
//                                   selected: true,
//                                   selectedTileColor: _list[index].statusSuccess
//                                       ? Colors.green[100]
//                                       : Colors.blue[100],
//                                   isThreeLine: true,
//                                   minLeadingWidth: 20,
//                                   // leading: Text(
//                                   //   '${_list[index].lineNumber ?? ''}',
//                                   //   style: _style,
//                                   // ),
//                                   title: Text(
//                                     '[${_list[index].itemCode}] ${_list[index].itemName}',
//                                     textAlign: TextAlign.left,
//                                     style: _style.copyWith(
//                                       color: black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   subtitle: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             '${_list[index].shelfCode} ~ ${_list[index].shelfName} ',
//                                             style: _style,
//                                           ),
//                                           Text(
//                                             'หน่วยนับ ${_list[index].unitCode} ~ ${_list[index].unitName} ',
//                                             style: _style,
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'ราคา ${_list[index].price} บาท',
//                                             style: _style,
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'ค้างรับ ${_list[index].qtyBalance}',
//                                             style: _style.copyWith(
//                                               color: Colors.red[800],
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                             'จำนวนรับ ${_list[index].newRecQty ?? ''}',
//                                             style: _style.copyWith(
//                                               color: Colors.green[800],
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         }),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [Text("")],
//                       )
//                     ],
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                             child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: ElevatedButton(
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all(
//                                   Colors.green[600],
//                                 ),
//                               ),
//                               onPressed: () {
//                                 print(controllergetproductscreen.listProductPo!
//                                     .toJson());
//                                 var response = controllergetproductscreen
//                                     .listProductPo!
//                                     .toJson();
//                                 debugPrint(response.toString());
//                               },
//                               child: Text(
//                                 "บันทึกรับสินค้า",
//                                 style: _style.copyWith(
//                                     color: white, fontWeight: FontWeight.bold),
//                               )),
//                         ))
//                       ],
//                     )
//                   ],
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
