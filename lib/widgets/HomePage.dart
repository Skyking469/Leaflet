import 'package:flutter/material.dart';
import 'package:leaflet/widgets/NewNote.dart';
import 'Notes.dart';
import 'Tasks.dart';
import 'NewTask.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _controller = ScrollController();
  bool _fabIsVisible = true;
  int _selectedIndex = 0;

  void stateSet() {
    setState(() {});
  }

  void _new(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      elevation: 5.0,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height - 150,
      ),
      enableDrag: true,
      context: ctx,
      builder: (ctx) => _selectedIndex == 0
          ? NewTask(
              parentState: stateSet,
            )
          : NewNote(
              parentState: stateSet,
            ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _fabIsVisible =
            _controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Leaflet",
            style: TextStyle(color: Colors.green[900], fontSize: 35),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _selectedIndex == 0
            ? Tasks(
                controller: _controller,
              )
            : Notes(
                controller: _controller,
              ),
        floatingActionButton: _fabIsVisible
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  _new(context);
                },
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_rounded),
              label: "Tasks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notes_rounded),
              label: "Notes",
            ),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ));
  }
}
