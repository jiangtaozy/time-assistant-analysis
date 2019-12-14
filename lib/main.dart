/*
 * Maintained by jemo from 2019.12.13 to now
 * Created by jemo on 2019.12.13 16:58:49
 * Main
 */

import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '时间助手',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
