import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_demo/models/contact.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'contact_page.dart';

void main() async {
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path); // 1. 呼ぶ
  Hive.registerAdapter(ContactAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Tutorial',
      home: FutureBuilder(
        future: Hive.openBox(
          'contacts',
          compactionStrategy: (int total, int deleted) {
            return deleted > 20; // 圧縮する条件
          },
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const ContactPage();
            }
          } else {
            return const Scaffold();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.box('contacts').compact(); // 圧縮
    Hive.close();
    super.dispose();
  }
}
