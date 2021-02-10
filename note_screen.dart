import 'package:flutter/material.dart';
import 'database.dart';
import 'home_screen.dart';
import 'note.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  NoteScreen({this.note});

  @override
  EditNoteScreenState createState() => EditNoteScreenState();
}

class EditNoteScreenState extends State<NoteScreen> {
  TextEditingController title;
  TextEditingController content;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    title = new TextEditingController();
    content = new TextEditingController();
    title.text = widget.note.title;
    content.text = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              save();
              Navigator.pop(context);
            }),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              delete();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: loading
          ? Loading()
          : ListView(children: <Widget>[
              TextField(
                maxLines: null,
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontFamily: 'RobotoSlab',
                    fontWeight: FontWeight.normal),
                controller: title,
                cursorColor: Colors.white,
                decoration: new InputDecoration(
                  hintStyle: TextStyle(fontSize: 30.0, color: Colors.grey[900]),
                  fillColor: Colors.white,
                  hintText: "Title",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                ),
              ),
              TextField(
                controller: content,
                maxLines: null,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100),
                decoration: new InputDecoration(
                    hintStyle:
                        TextStyle(fontSize: 20.0, color: Colors.grey[900]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "text"),
              )
            ]),
    );
  }

  Future delete() async {
    await DatabaseService().delete(widget.note);
  }

  Future save() async {
    if (widget.note.content == "" && widget.note.title == "") {
      widget.note.content = content.text;
      widget.note.title = title.text;
      if (widget.note.content != "") {
        await DatabaseService().add(widget.note);
        setState(() => loading = false);
        return;
      } else
        return;
    }
    widget.note.content = content.text;
    widget.note.title = title.text;
    if (widget.note.content != "") {
      await DatabaseService().update(widget.note);
      setState(() => loading = false);
    }
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
