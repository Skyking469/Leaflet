class Task {
  int? id;
  String title;
  String date;
  String? location;
  int? isDone;

  Task({
    this.id,
    required this.title,
    required this.date,
    this.location,
    required this.isDone,
  });

  int? get taskId => id;
  String get taskTitle => title;
  String get taskDate => date;
  String? get taskLocation => location;
  int? get taskIsDone => isDone;

  factory Task.fromMap(Map<String, dynamic> data) => new Task(
        id: data["id"],
        title: data["title"],
        date: data["date"],
        location: data["location"],
        isDone: data["isDone"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "date": date,
        "location": location,
        "isDone": isDone,
      };
}
