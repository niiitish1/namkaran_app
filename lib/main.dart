import 'package:flutter/material.dart';
import 'package:namkaran_app/const/my_string.dart';
import 'package:namkaran_app/screens/select_gender.dart';

void main() {
  runApp(MaterialApp(
    title: MyString().appName,
    debugShowCheckedModeBanner: false,
    home: SelectGender(),
  ));
}
