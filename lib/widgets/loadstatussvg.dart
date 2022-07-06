import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

class LoadStatusSvg extends StatelessWidget {
  const LoadStatusSvg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: kdefultsize + 10,
          width: kdefultsize + 10,
          child: Image.asset("assets/icons/loading.gif"),
        ),
      ],
    );
  }
}
