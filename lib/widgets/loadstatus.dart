import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

class LoadStatus extends StatelessWidget {
  const LoadStatus({
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
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kmainPrimaryColor),
          ),
        ),
      ],
    );
  }
}
