import 'package:flutter/material.dart';
import '\Note.dart';
import '../services/db_handler.dart';
import '../models/note.dart';

class Notes extends StatefulWidget {
  final ScrollController controller;
  const Notes({Key? key, required this.controller}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late DatabaseHandler _databaseHandler;

  @override
  void initState() {
    super.initState();
    this._databaseHandler = DatabaseHandler();
    this._databaseHandler.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: this._databaseHandler.getNotes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    controller: widget.controller,
                    padding: EdgeInsets.all(8.0),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 5.0,
                      );
                    },
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 9.0),
                            child: Icon(Icons.delete_forever_rounded),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        onDismissed: (_) async {
                          await this
                              ._databaseHandler
                              .deleteNote(snapshot.data![index].id!);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        key: ValueKey<int?>(snapshot.data![index].id!),
                        child: NoteWidget(
                          title: snapshot.data![index].title,
                          desc: snapshot.data![index].body,
                          image: snapshot.data![index].picture,
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
