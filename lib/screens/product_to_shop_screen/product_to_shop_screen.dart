// import 'package:flutter/material.dart';
// import 'package:wms/screens/product_to_shop_screen/widgets/appbar.dart';
// import 'package:wms/themes/colors.dart';

// import 'widgets/body.dart';

// class ProductToShopScreen extends StatefulWidget {
//   const ProductToShopScreen({Key? key}) : super(key: key);

//   @override
//   _ProductToShopScreenState createState() => _ProductToShopScreenState();
// }

// class _ProductToShopScreenState extends State<ProductToShopScreen> {
//   final textEditingControllerPickPo = TextEditingController();
//   final textEditingControllerRemark = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     textEditingControllerPickPo.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: appBar(context: context),
//       body: Body(
//         textEditingControllerPickPo: textEditingControllerPickPo,
//         textEditingControllerRemark: textEditingControllerRemark,
//         formKey: _formKey,
//       ),
//     );
//   }
// }
