import 'package:flutter/material.dart';
import 'database.dart';
import 'note.dart';
import 'note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Note> notes;
  bool loading = true;

  @override
  void initState() {
    update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Note buffNote = new Note();
                buffNote.content = "";
                buffNote.title = "";
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NoteScreen(note: buffNote))) //
                    .then((value) => update());
              }),
        ],
      ),
      backgroundColor: Colors.black,
      body: loading
          ? Loading()
          : ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 0, color: Colors.black),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note note = notes[index];
                return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        delete(notes[index]);
                        notes.removeAt(index);
                      });
                    },
                    background: Container(color: Colors.black),
                    child: Container(
                        constraints: BoxConstraints(
                            maxHeight: 75,
                            maxWidth: 500.0,
                            minWidth: 300.0,
                            minHeight: 0),
                        color: Colors.black,
                        child: ListTile(
                          title: Text(
                            note.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'RobotoSlab',
                                fontWeight: FontWeight.w200),
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            note.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w100),
                          ),
                          onTap: () {
                            setState(() => this.loading = true);
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NoteScreen(note: note)))
                                .then((value) => update());
                          },
                        )));
              },
            ),
    );
  }

  Future delete(Note note) async {
    await DatabaseService().delete(note);
  }

  Future update() async {
    notes = await DatabaseService().getNotes();
    setState(() => loading = false);
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
