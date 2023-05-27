import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_to_text/NoteListPage.dart';
import 'Note.dart';
import 'main.dart';

class NotePage extends StatefulWidget {
  final int? index;
  const NotePage({Key? key, this.index}) : super(key: key);
  @override
  State<StatefulWidget> createState() => NotePageState();
}

class NotePageState extends State<NotePage> {
  Note note = Note();
  final SpeechToText _speechToText = SpeechToText();

  final FocusNode _titleFocusNode = CustomFocusNode();
  final FocusNode _messageFocusNode = CustomFocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String _lastWords = "";

  @override
  void initState() {
    _initSpeech();
    print(widget.index);
    widget.index != null && widget.index != -1 ? _initValue() : null;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  void _initSpeech() async {
    await _speechToText.initialize(onStatus:(String status){
      setState(() {});
    });
  }


  _initValue() {
    note = hiveBox.noteBox!.getAt(widget.index!)!;
    titleController.text = note.title ?? "";
    messageController.text = note.message ?? "";
  }

  saveNote() async {
    try {
      note.title = titleController.text;
      note.message = messageController.text;
      note.updatedAt = note.createdAt == null ? null : DateTime.now();
      note.createdAt = note.createdAt ?? DateTime.now();
      (widget.index ?? -1) == -1
          ? await hiveBox.noteBox?.add(note)
          : await hiveBox.noteBox?.putAt(widget.index!, note);
    } catch (onError) {
      print(onError);
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        partialResults: true,
        pauseFor: const Duration(minutes: 10),
        listenMode: ListenMode.dictation);
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }
  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (_messageFocusNode.hasFocus) {
        messageController.text = "${messageController.text} $_lastWords";
        messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: messageController.text.length));
      } else if (_titleFocusNode.hasFocus) {
        titleController.text = "${titleController.text} $_lastWords";
        titleController.selection = TextSelection.fromPosition(
            TextPosition(offset: titleController.text.length));
      }
      _lastWords = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoteListPage()));
          },
          icon: const Icon(Icons.chevron_left),
        ),
        actions: [
          IconButton(
              onPressed: () {
                saveNote();
              },
              icon: const Icon(Icons.save_alt_sharp)),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
          child: Icon(_speechToText.isNotListening ? Icons.mic : Icons.pause),
          onPressed: () {
            _speechToText.isNotListening ? _startListening() : _stopListening();
          }),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                focusNode: _titleFocusNode,
                maxLength: 150,
                maxLines: 1,
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Title",
                  counter: Container(),
                  border: InputBorder.none,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: TextFormField(
                  expands: true,
                  autofocus: true,
                  focusNode: _messageFocusNode,
                  maxLines: null,
                  controller: messageController,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Note",
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}
