import 'package:flutter/material.dart';
import 'package:voice_to_text/NotePage.dart';
import 'Note.dart';
import 'main.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<StatefulWidget> createState() => NoteListState();
}

class NoteListState extends State<NoteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotePage(index: -1)));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: hiveBox.noteBox?.values.length ?? 0,
          itemBuilder: (context, index) {
            Note note = hiveBox.noteBox!.getAt(index)!;
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotePage(index: index)));
              },
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      note.title ?? "",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      note.message ?? "",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      note.createdAt.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      note.updatedAt.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
