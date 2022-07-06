import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_check_product.dart';
import 'package:wms/models/product_model.dart';
import 'package:wms/themes/app_color.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/loadstatussvg.dart';
import 'package:wms/widgets/sizedbox_height.dart';
import 'package:wms/widgets/text_form_search.dart';
import 'package:wms/widgets/willPopScope.dart';

var moneyFormat = NumberFormat("###.0#", "th_TH");

class CheckProductScreen extends StatelessWidget {
  const CheckProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
    });
    final TextEditingController _query = TextEditingController();
    final FocusNode _node = FocusNode();
    final ControllerCheckProduct _controllerCheckProduct =
        context.read<ControllerCheckProduct>();
    final _controller = ScrollController();

    return willPopScope(
        press: () {
          _controllerCheckProduct.fClearProductList();
          return Future.value(true);
        },
        child: Scaffold(
          body: Consumer<ControllerCheckProduct>(
            builder: (context, controllerCheckProduct, child) => SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColor.kPrimary,
                    child: TextFormFeildSearch(
                        textInputAction: TextInputAction.done,
                        icon: Icons.close,
                        node: _node,
                        context: context,
                        autoFocus: true,
                        colorfont: white,
                        hintText: "รหัสสินค้า ชื่อสินค้า และบาร์โค้ด",
                        press: () {
                          _query.clear();
                          Future.delayed(Duration(milliseconds: 300), () {
                            SystemChannels.textInput
                                .invokeListMethod('TextInput.hide');
                          });
                        },
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (string) {
                          _query.clear();
                          if (string.isNotEmpty) {
                            controllerCheckProduct.fSearch(
                                query: string,
                                context: context,
                                controller: _controller);
                          }
                          _node.requestFocus();
                          Future.delayed(Duration(milliseconds: 300), () {
                            SystemChannels.textInput
                                .invokeListMethod('TextInput.hide');
                          });
                        },
                        textEditingController: _query),
                  ),
                  if (controllerCheckProduct.getStatusPage) LoadStatusSvg(),
                  Expanded(
                    child: Container(
                      child: controllerCheckProduct.getlistProducts.length > 0
                          ? controllerCheckProduct.getlistProducts.length == 1
                              ? controllerCheckProduct.getDetailProduct == null
                                  ? NullData()
                                  : controllerCheckProduct.getDetailProduct!
                                              .price!.length ==
                                          0
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search,
                                                size: kdefultsize,
                                                color: black,
                                              ),
                                              Text(
                                                "ขออภัย!! ไม่พบข้อมูลสินค้า",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                            ],
                                          ),
                                        )
                                      : ContentProduct(
                                          controllerCheckProduct:
                                              controllerCheckProduct,
                                          controller: _controller,
                                        )
                              : Container(
                                  child: ListViewProducts(
                                    controllerCheckProduct:
                                        controllerCheckProduct,
                                  ),
                                )
                          : controllerCheckProduct.getlistProducts.length == 0
                              ? NullData()
                              : ListViewProducts(
                                  controllerCheckProduct:
                                      controllerCheckProduct,
                                ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ContentProduct extends StatelessWidget {
  const ContentProduct(
      {Key? key,
      required this.controllerCheckProduct,
      required this.controller})
      : super(key: key);

  final ControllerCheckProduct controllerCheckProduct;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: kdefultsize),
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            Container(
              color: AppColor.kPrimary,
              child: Column(
                children: [
                  // sizedBoxHeight(),
                  Text(
                    "${controllerCheckProduct.getDetailProduct!.itemCode}",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  // ! ราคา

                  Text(
                    "${controllerCheckProduct.getDetailProduct!.itemName}",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: white),
                    textAlign: TextAlign.center,
                  ),
                  ...List.generate(
                    controllerCheckProduct.getDetailProduct!.price == null
                        ? 0
                        : controllerCheckProduct
                            .getDetailProduct!.price!.length,
                    (index) => Text(
                      "ราคา ${moneyFormat.format(double.parse(controllerCheckProduct.getDetailProduct!.price![index].price!))} บาท / ${controllerCheckProduct.getDetailProduct!.price![index].unitCode}",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                  ),
                  // Text(
                  //   "ราคา ${moneyFormat.format(double.parse(controllerCheckProduct.getDetailProduct!.price![0].price!))} บาท",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline5!
                  //       .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  // ${moneyFormat.format(double.parse(controllerCheckProduct.getDetailProduct!.price![0].price!))} บาท/${controllerCheckProduct.getDetailProduct!.unitName}
                  // ),

                  sizedBoxHeight(),

                  if (controllerCheckProduct
                      .getDetailProduct!.price![0].priceMatch!)
                    Container(
                      alignment: Alignment.center,
                      color: Colors.green,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(
                            "ราคาตรงกับระบบ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                          ),
                          // Text(
                          //   "โปรดสแกน QR CODE ที่ป้ายเพื่อตรวจสอบ",
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyText2!
                          //       .copyWith(color: white, fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                    ),
                  if (!controllerCheckProduct
                      .getDetailProduct!.price![0].priceMatch!)
                    Container(
                      alignment: Alignment.center,
                      color: red,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Text(
                            "ราคาไม่ตรงกับระบบ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                          ),
                          Text(
                            "โปรดสแกน QR CODE ที่ป้ายเพื่อตรวจสอบ",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            sizedBoxHeight(),
            if (controllerCheckProduct.getDetailProduct!.barcodes!.isNotEmpty)
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: black),
                        ),
                        // color: red,
                        child: Text("หน่วยนับ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: black),
                        ),
                        // color: red,
                        child: Text("บาร์โค้ด",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: black),
                        ),
                        // color: red,
                        child: Text("อัตราส่วน",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            if (controllerCheckProduct.getDetailProduct!.barcodes!.isNotEmpty)
              ...List.generate(
                controllerCheckProduct.getDetailProduct!.barcodes!.length,
                (index) => SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            border: Border.all(color: black),
                          ),
                          // color: red,
                          child: Text(
                            controllerCheckProduct.getDetailProduct!
                                    .barcodes![index].unitName ??
                                '',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            border: Border.all(color: black),
                          ),
                          // color: red,
                          child: Text(
                              controllerCheckProduct.getDetailProduct!
                                      .barcodes![index].barcode ??
                                  '',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            border: Border.all(color: black),
                          ),
                          // color: red,
                          child: Text(
                              "1 : ${double.parse(controllerCheckProduct.getDetailProduct!.barcodes![index].ratio ?? '0').toStringAsFixed(0)}",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            sizedBoxHeight(),

            Table(
              border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                8: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                // TableRow(
                //   children: <Widget>[
                //     HeaderText(
                //       size: _size,
                //       title: "ราคาที่ป้าย",
                //     ),
                //     BodyText(
                //         controllerCheckProduct: controllerCheckProduct,
                //         text:
                //             "${controllerCheckProduct.getDetailProduct!.price![0].priceMatch! ? "ราคาตรงกับป้าย" : "โปรดแสกน QR Code ที่ป้ายราคาเพื่อตรวจสอบ"}"),
                //   ],
                // ),

                // TableRow(
                //   children: <Widget>[
                //     HeaderText(
                //       size: _size,
                //       title: "หน่วยนับ",
                //     ),
                //     BodyText(
                //         controllerCheckProduct: controllerCheckProduct,
                //         text:
                //             "${controllerCheckProduct.getDetailProduct!.unitName}"),
                //   ],
                // ),
                // TableRow(
                //   children: <Widget>[
                //     HeaderText(
                //       title: "อัตราส่วน",
                //       size: _size,
                //     ),
                //     BodyText(
                //         controllerCheckProduct: controllerCheckProduct,
                //         text: controllerCheckProduct
                //                     .getDetailProduct!.barcodes!.length ==
                //                 0
                //             ? "สินค้าไม่มีบาร์โค้ด"
                //             : "${controllerCheckProduct.getDetailProduct!.barcodes?[0].unitCode} / ${controllerCheckProduct.getDetailProduct!.unitName} อัตราส่วน 1:${double.parse(controllerCheckProduct.getDetailProduct!.barcodes![0].ratio!).toStringAsFixed(0)} บาร์โค๊ด :${controllerCheckProduct.getDetailProduct!.barcodes![0].barcode}"),
                //   ],
                // ),
                // ...List.generate(
                //   controllerCheckProduct.getDetailProduct!.barcodes == null
                //       ? 0
                //       : controllerCheckProduct
                //           .getDetailProduct!.barcodes!.length,
                //   (index) => TableRow(
                //     children: <Widget>[
                //       HeaderText(
                //         size: _size,
                //         title: "บาร์โค้ด",
                //       ),
                //       BodyText(
                //           controllerCheckProduct: controllerCheckProduct,
                //           text:
                //               "${controllerCheckProduct.getDetailProduct!.barcodes![index].barcode} / ${controllerCheckProduct.getDetailProduct!.barcodes![index].unitName}"),
                //     ],
                //   ),
                // ),

                // TableRow(
                //   children: <Widget>[
                //     HeaderText(
                //       size: _size,
                //       title: "ราคาปกติ",
                //     ),
                //     BodyText(
                //         controllerCheckProduct: controllerCheckProduct,
                //         text:
                //             "${moneyFormat.format(double.parse(controllerCheckProduct.getDetailProduct!.price![0].price!))} บาท/${controllerCheckProduct.getDetailProduct!.unitName}"),
                //   ],
                // ),

                TableRow(
                  children: <Widget>[
                    HeaderText(
                      size: _size,
                      title: "ราคามีผล",
                    ),
                    BodyText(
                        controllerCheckProduct: controllerCheckProduct,
                        text:
                            "${controllerCheckProduct.getDetailProduct!.price![0].dateBegin}"),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    HeaderText(
                      size: _size,
                      title: "ราคาสิ้นสุด",
                    ),
                    BodyText(
                        controllerCheckProduct: controllerCheckProduct,
                        text:
                            "${controllerCheckProduct.getDetailProduct!.price![0].dateEnd}"),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    HeaderText(
                      size: _size,
                      title: "วันที่อัพเดทราคา",
                    ),
                    BodyText(
                        controllerCheckProduct: controllerCheckProduct,
                        text:
                            "${controllerCheckProduct.getDetailProduct!.price![0].updateDate}"),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    HeaderText(
                      size: _size,
                      title: "สถานะบ่งชี้(มิติ8)",
                    ),
                    BodyText(
                        controllerCheckProduct: controllerCheckProduct,
                        text:
                            "${controllerCheckProduct.getDetailProduct!.dim12 ?? "-"}"),
                  ],
                ),
                // TableRow(
                //   children: <Widget>[
                //     HeaderText(
                //       size: _size,
                //       title: "MIN",
                //     ),
                //     BodyText(
                //         controllerCheckProduct: controllerCheckProduct,
                //         text:
                //             "${controllerCheckProduct.getDetailProduct!.maxStk ?? "-"}"),
                //   ],
                // ),
                // TableRow(
                //   children: <Widget>[
                //     HeaderText(
                //       size: _size,
                //       title: "MAX",
                //     ),
                //     BodyText(
                //         controllerCheckProduct: controllerCheckProduct,
                //         text:
                //             "${controllerCheckProduct.getDetailProduct!.minStk ?? "-"}"),
                //   ],
                // ),
                // TableRow(
                //   children: <Widget>[
                //     HeaderText(
                //       size: _size,
                //       title: "สถานะสี",
                //     ),
                //     BodyText(
                //         controllerCheckProduct: controllerCheckProduct,
                //         text:
                //             "${controllerCheckProduct.getDetailProduct!.minStk ?? "-"}"),
                //   ],
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusColors(
                  nameProduct: controllerCheckProduct
                              .getDetailProduct!.colorStatus ==
                          "LG"
                      ? "สินค้าขายดี 80/20 ห้ามขาดสต๊อก (กำหนด MAX-MIN)"
                      : controllerCheckProduct.getDetailProduct!.colorStatus ==
                              "DG"
                          ? "สินค้าขายปกติ"
                          : controllerCheckProduct
                                      .getDetailProduct!.colorStatus ==
                                  "OR"
                              ? "มีตัวโชว์ ไม่มีสต๊อก (วาง Schematic)"
                              : controllerCheckProduct
                                          .getDetailProduct!.colorStatus ==
                                      "RD"
                                  ? "ไม่มีตัวโชว์ สั่งจาก Catalog"
                                  : controllerCheckProduct
                                              .getDetailProduct!.colorStatus ==
                                          "PP"
                                      ? "ยกเลิก ไม่มีสต๊อก"
                                      : "ไม่พบข้อมูล",
                  icon: Icons.circle,
                  color: controllerCheckProduct.getDetailProduct!.colorStatus ==
                          "LG"
                      ? Color(0xFF90ee90)
                      : controllerCheckProduct.getDetailProduct!.colorStatus ==
                              "DG"
                          ? Color(0xFF006400)
                          : controllerCheckProduct
                                      .getDetailProduct!.colorStatus ==
                                  "OR"
                              ? Color(0xFFffa500)
                              : controllerCheckProduct
                                          .getDetailProduct!.colorStatus ==
                                      "RD"
                                  ? Color(0xFFff0000)
                                  : controllerCheckProduct
                                              .getDetailProduct!.colorStatus ==
                                          "PP"
                                      ? Color(0xFF800080)
                                      : Colors.black,
                  maxText: "สถานะสี",
                ),
              ],
            ),

            TableDataWidget(
                title:
                    "MIN :${controllerCheckProduct.getDetailProduct!.minStk}",
                sizefont: 12,
                size: false,
                subtitle:
                    "MAX :${controllerCheckProduct.getDetailProduct!.maxStk}"),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: TableDataStockWidget(
                  size: true,
                  color: true,
                  sizefont: 8,
                  title: "สาขา",
                  title2: "พื้นที่เก็บ",
                  title3: "คงเหลือ",
                  title4: "ค้างส่ง",
                  title5: "ขายได้"),
            ),
            ...List.generate(
                controllerCheckProduct.getDetailProduct!.stock!.length,
                (index) {
              return TableDataStockWidget(
                  size: true,
                  color: true,
                  sizefont: 10,
                  title:
                      "${controllerCheckProduct.getDetailProduct!.stock?[index].branchCode ?? ""}",
                  title2:
                      "${controllerCheckProduct.getDetailProduct!.stock?[index].locationCode ?? ""}",
                  title3:
                      "${controllerCheckProduct.getDetailProduct!.stock?[index].balanceQty ?? ""}",
                  title4:
                      "${controllerCheckProduct.getDetailProduct!.stock?[index].reservedQty ?? ""}",
                  title5:
                      "${controllerCheckProduct.getDetailProduct!.stock?[index].availableQty ?? ""}");
            }),
            // Container(
            //   height: _size.height *
            //       (0.047 *
            //           controllerCheckProduct.getDetailProduct!.stock!.length),
            //   width: _size.width,
            //   child: ListView.builder(
            //     itemCount:
            //         controllerCheckProduct.getDetailProduct!.stock!.length,
            //     itemBuilder: (context, index) {
            //       return TableDataStockWidget(
            //           sizefont: 8,
            //           title:
            //               "${controllerCheckProduct.getDetailProduct!.stock?[index].branchCode ?? ""}",
            //           title2:
            //               "${controllerCheckProduct.getDetailProduct!.stock?[index].locationCode ?? ""}",
            //           title3:
            //               "${controllerCheckProduct.getDetailProduct!.stock?[index].balanceQty ?? ""}",
            //           title4:
            //               "${controllerCheckProduct.getDetailProduct!.stock?[index].reservedQty ?? ""}",
            //           title5:
            //               "${controllerCheckProduct.getDetailProduct!.stock?[index].availableQty ?? ""}");
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 2),
            //   child: TableDataWidget(
            //     // title: "ลำดับที่",
            //     subtitle: "ตำแหน่งสินค้า",
            //     sizefont: 15,
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ตำแหน่งสินค้า",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            ...List.generate(
              controllerCheckProduct.getDetailProduct!.location!.length,
              (index) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      color: white,
                      child: Text(
                        "${controllerCheckProduct.getDetailProduct!.location![index]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // TableDataWidget(
              //           // title: "${index + 1}",
              //           subtitle:
              //               "${controllerCheckProduct.getDetailProduct!.location![index]}",
              //         )
            ),
            // Container(
            //   height: _size.height *
            //       (0.047 *
            //           controllerCheckProduct
            //               .getDetailProduct!.location!.length),
            //   width: _size.width,
            //   child: ListView.builder(
            //     itemCount:
            //         controllerCheckProduct.getDetailProduct!.location!.length,
            //     itemBuilder: (context, index) {
            //       return TableDataWidget(
            //         title: "${index + 1}",
            //         subtitle:
            //             "${controllerCheckProduct.getDetailProduct!.location![index]}",
            //       );
            //     },
            //   ),
            // ),
            SizedBox(
              height: _size.height * 0.05,
            )
          ],
        ),
      ),
    );
  }
}

class TableDataWidget extends StatelessWidget {
  const TableDataWidget({
    Key? key,
    this.title,
    required this.subtitle,
    this.sizefont,
    this.sizefonttitle,
    this.size,
    this.color,
  }) : super(key: key);
  final String? title;
  final String subtitle;
  final double? sizefont;
  final double? sizefonttitle;
  final bool? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      columnWidths: <int, TableColumnWidth>{
        0: size ?? true ? FixedColumnWidth(90) : FlexColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            if (title != null)
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  alignment:
                      size ?? false ? Alignment.center : Alignment.centerLeft,
                  // height: 32,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.only(left: kdefultsize - 10),
                    child: Text(
                      "$title ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: sizefonttitle ?? kdefultsize - 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                alignment: Alignment.center,
                // height: 32,
                width: double.infinity,
                // width: 32,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: kdefultsize - 10),
                  child: Text(
                    "$subtitle",
                    style: TextStyle(
                        color: color ?? Colors.black87,
                        fontSize: sizefont ?? kdefultsize - 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class TableDataStockWidget extends StatelessWidget {
  const TableDataStockWidget({
    Key? key,
    required this.title,
    this.sizefont,
    this.size,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.title5,
    this.color,
  }) : super(key: key);
  final String title;
  final String title2;
  final String title3;
  final String title4;
  final String title5;
  final double? sizefont;
  final bool? size;
  final bool? color;
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      columnWidths: <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                alignment:
                    size ?? false ? Alignment.center : Alignment.centerLeft,
                height: 32,
                width: 32,
                color: color ?? false ? Colors.white : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(left: kdefultsize - 10),
                  child: Text(
                    "$title ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: sizefont ?? kdefultsize - 5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                alignment:
                    size ?? false ? Alignment.center : Alignment.centerLeft,
                height: 32,
                width: 32,
                color: color ?? false ? Colors.white : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(left: kdefultsize - 10),
                  child: Text(
                    "$title2 ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: sizefont ?? kdefultsize - 5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                alignment:
                    size ?? false ? Alignment.center : Alignment.centerLeft,
                height: 32,
                width: 32,
                color: color ?? false ? Colors.white : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(left: kdefultsize - 10),
                  child: Text(
                    "$title3 ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: sizefont ?? kdefultsize - 5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                alignment:
                    size ?? false ? Alignment.center : Alignment.centerLeft,
                height: 32,
                width: 32,
                color: color ?? false ? Colors.white : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(left: kdefultsize - 10),
                  child: Text(
                    "$title4 ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: sizefont ?? kdefultsize - 5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                alignment:
                    size ?? false ? Alignment.center : Alignment.centerLeft,
                height: 32,
                width: 32,
                color: color ?? false ? Colors.white : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(left: kdefultsize - 10),
                  child: Text(
                    "$title5 ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: sizefont ?? kdefultsize - 5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TableDataWidgetOne extends StatelessWidget {
  const TableDataWidgetOne({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 32,
                width: 32,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: kdefultsize - 10),
                  child: Text(
                    "$title ",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: kdefultsize - 5,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class TableWidgetText extends StatelessWidget {
  const TableWidgetText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Container(
              height: 32,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ],
    );
  }
}

class BodyText extends StatelessWidget {
  const BodyText({
    Key? key,
    required this.controllerCheckProduct,
    required this.text,
  }) : super(key: key);

  final ControllerCheckProduct controllerCheckProduct;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kdefultsize,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: kdefultsize - 15),
      child: Text(
        "$text",
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.title,
    required this.size,
    this.widthsize,
  }) : super(key: key);
  final String title;
  final Size size;
  final double? widthsize;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: kdefultsize - 15),
      alignment: Alignment.centerLeft,
      height: kdefultsize,
      width: widthsize ?? size.width * 0.3,
      child: Text(
        "$title",
        style: TextStyle(
            color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NullData extends StatelessWidget {
  const NullData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: kdefultsize,
            color: black,
          ),
          Text(
            "ค้นหาสินค้า",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}

class ListViewProducts extends StatelessWidget {
  const ListViewProducts({
    Key? key,
    required this.controllerCheckProduct,
  }) : super(key: key);

  final ControllerCheckProduct controllerCheckProduct;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          List<Product> _list = controllerCheckProduct.getlistProducts;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kdefultsize),
            child: ListTile(
              onTap: () => controllerCheckProduct.fRemoveAll(
                  index: index, product: _list[index], context: context),
              minLeadingWidth: kdefultsize - 10,
              isThreeLine: true,
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      "${_list[index].itemname ?? "ไม่พบชื่อ"}",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${_list[index].itemcode}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Spacer(),
                      Text(
                        "${_list[index].unitStandardName}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.qr_code_2, color: red),
                      Text(
                        " ${_list[index].barcode ?? "ไม่มีบาร์โค้ด"}",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Spacer(),
                      Text(
                        "${_list[index].unitStandard}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
              leading: Icon(Icons.search, color: black, size: kdefultsize + 10),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: kdefultsize),
              child: const Divider(),
            ),
        itemCount: controllerCheckProduct.getlistProducts.length);
  }
}

class StatusColors extends StatelessWidget {
  final String? nameProduct;
  final IconData? icon;
  final String? maxText;
  final Color? color;
  const StatusColors({
    Key? key,
    this.nameProduct,
    this.icon,
    this.maxText,
    this.color,
  }) : super(key: key);

  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 11,
        ),
        Row(
          children: [
            Icon(
              icon,
              color: color,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "${nameProduct!}",
                style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${maxText == null ? "" : maxText}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
