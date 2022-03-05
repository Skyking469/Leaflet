import 'package:flutter/material.dart';
import '../services/db_handler.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class Tasks extends StatefulWidget {
  final ScrollController controller;
  const Tasks({Key? key, required this.controller}) : super(key: key);

  @override
  TasksState createState() => TasksState();
}

class TasksState extends State<Tasks> {
  late DatabaseHandler _databaseHandler;

  @override
  void initState() {
    super.initState();
    this._databaseHandler = DatabaseHandler();
    this._databaseHandler.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  bool _intbool(int a) {
    if (a == 1) return true;
    return false;
  }

  int _boolint(bool a) {
    if (a) return 1;
    return 0;
  }

  String dueDate(String date) {
    DateTime taskDate = DateFormat("M/D/yyyy").parse(date);
    int n = taskDate.difference(DateTime.now()).inDays;
    if (n == 0) {
      return "Due today ";
    } else if (n < 0) {
      return "Late by ${n.abs()} days ";
    }
    return "Due in $n days ";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: this._databaseHandler.getTasks(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: widget.controller,
                    padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data?.length,
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
                              .deleteTask(snapshot.data![index].id!);
                          setState(() {
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        key: ValueKey<int?>(snapshot.data![index].id!),
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              visualDensity: VisualDensity.compact,
                              shape: CircleBorder(side: BorderSide.none),
                              value: _intbool(snapshot.data![index].isDone!),
                              onChanged: (bool? value) async {
                                Task updated = Task(
                                    id: snapshot.data![index].id,
                                    title: snapshot.data![index].title,
                                    date: snapshot.data![index].date,
                                    location: snapshot.data![index].location,
                                    isDone: _boolint(value!));
                                await this._databaseHandler.updateTask(updated);
                                setState(() {});
                              },
                            ),
                            title: Text(
                              snapshot.data![index].title,
                              style: TextStyle(
                                color: snapshot.data![index].isDone == 1
                                    ? Theme.of(context).backgroundColor
                                    : Colors.white,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  dueDate(snapshot.data![index].date),
                                  style: TextStyle(
                                    color: snapshot.data![index].isDone == 1
                                        ? Theme.of(context).backgroundColor
                                        : Colors.white,
                                  ),
                                ),
                                snapshot.data![index].location != null
                                    ? Icon(
                                        Icons.location_pin,
                                        color: snapshot.data![index].isDone == 1
                                            ? Theme.of(context).backgroundColor
                                            : Colors.white,
                                        size: 13,
                                      )
                                    : Text(""),
                                Text(
                                  snapshot.data![index].location ?? '',
                                  style: TextStyle(
                                    color: snapshot.data![index].isDone == 1
                                        ? Theme.of(context).backgroundColor
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
