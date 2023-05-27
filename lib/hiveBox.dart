import 'package:hive_flutter/hive_flutter.dart';
import 'package:voice_to_text/Note.dart';

class HiveBox {
  static const String noteBoxName = "notedata";
  Box<Note>? noteBox;

  Future<void> openBox() async {
    Hive.registerAdapter<Note>(NoteAdapter());
    noteBox = await Hive.openBox<Note>(noteBoxName);
  }
}
