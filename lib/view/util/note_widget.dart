import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
class NoteWidget extends StatefulWidget{

  final String name;

  const NoteWidget({super.key, required this.name});

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: const Color(0x57e36f6f),
      ),
      child: Column(
        children: <Widget>[
          Text(
            widget.name,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}