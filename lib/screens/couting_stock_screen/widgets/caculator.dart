import 'package:flutter/material.dart';
// import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_couting_scock_scrren.dart';
import 'package:wms/themes/colors.dart';

class CalcButton extends StatefulWidget {
  @override
  _CalcButtonState createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  @override
  Widget build(BuildContext context) {
    final ControllerCountingStockScreen _controllerCountingStockScreen =
        context.read<ControllerCountingStockScreen>();
    // var calc = SimpleCalculator(
    //   value: _controllerCountingStockScreen.getcurrentValue,
    //   hideExpression: false,
    //   hideSurroundingBorder: true,
    //   onChanged: (key, value, expression) {
    //     _controllerCountingStockScreen.updatecurrentValue(number: value ?? 0);
    //     print("$key\t$value\t$expression");
    //   },
    //   onTappedDisplay: (value, details) {
    //     print("$value\t${details.globalPosition}");
    //   },
    //   theme: const CalculatorThemeData(
    //     borderColor: Colors.black,
    //     borderWidth: 2,
    //     displayColor: Colors.black,
    //     displayStyle: const TextStyle(fontSize: 80, color: Colors.yellow),
    //     expressionColor: Colors.indigo,
    //     expressionStyle: const TextStyle(fontSize: 20, color: Colors.white),
    //     operatorColor: Colors.pink,
    //     operatorStyle: const TextStyle(fontSize: 30, color: Colors.white),
    //     commandColor: Colors.orange,
    //     commandStyle: const TextStyle(fontSize: 30, color: Colors.white),
    //     numColor: Colors.grey,
    //     numStyle: const TextStyle(fontSize: 50, color: Colors.white),
    //   ),
    // );

    return Padding(
        padding: EdgeInsets.all(kdefultsize - 10),
        child: SizedBox(
          width: double.infinity,
          child: Consumer<ControllerCountingStockScreen>(
            builder: (context, controllerCountingStockScreen, child) =>
                Container(
              decoration: kBoxDecorationStyle,
              child: TextButton(
                child: Text(
                  controllerCountingStockScreen.getcurrentValue.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: black),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  // showModalBottomSheet(
                  //     isScrollControlled: true,
                  //     isDismissible: true,
                  //     enableDrag: true,
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return SizedBox(
                  //           height: MediaQuery.of(context).size.height * 0.75,
                  //           child: calc);
                  //     });
                },
              ),
            ),
          ),
        ));
  }
}
