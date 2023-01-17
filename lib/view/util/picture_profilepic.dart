import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/registration.dart';

class PictureProfilePic extends StatefulWidget {
  PictureProfilePic({super.key});

  File image = File("");

  @override
  PicturePageState createState() => PicturePageState();
}

class PicturePageState extends State<PictureProfilePic> {
  static Registration registration = Registration();

  static final GlobalKey genKey = GlobalKey();

  static Future<void> takePicture() async {
    RenderRepaintBoundary boundary =
        genKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = File('$directory/photo.png');
    await imgFile.writeAsBytes(pngBytes);
    registration.file = imgFile;
    print(imgFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return profilePic();
  }

  Widget profilePic() {
    if (registration.usernameController.text.isEmpty ||
        registration.usernameController.text == "") {
      return SizedBox(
        height: 200,
        width: 200,
        child: TextButton.icon(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {});
          },
          label: const Text("Reload"),
        ),
      );
    } else {
      return RepaintBoundary(
        key: genKey,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xff358bde),
          ),
          height: 200,
          width: 200,
          child: Center(
            child: Text(
              registration.usernameController.text.substring(0, 1),
              style: const TextStyle(
                fontSize: 100,
                color: Color(0xffe8dfdf),
              ),
            ),
          ),
        ),
      );
    }
  }
}
