import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  AdaptativeTextField({this.label, this.controller, TextInputType keyboardType}) : 
    this.keyboardType = keyboardType ?? TextInputType.text;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: CupertinoTextField(
              placeholder: label,
              controller: controller,
              keyboardType: keyboardType,
              padding: EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 12.0
              ),
            ),
        )
        : TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          );
  }
}
