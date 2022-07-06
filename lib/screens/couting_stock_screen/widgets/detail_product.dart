import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_couting_scock_scrren.dart';
import 'package:wms/themes/colors.dart';

class DetailProduct extends StatelessWidget {
  const DetailProduct({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<ControllerCountingStockScreen>(
      builder: (context, streamdata, child) => Container(
        margin: EdgeInsets.symmetric(horizontal: kdefultsize - 10),
        width: size.width,
        height: size.height * 0.3,
        decoration: kBoxDecorationStyle,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "รหัสสินค้า : ${streamdata.getproductsCountStock.itemCode ?? ""}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                "ชื่อสินค้า : ${streamdata.getproductsCountStock.itemName ?? ""}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "หน่วยที่ต้องนับ : ${streamdata.getproductsCountStock.unitStandard ?? ""}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "หน่วยนับ : ${streamdata.getproductsCountStock.unitStandardName ?? ""}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: red),
                  ),
                  Text(
                    "รอบการนับ : ${streamdata.getproductsCountStock.currentCountStepDesc ?? ""}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.green),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
