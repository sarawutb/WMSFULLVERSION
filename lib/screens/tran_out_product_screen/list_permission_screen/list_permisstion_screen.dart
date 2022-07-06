import 'package:flutter/material.dart';
import 'package:wms/models/check_permission_model.dart';
import 'package:wms/themes/colors.dart';

class ListPerMisstionScreen extends StatefulWidget {
  const ListPerMisstionScreen({Key? key, required this.list}) : super(key: key);
  final List<CheckPermissions> list;

  @override
  _ListPerMisstionScreenState createState() => _ListPerMisstionScreenState();
}

class _ListPerMisstionScreenState extends State<ListPerMisstionScreen> {
  @override
  Widget build(BuildContext context) {
    // final f_resive = new DateFormat('dd/M/yyyy เวลา H ชั่วโมง mm นาที', 'th');
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: black,
              fontSize: 10,
            );
    return Scaffold(
      appBar: AppBar(
        title: Text("เช็คสิทธิ์คลัง/ที่เก็บ"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.list.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      widget.list.length,
                      (index) => Container(
                            alignment: Alignment.centerLeft,
                            height: 40,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.only(left: 10),
                            color: index.isEven
                                ? Colors.blue.shade50
                                : Colors.white,
                            child: Text(
                              "${widget.list[index].whCode ?? ''} ~ ${widget.list[index].shelfCode ?? ''}",
                              style: _textStyle,
                            ),
                          ))
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
