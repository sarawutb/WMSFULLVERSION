import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms/models/model_upldate_po.dart';
import 'package:wms/themes/colors.dart';

class ListStatusUpdate extends StatefulWidget {
  const ListStatusUpdate({Key? key, required this.list}) : super(key: key);
  final List<ModelUpdatePo> list;
  @override
  _ListStatusUpdateState createState() => _ListStatusUpdateState();
}

class _ListStatusUpdateState extends State<ListStatusUpdate> {
  @override
  Widget build(BuildContext context) {
    final f_resive = new DateFormat('dd/M/yyyy เวลา H ชั่วโมง mm นาที', 'th');
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: black,
              fontSize: 10,
            );
    return Scaffold(
      appBar: AppBar(
        title: Text("เอกสารที่มีการแก้ไข"),
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
          ? ListView.separated(
              // cacheExtent: 20,
              primary: true,
              itemBuilder: (context, index) => ListTile(
                    title: Text(
                      "เลขที่เอกสาร : ${widget.list[index].docNo ?? ''}",
                      style: _textStyle,
                    ),
                    subtitle: Text(
                      "แก้ไขล่าสุด : ${f_resive.format(widget.list[index].lasteditDatetime!)}",
                      style: _textStyle,
                    ),
                  ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: widget.list.length)
          : Center(
              child: Text("ไม่พบรายการ"),
            ),
    );
  }
}
