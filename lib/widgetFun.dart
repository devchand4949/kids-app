import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'package:flutter/cupertino.dart';


Widget Buttonfunpass(fun,iconbutton,color){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10),
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50))),
      onPressed: fun,//argument type function
      child: Icon(
        iconbutton,//argument type function
        size: 50,
      ));
}