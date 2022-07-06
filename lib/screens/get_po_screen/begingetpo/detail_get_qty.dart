// import 'package:flutter/material.dart';
// import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:wms/models/GoodsReceiving.dart';
// import 'package:wms/themes/app_color.dart';
// import 'package:wms/themes/colors.dart';
// import 'package:wms/widgets/serchbar.dart';

// class DetailGetQty extends StatefulWidget {
//   const DetailGetQty(
//       {Key? key, required this.goodsReceiving, required this.detail})
//       : super(key: key);
//   final GoodsReceiving goodsReceiving;
//   final List<Detail> detail;
//   @override
//   State<DetailGetQty> createState() => _DetailGetQtyState();
// }

// class _DetailGetQtyState extends State<DetailGetQty> {
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle _styledefult =
//         Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11);
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(
//             Icons.arrow_back_outlined,
//             size: kdefultsize,
//             color: black,
//           ),
//         ),
//         elevation: 0,
//         centerTitle: true,
//         title: Text("รับสินค้า"),
//       ),
//       backgroundColor: white,
//       body: Stack(
//         children: [
//           ListView(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Text(
//                       "เจ้าหนี้ : ${widget.goodsReceiving.head!.taxDocNo ?? ''} [ ${widget.goodsReceiving.detail!.length} ]",
//                       style: _styledefult.copyWith(fontWeight: FontWeight.bold),
//                     ),
//                     Spacer(),
//                     TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           "W2-Z03-2 พื้นที่เหล็กท่าบ่อ",
//                           style: _styledefult.copyWith(
//                               fontWeight: FontWeight.bold, color: blue),
//                         )),
//                   ],
//                 ),
//               ),
//               ...List.generate(
//                 widget.detail.length,
//                 (index) => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 0),
//                   child: ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           (widget.goodsReceiving.detail![index].lineNumber! + 1)
//                                   .toString() +
//                               ' ' +
//                               (widget.goodsReceiving.detail![index].itemCode ??
//                                   '') +
//                               ' ' +
//                               (widget.goodsReceiving.detail![index].itemName ??
//                                   '') +
//                               ' หน่วยนับ ' +
//                               (widget.goodsReceiving.detail![index].unitCode ??
//                                   '') +
//                               '~' +
//                               '' +
//                               (widget.goodsReceiving.detail![index].unitCode ??
//                                   ''),
//                           style: _styledefult.copyWith(
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               'ราคา ',
//                               style: _styledefult.copyWith(
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               '${widget.detail[index].price ?? 0}',
//                               style: _styledefult.copyWith(
//                                   fontWeight: FontWeight.normal),
//                             ),
//                             Text(
//                               ' บาท',
//                               style: _styledefult.copyWith(
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 30,
//                           child: Row(
//                             children: [
//                               Text(
//                                 "ระบุจำนวน ",
//                                 style: _styledefult,
//                               ),
//                               Container(
//                                 width: 60,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(color: Colors.purple)),
//                                 child: TextField(
//                                   style: _styledefult,
//                                   decoration: InputDecoration(
//                                     enabledBorder: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 10, top: 0, bottom: 18),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Text(
//                                 "หน่วยนับ ${widget.detail[index].unitCode}",
//                                 style: _styledefult,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         SizedBox(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "หมายเหตุ : ",
//                                 style: _styledefult,
//                               ),
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       border: Border.all(color: blue)),
//                                   child: TextField(
//                                     maxLines: 2,
//                                     keyboardType: TextInputType.multiline,
//                                     decoration: InputDecoration(
//                                         contentPadding: EdgeInsets.only(
//                                             left: 10, bottom: 10)),
//                                     style: _styledefult,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             GestureDetector(
//                               onTap: () => getCamera(),
//                               child: Text(
//                                 "รูป",
//                                 style: _styledefult.copyWith(color: blue),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: 100,
//                       height: 40,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: AppColor.kPrimary),
//                       child: Text(
//                         "บันทึก",
//                         style: _styledefult.copyWith(
//                             color: white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Container(
//                       width: 100,
//                       height: 40,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: AppColor.kPrimary),
//                       child: Text(
//                         "เคลียร์",
//                         style: _styledefult.copyWith(
//                             color: white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Container(
//                       width: 100,
//                       height: 40,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: AppColor.kPrimary),
//                       child: Text(
//                         "ปิด",
//                         style: _styledefult.copyWith(
//                             color: white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   showAlertDialog(BuildContext context) {
//     AlertDialog alert = AlertDialog(
//       content: new Row(
//         children: [
//           CircularProgressIndicator(),
//           Container(
//               margin: EdgeInsets.only(left: 5),
//               child: Text("กำลังดำเนินการ...")),
//         ],
//       ),
//     );
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   Future<String?> getCamera() async {
//     _image = await _picker.pickImage(
//         source: ImageSource.camera, maxHeight: 400, maxWidth: 400);
//     print(">>>>>>>>>>>>>>>>>>>>>>>Image path ${_image?.path}");
//     // setState(() {});
//     return _image?.path;
//   }
// }
