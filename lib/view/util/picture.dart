import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PicturePage extends StatefulWidget {
  PicturePage({super.key});

  File image = File("");

  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {

  Future pickImageGalery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        widget.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        widget.image = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future deletePicture() async {
    print("Delete Picture");
    await widget.image.delete();
    print("Deleted Picture");
    setState(() {
      widget.image = File("");
    });
  }

  void _onButtonPressed(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton.extended(
                  label: const Text('Camera'), // <-- Text
                  backgroundColor: Colors.blueAccent,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    size: 24.0,
                  ),
                  onPressed: () async{
                    Navigator.of(context).pop();
                    await pickImageCamera();
                  },
                ),
                FloatingActionButton.extended(
                  label: const Text('Galerie'), // <-- Text
                  backgroundColor: Colors.blueAccent,
                  icon: const Icon(
                    Icons.photo,
                    size: 24.0,
                  ),
                  onPressed: () async{
                    Navigator.of(context).pop();
                    await pickImageGalery();
                  },
                ),
              ],
            ),
          );
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    ///TODO: Implement Image Cropper
    return showPicture();
  }

  Widget showPicture(){
    if(widget.image.existsSync()){
      return Column(
        children: <Widget>[
          Image.file(widget.image),
          MaterialButton(
            color: Colors.blue,
            child: const Text("Delete Picture",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await deletePicture();
            },
          ),
        ],
      );
    }else{
      return Column(
        children: [
          TextButton.icon(
            onPressed: () {
              _onButtonPressed();
            },
            icon: const Icon(
              Icons.camera_alt_outlined,
            ),
            label: const Text("Bild"),
          ),
        ],
      );
    }
  }
}
