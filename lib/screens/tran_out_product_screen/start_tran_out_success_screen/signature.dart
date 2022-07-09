import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:wms/models/page_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wms/themes/colors.dart';

class SignTure extends StatefulWidget {
  const SignTure({Key? key, required this.detail}) : super(key: key);
  final List<Detail> detail;
  @override
  _SignTureState createState() => _SignTureState();
}

class _SignTureState extends State<SignTure> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
  }

  getCamera() async {
    _image = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 400, maxWidth: 400);
    setState(() {});
  }

  getGallery() async {
    _image = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: blue,
        title: Text(
          "ยืนยันการจ่ายสินค้าเลขที่",
          style: TextStyle(color: white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ...List.generate(
              widget.detail.length,
              (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.detail[index].docNo ?? ''),
                      Text(widget.detail[index].shelfCode ?? ''),
                    ],
                  )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("แนบรูปภาพการจ่ายสินค้า"),
                    IconButton(
                        onPressed: () => getCamera(),
                        icon: Icon(Icons.camera_alt)),
                    IconButton(
                        onPressed: () => getGallery(), icon: Icon(Icons.image)),
                  ],
                ),
                if (_image != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                              "รูปภาพ : ${_image!.name.length > 30 ? _image!.name.substring(0, 20) : _image!.name}.byte"),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),

          Spacer(),
          //SIGNATURE CANVAS
          Text(
            "ลายเซ็นผู้รับสินค้า",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.black),
            child: Signature(
              controller: _controller,
              height: 300,
              backgroundColor: Colors.white,
            ),
          ),
          //OK AND CLEAR BUTTONS
          Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //SHOW EXPORTED IMAGE IN NEW ROUTE
                IconButton(
                  icon: const Icon(Icons.check),
                  color: Colors.blue,
                  onPressed: () async {
                    if (_controller.isNotEmpty) {
                      final Uint8List? data = await _controller.toPngBytes();
                      if (data != null) {
                        print(data);
                        // await Navigator.of(context).push(
                        //   MaterialPageRoute<void>(
                        //     builder: (BuildContext context) {
                        //       return Scaffold(
                        //         appBar: AppBar(),
                        //         body: Center(
                        //           child: Container(
                        //             color: Colors.grey[300],
                        //             child: Image.memory(data),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // );
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.undo());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.redo());
                  },
                ),
                //CLEAR CANVAS
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                ),
              ],
            ),
          ),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // ! บันทึกลายเซนต์
                    Navigator.pop(context, 'OK');
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: blue),
                    child: Text(
                      "ยืนยันจ่ายสินค้า",
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
