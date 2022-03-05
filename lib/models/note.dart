class Note {
  int? id;
  String title;
  String? picture;
  String? body;
  String? audio;

  Note({
    this.id,
    required this.title,
    this.picture,
    this.body,
    this.audio,
  });

  int? get noteId => id;
  String get noteTitle => title;
  String? get notePicture => picture;
  String? get noteBody => body;
  String? get noteAudio => audio;

  factory Note.fromMap(Map<String, dynamic> data) => new Note(
        id: data["id"],
        title: data["title"],
        picture: data["picture"],
        body: data["body"],
        audio: data["audio"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "picture": picture,
        "body": body,
        "audio": audio,
      };
}
