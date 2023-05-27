import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_to_text/hiveBox.dart';
import 'NotePage.dart';

final HiveBox hiveBox = HiveBox();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);
  await hiveBox.openBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      home: NotePage(index: (hiveBox.noteBox?.values.length ?? 0) - 1),
      theme: ThemeData(),
    );
  }
}
