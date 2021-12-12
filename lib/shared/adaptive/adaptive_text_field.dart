import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/shared/styles/colors.dart';

class AdaptiveTextField extends StatelessWidget {
  String os;
  TextEditingController controller;
  TextInputAction? textInputAction;
  TextInputType type;
  String label;
  bool isPassword;
  IconData? prefix;
  IconData? suffix;
  var suffixPressed;
  var onTap;
  InputBorder inputBorder;
  InputBorder? enabledBorder;
  InputBorder? focusedBorder;
  BoxDecoration? boxDecoration;

  var onSubmit;
  var onChange;
  var validate;
  /*bool isClickable = true;*/

  AdaptiveTextField({
    Key? key,
    required this.os,
    required this.label,
    required this.controller,
     this.onTap,
     this.type = TextInputType.text,
    this.isPassword = false,
    this.prefix,
    this.suffix,
    this.suffixPressed,
    this.onChange,
    this.onSubmit,
    this.validate,
    this.textInputAction,
    this.inputBorder = const OutlineInputBorder(),
    this.enabledBorder,
    this.focusedBorder,
    this.boxDecoration ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (os == 'android') {
      return TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        //enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        textInputAction: textInputAction,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefix != null ? Icon(prefix) : null,
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(
                    suffix,
                  ),
                )
              : null,
          border: inputBorder,
          enabledBorder:enabledBorder,
          focusedBorder:focusedBorder,
        ),
      );
    }

    return CupertinoTextFormFieldRow(

      controller: controller,
      validator: validate,
      prefix: prefix != null ? Icon(prefix,color: defaultColor,) : null,
    /*  suffix:suffix != null ? IconButton(
        onPressed: suffixPressed,
        icon: Icon(
          suffix,
        ),
      ): null,*/

    onTap: onTap,
      keyboardType: type,
      obscureText: isPassword,
      placeholder: label,
      onChanged: onChange,
     // onSubmitted: onSubmit,
      textInputAction: textInputAction,
      decoration:  boxDecoration,
      );
  }
}
