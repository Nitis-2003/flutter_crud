import 'package:flutter/material.dart';
import 'package:flutter_crud/database/dbhelper.dart';
import 'package:flutter_crud/pages/home.dart';

void main() {
  init();
  runApp(const MyApp());
}

void init() async{
  await Dbhelper.instance.initDB();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DB CRUD',
      home: Home(),
    );
  }
}
