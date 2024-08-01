import 'package:auto_complete_location/views/home_screen.dart';
import 'package:auto_complete_location/views/auto_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
       GetMaterialApp(
        debugShowCheckedModeBanner: false,
          home: AutoComplete(),
      ),
    );
  }
}