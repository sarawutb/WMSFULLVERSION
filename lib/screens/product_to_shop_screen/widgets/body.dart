import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wms/screens/product_to_shop_screen/widgets/checkbox.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/dialogbox.dart';
import 'package:wms/widgets/loadstatus.dart';
import 'package:wms/widgets/serchbar.dart';
import 'package:wms/widgets/sizedbox_height.dart';
import 'package:wms/widgets/text_form_search.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_product_to_shop_screen.dart';
import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
DateTime now = DateTime.now();

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.textEditingControllerPickPo,
    required this.formKey,
    required this.textEditingControllerRemark,
  }) : super(key: key);
  final TextEditingController textEditingControllerPickPo;
  final TextEditingController textEditingControllerRemark;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
    });
    // var maskFormatter = new MaskTextInputFormatter(mask: 'X##-POV####-#####');

    return Consumer<ControllerProductToShopScreen>(
      builder: (_, controllerProductToShopScreen, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchBar(
                iconSize: 0,
                title: "สแกน/ค้นหา  ใบสั่งซื้อ (Po)",
                contentPadding: 10,
                style: Theme.of(context).textTheme.bodyText2,
                onSubmitted: (string) => string.isNotEmpty
                    ? controllerProductToShopScreen.getCancelPo
                        ? dialogBoxCancel(
                            press: () => controllerProductToShopScreen.cancel(
                              reason: textEditingControllerRemark.text,
                              query: string,
                              context: context,
                              scan: "0",
                              formKey: formKey,
                            ),
                            formKey: formKey,
                            context: context,
                            title: "แจ้งเตือนจากระบบ",
                            subtitle:
                                "ต้องการขอยกเลิกการบันทึก\nวันที่สินค้าถึงร้าน\nณ วันที่${dateFormat.format(now)}",
                            widget: Padding(
                              padding: const EdgeInsets.all(kdefultsize),
                              child: Container(
                                decoration: kBoxDecorationStyle,
                                child: WidgetCancelPo(
                                  textEditingControllerRemark:
                                      textEditingControllerRemark,
                                  formKey: formKey,
                                ),
                              ),
                            ),
                          )
                        : controllerProductToShopScreen.mNoRecive(
                            query: string, context: context, scan: "0")
                    : null,
                controller: textEditingControllerPickPo,
              ),
            ),
          ),
          // TextFormFeildSearch(
          //     context: context,
          //     // textInputFormatter: maskFormatter,
          //     autoFocus: true,
          //     hintText: "สแกน/ค้นหา  ใบสั่งซื้อ (Po)",
          //     icon: Icons.no_accounts,
          //     press: () => textEditingControllerPickPo.text.isNotEmpty
          //         ? controllerProductToShopScreen.getCancelPo
          //             ? dialogBoxCancel(
          //                 press: () => controllerProductToShopScreen.cancel(
          //                   reason: textEditingControllerRemark.text,
          //                   query: textEditingControllerPickPo.text,
          //                   context: context,
          //                   scan: "1",
          //                   formKey: formKey,
          //                 ),
          //                 formKey: formKey,
          //                 context: context,
          //                 title: "แจ้งเตือนจากระบบ",
          //                 subtitle:
          //                     "ต้องการขอยกเลิกการบันทึก\nวันที่สินค้าถึงร้าน\nณ วันที่${dateFormat.format(now)}",
          //                 widget: Padding(
          //                   padding: const EdgeInsets.all(kdefultsize),
          //                   child: Container(
          //                     decoration: kBoxDecorationStyle,
          //                     child: WidgetCancelPo(
          //                       textEditingControllerRemark:
          //                           textEditingControllerRemark,
          //                       formKey: formKey,
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             : controllerProductToShopScreen.mNoRecive(
          //                 query: textEditingControllerPickPo.text,
          //                 context: context,
          //                 scan: "1")
          //         : null,
          //     keyboardType: TextInputType.text,
          //     onFieldSubmitted: (string) => string.isNotEmpty
          //         ? controllerProductToShopScreen.getCancelPo
          //             ? dialogBoxCancel(
          //                 press: () => controllerProductToShopScreen.cancel(
          //                   reason: textEditingControllerRemark.text,
          //                   query: string,
          //                   context: context,
          //                   scan: "0",
          //                   formKey: formKey,
          //                 ),
          //                 formKey: formKey,
          //                 context: context,
          //                 title: "แจ้งเตือนจากระบบ",
          //                 subtitle:
          //                     "ต้องการขอยกเลิกการบันทึก\nวันที่สินค้าถึงร้าน\nณ วันที่${dateFormat.format(now)}",
          //                 widget: Padding(
          //                   padding: const EdgeInsets.all(kdefultsize),
          //                   child: Container(
          //                     decoration: kBoxDecorationStyle,
          //                     child: WidgetCancelPo(
          //                       textEditingControllerRemark:
          //                           textEditingControllerRemark,
          //                       formKey: formKey,
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             : controllerProductToShopScreen.mNoRecive(
          //                 query: string, context: context, scan: "0")
          //         : null,
          //     textEditingController: textEditingControllerPickPo),

          checkBoxMethod(context, controllerProductToShopScreen),
          sizedBoxHeight(),
          if (controllerProductToShopScreen.getStatusPage) LoadStatus(),
        ],
      ),
    );
  }
}

class WidgetCancelPo extends StatelessWidget {
  const WidgetCancelPo({
    Key? key,
    required this.formKey,
    required this.textEditingControllerRemark,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final TextEditingController textEditingControllerRemark;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: textEditingControllerRemark,
        validator: (value) => value!.isEmpty ? "กรุณากรอกหมายเหตุ" : null,
        minLines: 3,
        maxLength: 200,
        keyboardType: TextInputType.multiline,
        cursorColor: kmainPrimaryColor,
        textInputAction: TextInputAction.newline,
        autofocus: false,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: "หมายเหตุ",
          contentPadding: EdgeInsets.symmetric(
            horizontal: kdefultsize - 10,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
