class Note {
  int id;
  int date;
  String title;
  String content;

  Note();

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    title = map['title'];
    content = map['content'];
  }

  toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'title': title,
      'content': content,
    };
  }
}
